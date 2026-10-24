-- Read-only actor appearance inventory. No writes, native calls, entity enumeration, or saves.
local lines={"schema_version=1","probe_id=actor-appearance","probe_version=1.0.0","evidence_state=observed","collection_status=started","limitations=surface inventory only; no semantic or writable-field claim"}
local function result(label,value) table.insert(lines,label.."\t"..tostring(value)) end
local function check(label,fn)
  local ok,value=pcall(fn)
  if ok then result(label,type(value).."="..tostring(value)) else result(label,"error="..tostring(value)) end
end
check("runtime.ecs",function() return runtime.ecs end)
check("runtime.ecs.get_registry",function() return runtime.ecs.get_registry end)
check("game.assets.get_resources_by_type",function() return game.assets.get_resources_by_type end)
for _,type_name in ipairs({"keen::ItemInfo","keen::RenderModel","keen::ecs::TemplateResource","keen::CharacterAppearanceResource","keen::PlayerAppearanceResource","keen::ActorAppearanceResource"}) do
  check("resource_family:"..type_name,function()
    local resources=game.assets.get_resources_by_type(type_name)
    return "count="..tostring(#resources)
  end)
end
for _,path in ipairs({"appearance","appearance.hair","appearance.facialHair","appearance.body","appearance.scale","hair","facialHair","bodyScale","model","mesh","materials","attachments"}) do
  result("candidate_field",path)
end
result("writes","not_attempted")
result("entities","not_enumerated")
result("saves","not_accessed")
lines[5]="collection_status=completed"
local ok_export,export_error=pcall(function() io.export("embervault/actor-appearance-inventory-v1.tsv",table.concat(lines,"\n").."\n") end)
if not ok_export then print("EMBERVAULT_ACTOR_APPEARANCE|EXPORT_ERROR|"..tostring(export_error)) end
