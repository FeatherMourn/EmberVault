-- Read-only loot and pickup census. No entity enumeration, IDs, writes, native calls, or saves.
local lines={
  "schema_version=1",
  "probe_id=loot-pickup-census",
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
check("runtime.ecs.get_registry",function() return runtime.ecs.get_registry ~= nil end)
check("runtime.ecs.query",function() return runtime.ecs.query ~= nil end)
check("runtime.ecs.read_fields",function() return runtime.ecs.read_fields ~= nil end)

local surfaces={
  "keen::ecs::PlayerFocus",
  "keen::ecs::ClientPlayerFocus",
  "keen::ecs::PlayerInRange",
  "keen::ecs::CheckPlayerInRange",
  "keen::ecs::IsLocalPlayerInRange",
  "keen::ecs::ItemState",
  "keen::ecs::Equipment"
}

for _,name in ipairs(surfaces) do
  check("component_surface:"..name,function()
    local result=runtime.ecs.query(name)
    if result == nil then return "nil" end
    if type(result)=="table" then return "table_count="..tostring(#result) end
    return type(result)
  end)
end

add("loot_event_schema","represented_only; no event subscription attempted")
add("local_player_accessor","not_found_in_supported_surface_scan")
add("item_instance_owner","not_read_without_authoritative_player_context")
add("classification","availability_probe_only")

local ok_export,export_error=pcall(function()
  io.export("embervault/loot-pickup-census-v1.tsv",table.concat(lines,"\n").."\n")
end)
if not ok_export then print("EMBERVAULT_LOOT_PICKUP_CENSUS|EXPORT_ERROR|"..tostring(export_error)) end
