local done = false
local attempts = 0
local max_attempts = 90

local function query(lines, label, component)
  local ok, entities, reason = pcall(function()
    return runtime.ecs.query(component)
  end)
  if not ok then
    lines[#lines + 1] = label .. "\tquery_error=" .. tostring(entities)
    return false
  end
  if entities == nil then
    lines[#lines + 1] = label .. "\tquery_unavailable=" .. tostring(reason)
    return true
  end
  lines[#lines + 1] = label .. "\tcount=" .. tostring(#entities)
  for i = 1, math.min(#entities, 8) do
    local entity = entities[i]
    lines[#lines + 1] = label .. "\tentity=" .. tostring(entity)
    local ok_fields, values, field_reason = pcall(function()
      return runtime.ecs.read_fields(entity, component, {"playerEntityId", "ownerEntityId"})
    end)
    if not ok_fields then
      lines[#lines + 1] = label .. "\tfields_error=" .. tostring(values)
    elseif values == nil then
      lines[#lines + 1] = label .. "\tfields_unavailable=" .. tostring(field_reason)
    else
      lines[#lines + 1] = label .. "\tplayerEntityId=" .. tostring(values.playerEntityId)
      lines[#lines + 1] = label .. "\townerEntityId=" .. tostring(values.ownerEntityId)
    end
  end
  return false
end

return {
  update_interval_ms = 1000,
  on_update = function()
    if done then return end
    attempts = attempts + 1
    local ok, registry = pcall(function() return runtime.ecs.get_registry() end)
    if (not ok or registry == nil) and attempts < max_attempts then return end
    local lines = {
      "schema_version=1",
      "probe_id=player-owner-context",
      "probe_version=1.0.1",
      "evidence_state=observed",
      "limitations=bounded read-only owner-context query; no entity dump, writes, saves, or native calls"
    }
    local pending = false
    pending = query(lines, "player_input", "keen::ecs::PlayerInput") or pending
    pending = query(lines, "client_player_input", "keen::ecs::ClientPlayerInput") or pending
    pending = query(lines, "local_player_mask", "keen::ecs::LocalPlayerMask") or pending
    pending = query(lines, "client_player_state", "keen::ecs::ClientPlayerState") or pending
    if pending and attempts < max_attempts then return end
    lines[#lines + 1] = "writes\tnot_attempted"
    lines[#lines + 1] = "saves\tnot_accessed"
    lines[#lines + 1] = "native_calls\tnot_attempted"
    pcall(function() io.export("embervault/player-owner-context-v1.tsv", table.concat(lines, "\n") .. "\n") end)
    done = true
  end,
}
