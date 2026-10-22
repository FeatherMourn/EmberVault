-- Read-only ECS inventory/equipment probe. No entity enumeration, writes, natives, or saves.
local reported = false
local attempts = 0
local max_attempts = 90

local function run_probe()
local lines = {
  "schema_version=1",
  "probe_id=inventory-ecs",
  "probe_version=1.0.0",
  "evidence_state=observed",
  "limitations=capability and reflected component metadata only; player ownership and writable fields remain unproven"
}

local function add(label, value) table.insert(lines, label .. "\t" .. tostring(value)) end
local function safe(label, fn)
  local ok, value = pcall(fn)
  if ok then add(label, value) else add(label, "error=" .. tostring(value)) end
end

safe("ecs.type", function() return type(runtime.ecs) end)
safe("ecs.get_registry", function() return type(runtime.ecs.get_registry) end)
safe("ecs.get_component", function() return type(runtime.ecs.get_component) end)
safe("ecs.registry", function() return type(runtime.ecs.get_registry()) end)

local needles = {"inventory", "equipment", "iteminstance", "perk", "gem", "socket", "attribute"}
local function match(name)
  local text = string.lower(tostring(name))
  for _, needle in ipairs(needles) do
    if string.find(text, needle, 1, true) then return needle end
  end
end

local ok_types, all = pcall(function() return runtime.types.get_all() end)
if ok_types and type(all) == "table" then
  local count = 0
  for key, value in pairs(all) do
    count = count + 1
    local hit = match(key) or match(value)
    if hit then add("candidate_type", hit .. "\t" .. tostring(key) .. "\t" .. tostring(value)) end
  end
  add("reflected_type_count", count)
else
  add("reflected_types", "unavailable=" .. tostring(all))
end

for _, type_name in ipairs({
  "keen::ItemInstanceInfo",
  "keen::EquipmentSlotData",
  "keen::ecs::Equipment",
  "keen::DefaultInventoryReference",
  "keen::ecs::InventoryTest",
  "keen::PerkId",
  "keen::WeaponGemActionType"
}) do
  local found = false
  if ok_types and type(all) == "table" then
    for key, value in pairs(all) do
      if tostring(key) == type_name or tostring(value) == type_name then found = true end
    end
  end
  add("reflected_target", type_name .. "\t" .. tostring(found))
end

add("player_owner", "not_resolved")
add("entities", "not_enumerated")
add("writes", "not_attempted")
add("saves", "not_accessed")

local ok_export, export_error = pcall(function()
  io.export("embervault/inventory-ecs-v1.tsv", table.concat(lines, "\n") .. "\n")
end)
if not ok_export then print("EMBERVAULT_INVENTORY_ECS|EXPORT_ERROR|" .. tostring(export_error)) end
end

return {
  update_interval_ms = 1000,
  on_update = function()
    if reported then return end
    attempts = attempts + 1
    local ok, registry = pcall(function() return runtime.ecs.get_registry() end)
    if (not ok or registry == nil) and attempts < max_attempts then return end
    reported = true
    run_probe()
  end,
}
