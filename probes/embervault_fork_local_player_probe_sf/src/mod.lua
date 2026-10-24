local done = false
local attempts = 0
local max_attempts = 90

return {
  update_interval_ms = 1000,
  on_update = function()
    if done then return end
    attempts = attempts + 1
    local ok, player, reason = pcall(function()
      return runtime.ecs.get_local_player()
    end)
    if not ok then
      if attempts < max_attempts then return end
      reason = "accessor_error=" .. tostring(player)
      player = nil
    end
    if player == nil and attempts < max_attempts then return end
    local lines = {
      "schema_version=1",
      "probe_id=fork-local-player-accessor",
      "probe_version=1.0.7",
      "evidence_state=observed",
      "attempts=" .. tostring(attempts),
      "read_only=true",
      "writes=not_attempted",
      "saves=not_accessed",
      "entity_enumeration=bounded_component_queries_only",
      "native_calls=not_attempted"
    }
    if player ~= nil then
      lines[#lines + 1] = "status=available"
      lines[#lines + 1] = "entityId=" .. tostring(player.entityId)
      lines[#lines + 1] = "generation=" .. tostring(player.generation)
      lines[#lines + 1] = "sequence=" .. tostring(player.sequence)
      lines[#lines + 1] = "handle_present=" .. tostring(player.handle ~= nil)
      local ok_components, components, components_reason = pcall(function()
        return runtime.ecs.get_components()
      end)
      if ok_components and components ~= nil then
        local matched = 0
        for _, component_type in ipairs(components) do
          local name = tostring(component_type.qualified_name or component_type.name or component_type)
          if string.find(string.lower(name), "inventory", 1, true)
            or string.find(string.lower(name), "equipment", 1, true)
            or string.find(string.lower(name), "item", 1, true)
            or string.find(string.lower(name), "perk", 1, true)
            or string.find(string.lower(name), "socket", 1, true)
            or string.find(string.lower(name), "gem", 1, true) then
            lines[#lines + 1] = "candidate_component=" .. name
            matched = matched + 1
          end
        end
        lines[#lines + 1] = "candidate_component_count=" .. tostring(matched)
      else
        lines[#lines + 1] = "candidate_component_scan=unavailable|reason=" .. tostring(components_reason or components)
      end
      local candidates = {
        "keen::ecs::Equipment",
        "keen::ecs::RenderEquipment",
        "keen::ecs::PerkContainer",
        "keen::ecs::PerkContainerNew",
        "keen::ecs::WeaponGemSlot",
        "keen::ecs::ItemState",
        "keen::ecs::DefaultInventory",
        "keen::ecs::InventorySetup",
        "keen::ecs::DynamicItemCollectionComponent",
        "keen::ecs::Inventory",
      }
      local pending_query = false
      for _, component in ipairs(candidates) do
        local ok_read, value, read_reason = pcall(function()
          return runtime.ecs.read(player.handle, component)
        end)
        if ok_read and value ~= nil then
          lines[#lines + 1] = "component=" .. component .. "|status=readable"
        elseif ok_read then
          lines[#lines + 1] = "component=" .. component .. "|status=unavailable|reason=" .. tostring(read_reason)
        else
          lines[#lines + 1] = "component=" .. component .. "|status=error|reason=" .. tostring(value)
        end
        local ok_query, entities, query_reason = pcall(function()
          return runtime.ecs.query(component)
        end)
        if ok_query and entities ~= nil then
          local owns = false
          for _, entity in ipairs(entities) do
            if entity == player.handle then owns = true end
          end
          lines[#lines + 1] = "query=" .. component .. "|count=" .. tostring(#entities) .. "|player_handle_match=" .. tostring(owns)
          local link_fields = {"linksEntities", "slots", "defaultInventory", "equipmentVisuals", "weaponGem", "ownerEntityId", "playerEntityId", "parentEntityId", "inventoryId", "itemId", "slotId", "level", "count"}
          for _, field in ipairs(link_fields) do
            local readable = 0
            local player_matches = 0
            for i = 1, math.min(#entities, 8) do
              local ok_field, values = pcall(function()
                return runtime.ecs.read_fields(entities[i], component, {field})
              end)
              if ok_field and values ~= nil and values[field] ~= nil then
                readable = readable + 1
                local raw = values[field]
                if raw == player.entityId or raw == player.handle then
                  player_matches = player_matches + 1
                elseif type(raw) == "table" then
                  for _, entry in pairs(raw) do
                    local candidate = entry
                    if type(entry) == "table" then candidate = entry.id or entry.entityId or entry.value end
                    if candidate == player.entityId or candidate == player.handle then player_matches = player_matches + 1; break end
                  end
                end
              end
            end
            if readable > 0 then
              lines[#lines + 1] = "link=" .. component .. "." .. field .. "|sample_readable=" .. tostring(readable) .. "|player_matches=" .. tostring(player_matches)
            end
          end
        elseif ok_query then
          lines[#lines + 1] = "query=" .. component .. "|status=unavailable|reason=" .. tostring(query_reason)
          if string.find(tostring(query_reason), "scanning", 1, true) then pending_query = true end
        else
          lines[#lines + 1] = "query=" .. component .. "|status=error|reason=" .. tostring(entities)
        end
      end
      if pending_query and attempts < max_attempts then return end
    else
      lines[#lines + 1] = "status=unavailable"
      lines[#lines + 1] = "reason=" .. tostring(reason)
    end
    pcall(function()
      io.export("embervault/fork-local-player-accessor-v4.tsv", table.concat(lines, "\n") .. "\n")
    end)
    done = true
  end,
}
