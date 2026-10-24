local done = false
local attempts = 0
local max_attempts = 90
local query_index = 1
local results = {}

return {
  update_interval_ms = 1000,
  on_update = function()
    if done then return end
    attempts = attempts + 1
    local ok, player, reason = pcall(function() return runtime.ecs.get_local_player() end)
    if not ok then
      if attempts < max_attempts then return end
      reason = "accessor_error=" .. tostring(player)
      player = nil
    end
    if player == nil and attempts < max_attempts then return end
    local lines = {
      "schema_version=1",
      "probe_id=player-state",
      "probe_version=1.3.0",
      "evidence_state=observed",
      "attempts=" .. tostring(attempts),
      "read_only=true",
      "writes=not_attempted",
      "saves=not_accessed",
      "entity_enumeration=bounded_state_component_queries_only",
      "native_calls=not_attempted"
    }
    if player == nil then
      lines[#lines + 1] = "status=unavailable"
      lines[#lines + 1] = "reason=" .. tostring(reason)
    else
      lines[#lines + 1] = "status=player_handle_available"
      lines[#lines + 1] = "handle_present=" .. tostring(player.handle ~= nil)
      local candidates = {
        {"keen::ecs::AttributeComponent", {"rootId", "storageOffset", "flags", "storageCount"}},
        {"keen::ecs::BuffContainer", {"foodBuffs", "genericBuffs", "genericDebuffs", "restedBuff", "terrainDebuff", "hungerStartTime"}},
        {"keen::ecs::BuffComponent", {"buffTypeId", "isDamageSetupSet"}},
        {"keen::ecs::Level", {"dataStorage"}},
        {"keen::ecs::Durability", {"dataStorage"}},
        {"keen::ecs::SpecialAbility", {"dataStorage"}},
        {"keen::ecs::DamageModSkillShot", {"dataStorage"}},
        {"keen::ecs::ServerProgress", {"preferredSpawnAltar"}},
        {"keen::ecs::DynamicServerProgress", {"preferredSpawnAltar"}},
      }
      if query_index > #candidates then
        for _, result in ipairs(results) do
          if result.count then lines[#lines + 1] = "query=" .. result.component .. "|count=" .. tostring(result.count) else lines[#lines + 1] = "query=" .. result.component .. "|status=unavailable|reason=" .. tostring(result.reason) end
        end
      end
      for _, entry in ipairs(candidates) do
        if query_index > #candidates then break end
        local component = entry[1]
        local ok_read, value, read_reason = pcall(function() return runtime.ecs.read(player.handle, component) end)
        if ok_read and value ~= nil then
          lines[#lines + 1] = "component=" .. component .. "|status=readable"
        elseif ok_read then
          lines[#lines + 1] = "component=" .. component .. "|status=unavailable|reason=" .. tostring(read_reason)
        else
          lines[#lines + 1] = "component=" .. component .. "|status=error|reason=" .. tostring(value)
        end
        for _, field in ipairs(entry[2]) do
          local ok_field, fields = pcall(function() return runtime.ecs.read_fields(player.handle, component, {field}) end)
          if ok_field and fields ~= nil and fields[field] ~= nil then
            lines[#lines + 1] = "field=" .. component .. "." .. field .. "|status=readable"
          elseif ok_field then
            lines[#lines + 1] = "field=" .. component .. "." .. field .. "|status=unavailable"
          else
            lines[#lines + 1] = "field=" .. component .. "." .. field .. "|status=error"
          end
        end
        if component == candidates[query_index][1] then
          local ok_query, entities, query_reason = pcall(function() return runtime.ecs.query(component) end)
          if ok_query and entities ~= nil then
            results[query_index] = {component=component, count=#entities}
            query_index = query_index + 1
          elseif ok_query and string.find(tostring(query_reason), "scanning", 1, true) then
            return
          else
            results[query_index] = {component=component, reason=tostring(query_reason)}
            query_index = query_index + 1
          end
          return
        end
      end
      if query_index <= #candidates then return end
      for _, result in ipairs(results) do
        if result.count then lines[#lines + 1] = "query=" .. result.component .. "|count=" .. tostring(result.count) else lines[#lines + 1] = "query=" .. result.component .. "|status=unavailable|reason=" .. tostring(result.reason) end
      end
    end
    pcall(function() io.export("embervault/player-state-v1.tsv", table.concat(lines, "\n") .. "\n") end)
    done = true
  end,
}
