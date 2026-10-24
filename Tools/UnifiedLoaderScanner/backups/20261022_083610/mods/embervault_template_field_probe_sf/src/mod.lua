-- Bounded read-only template/model field search. No entities, writes, natives, or saves.
local lines={"schema_version=1","probe_id=template-field","probe_version=1.0.0","evidence_state=observed","collection_status=started","limitations=bounded field-presence sample; no semantic or writable-field claim"}
local paths={"components","appearance","hair","facialHair","body","scale","model","mesh","materials","textures","attachments","visualEntity","visualModel","placedEntity"}
local function present(data,path)
  local ok,value=pcall(function()
    local current=data
    for part in string.gmatch(path,"[^%.]+") do current=current[part] end
    return current
  end)
  if not ok then return "error" end
  if value==nil then return "missing" end
  return type(value)
end
local function scan(type_name,limit)
  local ok,resources=pcall(function() return game.assets.get_resources_by_type(type_name) end)
  if not ok or type(resources)~="table" then table.insert(lines,"error\t"..type_name.."\t"..tostring(resources)); return end
  table.insert(lines,"family\t"..type_name.."\tcount="..tostring(#resources).."\tsample_limit="..tostring(limit))
  local n=math.min(#resources,limit)
  for i=1,n do
    local resource=resources[i]
    for _,path in ipairs(paths) do
      local state=present(resource.data,path)
      if state~="missing" then table.insert(lines,"field\t"..type_name.."\t"..tostring(resource.guid).."\t"..path.."\t"..state) end
    end
  end
end
scan("keen::ecs::TemplateResource",250)
scan("keen::RenderModel",250)
table.insert(lines,"entities\tnot_enumerated")
table.insert(lines,"writes\tnot_attempted")
table.insert(lines,"saves\tnot_accessed")
lines[5]="collection_status=completed"
local ok_export,export_error=pcall(function() io.export("embervault/template-field-v1.tsv",table.concat(lines,"\n").."\n") end)
if not ok_export then print("EMBERVAULT_TEMPLATE_FIELD|EXPORT_ERROR|"..tostring(export_error)) end
