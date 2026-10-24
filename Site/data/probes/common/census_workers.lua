-- EmberVault read-only census worker definitions.
-- Each worker returns (done, result, reason) for ecs_read_scheduler.lua.

local Workers = {}

local function field_read(runtime, entity, component, fields)
  local ok, values, reason = pcall(function()
    return runtime.ecs.read_fields(entity, component, fields)
  end)
  if not ok then return false, nil, tostring(values) end
  if values == nil then return false, nil, reason or "component unavailable" end
  return true, values, nil
end

function Workers.player_context(runtime, output)
  return function()
    local ok, player, reason = pcall(function() return runtime.ecs.get_local_player() end)
    if not ok then return false, nil, tostring(player) end
    if player == nil then return false, nil, reason or "player context scanning" end
    output.player = {
      entityId = player.entityId,
      generation = player.generation,
      sequence = player.sequence,
    }
    return true, output.player, nil
  end
end

function Workers.inventory_links(runtime, output, options)
  options = options or {}
  local max_entities = options.max_entities or 160
  local queried = false
  local entities
  return function()
    if not queried then
      local ok, result, reason = pcall(function() return runtime.ecs.query("keen::ecs::InventorySetup") end)
      if not ok then return false, nil, tostring(result) end
      if result == nil then return false, nil, reason or "inventory links scanning" end
      entities = result
      queried = true
    end
    local links = {}
    for i = 1, math.min(#entities, max_entities) do
      local ok, values, reason = field_read(runtime, entities[i], "keen::ecs::InventorySetup", {
        "linksEntities[1].id", "linksEntities[2].id", "linksEntities[3].id",
        "linksCategories[1]", "genericSlotCount", "availableSlotCount", "isInitialized",
      })
      if ok then links[#links + 1] = {index = i, fields = values} end
      if not ok and reason and string.find(reason, "scanning", 1, true) then
        return false, nil, reason
      end
    end
    output.inventory_links = links
    return true, links, nil
  end
end

function Workers.inventory_scan(runtime, output, options)
  options = options or {}
  local max_entities = options.max_entities or 160
  local queried = false
  local entities
  return function()
    if not queried then
      local ok, result, reason = pcall(function() return runtime.ecs.query("keen::ecs::Inventory") end)
      if not ok then return false, nil, tostring(result) end
      if result == nil then return false, nil, reason or "inventory registry scanning" end
      entities = result
      queried = true
    end
    local populated = {}
    for i = 1, math.min(#entities, max_entities) do
      local ok, values, reason = field_read(runtime, entities[i], "keen::ecs::Inventory", {
        "slots[1].id.value", "slots[1].data.count", "slots[1].data.pide.id",
        "slots[2].id.value", "slots[2].data.count", "slots[2].data.pide.id",
        "slots[3].id.value", "slots[3].data.count", "slots[3].data.pide.id",
        "slots[4].id.value", "slots[4].data.count", "slots[4].data.pide.id",
      })
      if ok then
        local has_value = false
        for _, value in pairs(values) do
          if type(value) == "number" and value > 0 then has_value = true; break end
        end
        if has_value then populated[#populated + 1] = {index = i, fields = values} end
      elseif reason and string.find(reason, "scanning", 1, true) then
        return false, nil, reason
      end
    end
    output.populated_inventories = populated
    return true, populated, nil
  end
end

function Workers.item_state(runtime, output, options)
  options = options or {}
  local max_items = options.max_items or 16
  local cursor = 1
  local items = options.item_entity_ids or {}
  return function()
    if cursor > math.min(#items, max_items) then
      output.item_states = output.item_states or {}
      return true, output.item_states, nil
    end
    local id = items[cursor]
    cursor = cursor + 1
    local ok_resolve, handle, resolve_reason = pcall(function() return runtime.ecs.resolve(id) end)
    if not ok_resolve or handle == nil then return false, nil, resolve_reason or "item entity unavailable" end
    local ok, values, reason = field_read(runtime, handle, "keen::ecs::ItemState", {
      "containedInSlotId", "itemId", "itemLevelUi", "itemRarityUi", "baseDamageUi",
    })
    if ok then
      output.item_states = output.item_states or {}
      output.item_states[#output.item_states + 1] = {id = id, fields = values}
    elseif reason and string.find(reason, "scanning", 1, true) then
      return false, nil, reason
    end
    return cursor > math.min(#items, max_items), output.item_states, nil
  end
end

function Workers.equipment(runtime, output, options)
  options = options or {}
  local max_entities = options.max_entities or 160
  local queried = false
  local entities
  return function()
    if not queried then
      local ok, result, reason = pcall(function() return runtime.ecs.query("keen::ecs::Equipment") end)
      if not ok then return false, nil, tostring(result) end
      if result == nil then return false, nil, reason or "equipment registry scanning" end
      entities = result
      queried = true
    end
    local readable = {}
    for i = 1, math.min(#entities, max_entities) do
      local ok, values, reason = field_read(runtime, entities[i], "keen::ecs::Equipment", {
        "armor", "mainHand", "offHand", "ring1", "ring2", "glider", "spells",
      })
      if ok then readable[#readable + 1] = {index = i, fields = values} end
      if reason and string.find(reason, "scanning", 1, true) then return false, nil, reason end
    end
    output.equipment = readable
    return true, readable, nil
  end
end

return Workers
