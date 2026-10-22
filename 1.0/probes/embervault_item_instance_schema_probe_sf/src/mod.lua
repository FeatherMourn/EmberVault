-- Read-only schema inventory. No entity enumeration, writes, natives, or saves.
local targets = {
  {"keen::ItemInstanceInfo", {"itemId", "level", "durability", "attributes", "perks", "gem", "gems", "sockets"}},
  {"keen::EquipmentSlotData", {"item", "itemId", "itemInstance", "slot", "slotType"}},
  {"keen::ecs::Equipment", {"slots", "equipmentSlots", "items"}},
  {"keen::DefaultInventoryReference", {"inventory", "owner", "reference"}},
  {"keen::PerkCollectionResource", {"perks", "entries"}},
  {"keen::AttributeContainerResource", {"attributes", "entries"}},
  {"keen::ItemRegistryResource", {"items", "entries"}},
  {"keen::DefaultInventoryResource", {"items", "slots", "entries"}}
}

local lines = {
  "schema_version=1",
  "probe_id=item-instance-schema",
  "probe_version=1.0.0",
  "evidence_state=observed",
  "limitations=field presence only; no entity ownership or writable-field claim"
}

local function field_state(data, path)
  local ok, value = pcall(function()
    local current = data
    for part in string.gmatch(path, "[^%.]+") do current = current[part] end
    return current
  end)
  if not ok then return "error" end
  if value == nil then return "missing" end
  return type(value)
end

for _, target in ipairs(targets) do
  local type_name = target[1]
  local ok, resources = pcall(function()
    return game.assets.get_resources_by_type(type_name)
  end)
  if not ok or type(resources) ~= "table" then
    table.insert(lines, "resource_error\t" .. type_name .. "\t" .. tostring(resources))
  else
    table.insert(lines, "resource\t" .. type_name .. "\tcount=" .. tostring(#resources))
    local limit = math.min(#resources, 5)
    for i = 1, limit do
      local data = resources[i].data
      for _, path in ipairs(target[2]) do
        table.insert(lines, "field\t" .. type_name .. "\t" .. tostring(resources[i].guid) .. "\t" .. path .. "\t" .. field_state(data, path))
      end
    end
  end
end

table.insert(lines, "entities\tnot_enumerated")
table.insert(lines, "player_owner\tnot_resolved")
table.insert(lines, "writes\tnot_attempted")
table.insert(lines, "saves\tnot_accessed")

local ok_export, export_error = pcall(function()
  io.export("embervault/item-instance-schema-v1.tsv", table.concat(lines, "\n") .. "\n")
end)
if not ok_export then print("EMBERVAULT_ITEM_INSTANCE_SCHEMA|EXPORT_ERROR|" .. tostring(export_error)) end
