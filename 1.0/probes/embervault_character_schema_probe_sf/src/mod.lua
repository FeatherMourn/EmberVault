-- Read-only exact-schema inventory. No entities, writes, natives, or saves.
local lines={"schema_version=1","probe_id=character-schema","probe_version=1.0.0","evidence_state=observed","collection_status=started","limitations=resource availability and top-level field presence only; no semantic or writable-field claim"}
local targets={
  {"keen::CharacterCustomizationResource",{"presets","hairItems","beardItems","hairColors","eyeColors","eyeBrowColors","skinColors","voices"}},
  {"keen::CharacterPresetResource",{"references","presetId","gender","hairColorPresetId","beardColorPresetId","head","hair","beard","chest","armourHead"}},
  {"keen::ecs::CharacterSetup",{"gender","voicePackId","presetId","hair","beard","hairColorId","beardColorId","skinColor","eyeBrowColor","eyeColor","useNewProportions"}},
  {"keen::ecs::ScaleComponent",{"uniformScale"}}
}
local function state(data,path)
  local ok,value=pcall(function()
    local current=data
    for part in string.gmatch(path,"[^%.]+") do current=current[part] end
    return current
  end)
  if not ok then return "error" end
  if value==nil then return "missing" end
  return type(value)
end
for _,target in ipairs(targets) do
  local type_name=target[1]
  local ok,resources=pcall(function() return game.assets.get_resources_by_type(type_name) end)
  if not ok or type(resources)~="table" then
    table.insert(lines,"family_error\t"..type_name.."\t"..tostring(resources))
  else
    table.insert(lines,"family\t"..type_name.."\tcount="..tostring(#resources))
    local n=math.min(#resources,10)
    for i=1,n do
      for _,path in ipairs(target[2]) do table.insert(lines,"field\t"..type_name.."\t"..tostring(resources[i].guid).."\t"..path.."\t"..state(resources[i].data,path)) end
    end
  end
end
table.insert(lines,"entities\tnot_enumerated")
table.insert(lines,"writes\tnot_attempted")
table.insert(lines,"saves\tnot_accessed")
lines[5]="collection_status=completed"
local ok_export,export_error=pcall(function() io.export("embervault/character-schema-v1.tsv",table.concat(lines,"\n").."\n") end)
if not ok_export then print("EMBERVAULT_CHARACTER_SCHEMA|EXPORT_ERROR|"..tostring(export_error)) end
