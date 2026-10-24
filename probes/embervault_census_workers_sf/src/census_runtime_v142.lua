local Scheduler = require("ecs_read_scheduler")
local Snapshot = require("ecs_snapshot")
local M = {}
local function read_fields(runtime, entity, component, fields)
  local ok, values, reason = pcall(function() return runtime.ecs.read_fields(entity, component, fields) end)
  if not ok then return false, nil, tostring(values) end
  if values == nil then return false, nil, reason or "component unavailable" end
  return true, values, nil
end
local function player_worker(runtime, output)
  return function()
    local ok, player, reason = pcall(function() return runtime.ecs.get_local_player() end)
    if not ok then return false, nil, tostring(player) end
    if player == nil then return false, nil, reason or "player context scanning" end
    output.player = {entityId=player.entityId, generation=player.generation, sequence=player.sequence, handle=player.handle}
    return true, output.player, nil
  end
end
local function query_worker(runtime, output, component, key, fields, limit)
  local queried, entities = false, nil
  return function()
    if not queried then
      local ok, result, reason = pcall(function() return runtime.ecs.query(component) end)
      if not ok then return false, nil, tostring(result) end
      if result == nil then return false, nil, reason or (key .. " scanning") end
      entities, queried = result, true
    end
    local rows = {}
    for i=1,math.min(#entities, limit or 32) do
      local ok, values, reason = read_fields(runtime, entities[i], component, fields)
      if ok then rows[#rows+1] = {index=i, fields=values} end
      if not ok and reason and string.find(reason, "scanning", 1, true) then return false, nil, reason end
    end
    output[key] = rows
    return true, rows, nil
  end
end

local function item_state_worker(runtime, output)
  local cursor = 1
  local ids = {}
  local seen = {}
  local function collect_rows(rows)
    for _, row in ipairs(rows or {}) do
      for field, value in pairs(row.fields or {}) do
        local candidate = value
        if type(candidate) == "string" then candidate = tonumber(candidate) end
        if (string.find(field, "pide", 1, true) or string.find(field, "itemId", 1, true)) and type(candidate) == "number" and candidate > 0 and not seen[candidate] then
          seen[candidate] = true
          ids[#ids + 1] = candidate
          if #ids >= 16 then return true end
        end
      end
    end
    return #ids >= 16
  end
  return function()
    if #ids == 0 then
      if collect_rows(output.populated_inventories) then
        -- Keep the bounded cap; no second source is needed.
      else
        collect_rows(output.linked_inventories)
      end
    end
    output.item_states = output.item_states or {}
    output.item_state_candidates = ids
    if cursor > #ids then return true, output.item_states, nil end
    local id = ids[cursor]
    cursor = cursor + 1
    local ok_resolve, handle, resolve_reason = pcall(function() return runtime.ecs.resolve(id) end)
    if not ok_resolve then
      output.item_states[#output.item_states + 1] = {id=id, status="resolve_error", reason=tostring(resolve_reason or handle)}
      return cursor > #ids, output.item_states, nil
    end
    if handle == nil then
      output.item_states[#output.item_states + 1] = {id=id, status="unavailable", reason=tostring(resolve_reason or "item entity unavailable")}
      return cursor > #ids, output.item_states, nil
    end
    local ok, values, reason = read_fields(runtime, handle, "keen::ecs::ItemState", {
      "containedInSlotId", "itemId", "itemLevelUi", "itemRarityUi", "baseDamageUi",
    })
    if ok then output.item_states[#output.item_states + 1] = {id=id, status="readable", fields=values}
    else output.item_states[#output.item_states + 1] = {id=id, status="unavailable", reason=tostring(reason or "")} end
    if not ok and reason and string.find(reason, "scanning", 1, true) then return false, nil, reason end
    return cursor > #ids, output.item_states, nil
  end
end

local function player_state_worker(runtime, output)
  local attempted = false
  return function()
    if attempted then return true, output.player_state, nil end
    attempted = true
    output.player_state = {}
    local player = output.player
    if not player then return false, nil, "player context unavailable; retry" end
    local components = {
      {name="keen::ecs::Level", fields={"dataStorage"}},
      {name="keen::ecs::SpecialAbility", fields={"dataStorage"}},
      {name="keen::ecs::DamageModSkillShot", fields={"dataStorage"}},
      {name="keen::ecs::AttributeComponent", fields={"attributes", "dataStorage"}},
      {name="keen::ecs::BuffContainer", fields={"buffs", "activeEffects"}},
      {name="keen::ecs::Durability", fields={"current", "maximum"}},
      {name="keen::ecs::Progression", fields={"levels", "unlocks", "experience"}},
    }
    for _, spec in ipairs(components) do
      local ok, values, reason = read_fields(runtime, output.player.handle, spec.name, spec.fields)
      if ok then output.player_state[#output.player_state + 1] = {component=spec.name, status="readable", fields=values}
      else output.player_state[#output.player_state + 1] = {component=spec.name, status="unavailable", reason=tostring(reason or "")} end
    end
    return true, output.player_state, nil
  end
end

local function slot_schema_worker(runtime, output)
  local attempted = false
  local targets = {
    "keen::ecs::Inventory",
    "keen::ItemStack",
    "keen::ItemData",
    "keen::ItemId",
  }
  return function()
    if attempted then return true, output.slot_schema, nil end
    attempted = true
    output.slot_schema = {}
    if not runtime.types or not runtime.types.resolve then return true, output.slot_schema, "type reflection unavailable" end
    for _, name in ipairs(targets) do
      local ok, ty = pcall(function() return runtime.types.resolve(name) end)
      local row = {type=name, status="unavailable"}
      if ok and ty ~= nil then
        row.status = "resolved"
        row.fields = {}
        for _, field in ipairs(ty.fields or {}) do
          row.fields[#row.fields + 1] = {
            name=field.name,
            type=field.type and field.type.qualified_name or "unknown",
            offset=field.data_offset,
          }
        end
      end
      output.slot_schema[#output.slot_schema + 1] = row
    end
    return true, output.slot_schema, nil
  end
end

local function linked_inventory_worker(runtime, output)
  local done = false
  return function()
    if done then return true, output.linked_inventories, nil end
    local rows = {}
    for _, link in ipairs(output.inventory_links or {}) do
      local link_ids = {}
      for field, value in pairs(link.fields or {}) do
        if string.find(field, "linksEntities", 1, true) and string.find(field, ".id", 1, true) and type(value) == "number" and value > 0 then
          link_ids[#link_ids + 1] = value
        end
      end
      for _, id in ipairs(link_ids) do
      if type(id) == "number" and id > 0 and #rows < 32 then
        local ok_resolve, handle, reason = pcall(function() return runtime.ecs.resolve(id) end)
        if ok_resolve and handle ~= nil then
          local ok, values, read_reason = read_fields(runtime, handle, "keen::ecs::Inventory", {
            "slots[1].id.value", "slots[1].data.count", "slots[1].data.pide.id", "slots[1].data.pide", "slots[1].data.item.value", "slots[1].data.item", "slots[1].data.itemId.value", "slots[1].data.itemId", "slots[1].itemId",
            "slots[2].id.value", "slots[2].data.count", "slots[2].data.pide.id", "slots[2].data.pide", "slots[2].data.item.value", "slots[2].data.item", "slots[2].data.itemId.value", "slots[2].data.itemId", "slots[2].itemId",
            "slots[3].id.value", "slots[3].data.count", "slots[3].data.pide.id", "slots[3].data.pide", "slots[3].data.item.value", "slots[3].data.item", "slots[3].data.itemId.value", "slots[3].data.itemId", "slots[3].itemId",
            "slots[4].id.value", "slots[4].data.count", "slots[4].data.pide.id", "slots[4].data.pide", "slots[4].data.item.value", "slots[4].data.item", "slots[4].data.itemId.value", "slots[4].data.itemId", "slots[4].itemId",
          })
          rows[#rows + 1] = {
            id=id,
            resolved=true,
            status=ok and "readable" or "unavailable",
            fields=values,
            reason=read_reason,
          }
        else
          rows[#rows + 1] = {id=id, resolved=false, status="resolve_error", reason=tostring(reason or handle)}
        end
      end
      end
    end
    output.linked_inventories = rows
    done = true
    return true, rows, nil
  end
end
function M.create(runtime, options)
  options = options or {}
  local output = {schema_version=1, read_only=true, writes="not_attempted", saves="not_accessed"}
  local snapshot = Snapshot.new(runtime)
  local read_runtime = {ecs={
    get_local_player=function() return runtime.ecs.get_local_player() end,
    query=function(component) return snapshot:query(component) end,
    read_fields=function(entity, component, fields) return snapshot:read_fields(entity, component, fields) end,
    resolve=function(id) return runtime.ecs.resolve(id) end,
  }, types=runtime.types}
  local scheduler = Scheduler.new(runtime, {timeout_seconds=options.timeout_seconds or 90, max_items_per_job=options.max_items_per_job or 32})
  scheduler:add("player-context", player_worker(read_runtime, output), {timeout_seconds=180})
  scheduler:add("player-state", player_state_worker(read_runtime, output), {timeout_seconds=60})
  scheduler:add("slot-schema", slot_schema_worker(read_runtime, output), {timeout_seconds=30})
  scheduler:add("inventory-links", query_worker(read_runtime, output, "keen::ecs::InventorySetup", "inventory_links", {"linksEntities[1].id", "linksEntities[2].id", "linksEntities[3].id", "linksEntities[4].id", "linksCategories[1]", "linksCategories[2]", "linksCategories[3]", "linksCategories[4]", "genericSlotCount", "availableSlotCount", "isInitialized"}, 32))
  scheduler:add("inventory-scan", query_worker(read_runtime, output, "keen::ecs::Inventory", "populated_inventories", {
    "slots[1].id.value", "slots[1].data.count", "slots[1].data.pide.id", "slots[1].data.pide", "slots[1].data.itemId", "slots[1].itemId",
    "slots[2].id.value", "slots[2].data.count", "slots[2].data.pide.id", "slots[2].data.pide", "slots[2].data.itemId", "slots[2].itemId",
    "slots[3].id.value", "slots[3].data.count", "slots[3].data.pide.id", "slots[3].data.pide", "slots[3].data.itemId", "slots[3].itemId",
    "slots[4].id.value", "slots[4].data.count", "slots[4].data.pide.id", "slots[4].data.pide", "slots[4].data.itemId", "slots[4].itemId",
  }, 32))
  scheduler:add("linked-inventory-scan", linked_inventory_worker(read_runtime, output), {timeout_seconds=120})
  scheduler:add("item-state", item_state_worker(read_runtime, output), {timeout_seconds=120})
  scheduler:add("equipment", query_worker(read_runtime, output, "keen::ecs::Equipment", "equipment", {"armor", "mainHand", "offHand", "ring1", "ring2", "glider", "spells"}, 32))
  scheduler:add("default-inventory", query_worker(read_runtime, output, "keen::ecs::DefaultInventory", "default_inventory", {}, 32))
  scheduler:add("perk-container", query_worker(read_runtime, output, "keen::ecs::PerkContainerNew", "perk_containers", {}, 32))
  scheduler:add("weapon-gem-slot", query_worker(read_runtime, output, "keen::ecs::WeaponGemSlot", "weapon_gem_slots", {}, 32))
  scheduler:add("equipment-links", query_worker(read_runtime, output, "keen::ecs::PackedEquipmentSlotEntityIds", "equipment_links", {}, 8), {timeout_seconds=30})
  return {output=output, update=function() local complete=scheduler:step(); output.workers=scheduler:summary(); output.snapshot=snapshot:stats(); return complete, output end}
end
return M
