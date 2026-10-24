-- Read-only building and voxel census. No entity enumeration, IDs, writes, native calls, or saves.
local lines={
  "schema_version=1",
  "probe_id=building-voxel-census",
  "probe_version=1.0.0",
  "evidence_state=runtime_observation",
  "writes=not_attempted",
  "entity_enumeration=not_attempted",
  "saves=not_accessed",
  "native_calls=not_attempted"
}

local function add(key,value)
  table.insert(lines,key.."\t"..tostring(value))
end

local function check(key,fn)
  local ok,value=pcall(fn)
  if ok then add(key,"ok:"..tostring(value)) else add(key,"error:"..tostring(value)) end
end

check("runtime.ecs",function() return runtime.ecs ~= nil end)
check("runtime.ecs.query",function() return runtime.ecs.query ~= nil end)
check("runtime.ecs.read_fields",function() return runtime.ecs.read_fields ~= nil end)
check("game.assets.get_resources_by_type",function() return game.assets.get_resources_by_type ~= nil end)

local surfaces={
  "keen::ecs::VoxelModel",
  "keen::ecs::VoxelModelVolatile",
  "keen::ecs::VoxelModelResourceComponent",
  "keen::ecs::NoBuildZone",
  "keen::ecs::ClientNoBuildZone",
  "keen::ecs::BuildingLootMemory"
}
for _,name in ipairs(surfaces) do
  check("component_surface:"..name,function()
    local result=runtime.ecs.query(name)
    if result == nil then return "nil" end
    if type(result)=="table" then return "table_count="..tostring(#result) end
    return type(result)
  end)
end

for _,name in ipairs({"keen::VoxelBlueprintItemRegistryResource","keen::VoxelBlueprintConfig"}) do
  check("resource_surface:"..name,function()
    local result=game.assets.get_resources_by_type(name)
    if result == nil then return "nil" end
    if type(result)=="table" then return "table_count="..tostring(#result) end
    return type(result)
  end)
end

add("building_events","represented_only; no event subscription attempted")
add("placement_writes","not_attempted")
add("voxel_persistence","not_tested")
add("classification","availability_probe_only")

local ok_export,export_error=pcall(function()
  io.export("embervault/building-voxel-census-v1.tsv",table.concat(lines,"\n").."\n")
end)
if not ok_export then print("EMBERVAULT_BUILDING_VOXEL_CENSUS|EXPORT_ERROR|"..tostring(export_error)) end
