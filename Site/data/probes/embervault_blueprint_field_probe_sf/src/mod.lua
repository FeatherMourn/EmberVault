-- Read-only bounded blueprint field probe. No mutation, entity enumeration, native calls, or saves.
local lines={"schema_version=1","probe_id=blueprint-fields","probe_version=1.0.0","evidence_state=observed","writes=not_attempted","saves=not_accessed"}
local had_error=false
local function add(...) table.insert(lines,table.concat({...},"\t")) end
local function err(scope,msg) had_error=true; add("error",scope,tostring(msg)) end
local function safe_field(data,path)
  local ok,value=pcall(function()
    local current=data
    for part in string.gmatch(path,"[^%.]+") do current=current[part] end
    return current
  end)
  if not ok then return "error",tostring(value) end
  if value==nil then return "missing","" end
  return "present",type(value)
end
local function scan(type_name,fields)
  local ok,resources=pcall(function() return game.assets.get_resources_by_type(type_name) end)
  if not ok or type(resources)~="table" then err("get_resources_by_type:"..type_name,resources); return end
  add("family",type_name,"count="..tostring(#resources))
  local limit=math.min(#resources,16)
  for i=1,limit do
    local resource=resources[i]
    for _,field in ipairs(fields) do
      local state,value=safe_field(resource.data,field)
      add("field",type_name,tostring(i),field,state,value)
    end
  end
  if #resources>limit then add("bounded",type_name,"sampled="..tostring(limit),"total="..tostring(#resources)) end
end
scan("keen::VoxelBlueprintItemRegistryResource",{"blueprintItems","blueprintItems.1.itemId","blueprintItems.1.size","blueprintItems.1.data","blueprintItems.1.isDataCompressed"})
scan("keen::VoxelBlueprintConfig",{"debugName","snappingConfig","snappingConfig.rules"})
scan("keen::VoxelBlueprintMaterialPoolRegistryResource",{"pools","elements"})
if had_error then lines[4]="evidence_state=partial" end
add("classification","read-only field presence; no semantic or writable claim")
local ok_export,export_error=pcall(function() io.export("embervault/blueprint-fields-v1.tsv",table.concat(lines,"\n").."\n") end)
if not ok_export then print("EMBERVAULT_BLUEPRINT_FIELDS|EXPORT_ERROR|"..tostring(export_error)) end
