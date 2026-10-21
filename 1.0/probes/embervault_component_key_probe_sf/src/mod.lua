-- Bounded read-only key inspection. No entity enumeration, writes, natives, or saves.
local lines={"schema_version=1","probe_id=component-key","probe_version=1.0.0","evidence_state=observed","collection_status=started","limitations=bounded key inventory; no semantic or writable-field claim"}
local function scan(type_name,path,limit)
  local ok,resources=pcall(function() return game.assets.get_resources_by_type(type_name) end)
  if not ok or type(resources)~="table" then table.insert(lines,"error\t"..type_name.."\t"..tostring(resources)); return end
  table.insert(lines,"family\t"..type_name.."\tcount="..tostring(#resources).."\tpath="..path.."\tlimit="..tostring(limit))
  local n=math.min(#resources,limit)
  for i=1,n do
    local resource=resources[i]
    local ok_value,value=pcall(function()
      local current=resource.data
      for part in string.gmatch(path,"[^%.]+") do current=current[part] end
      return current
    end)
    if ok_value and type(value)=="table" then
      local count=0
      for key,nested in pairs(value) do
        count=count+1
        if count<=100 then table.insert(lines,"key\t"..type_name.."\t"..tostring(resource.guid).."\t"..path.."\t"..tostring(key).."\t"..type(nested)) end
      end
    elseif not ok_value then
      table.insert(lines,"error\t"..type_name.."\t"..path.."\t"..tostring(value))
    end
  end
end
scan("keen::ecs::TemplateResource","components",25)
scan("keen::RenderModel","materials",25)
table.insert(lines,"entities\tnot_enumerated")
table.insert(lines,"writes\tnot_attempted")
table.insert(lines,"saves\tnot_accessed")
lines[5]="collection_status=completed"
local ok_export,export_error=pcall(function() io.export("embervault/component-key-v1.tsv",table.concat(lines,"\n").."\n") end)
if not ok_export then print("EMBERVAULT_COMPONENT_KEY|EXPORT_ERROR|"..tostring(export_error)) end
