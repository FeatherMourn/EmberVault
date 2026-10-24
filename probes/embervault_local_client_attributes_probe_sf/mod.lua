local done = false
local attempts = 0
local max_attempts = 120

return {
  update_interval_ms = 1000,
  on_update = function()
    if done then return end
    attempts = attempts + 1
    local snapshot_ok, snapshot = pcall(function()
      return runtime.ecs.get_snapshot()
    end)
    if not snapshot_ok or snapshot == nil then
      if attempts < max_attempts then return end
    elseif not snapshot.ecsReady or not snapshot.worldActive or not snapshot.entityContextReady then
      if attempts < max_attempts then return end
    end
    local ok, value, reason = pcall(function()
      return runtime.ecs.get_local_client_attributes()
    end)
    if not ok then
      reason = "call_error=" .. tostring(value)
      value = nil
    end
    if value == nil and attempts < max_attempts then return end
    local lines = {
      "schema_version=1",
      "probe_id=local-client-attributes",
      "probe_version=1.0.0",
      "evidence_state=observed",
      "attempts=" .. tostring(attempts),
      "read_only=true",
      "writes=not_attempted",
      "saves=not_accessed",
      "entity_enumeration=not_attempted",
      "native_calls=indirect_read_only_accessor"
    }
    if snapshot_ok and snapshot ~= nil then
      lines[#lines + 1] = "snapshot_session_id=" .. tostring(snapshot.sessionId)
      lines[#lines + 1] = "snapshot_ecs_ready=" .. tostring(snapshot.ecsReady)
      lines[#lines + 1] = "snapshot_world_active=" .. tostring(snapshot.worldActive)
      lines[#lines + 1] = "snapshot_entity_context_ready=" .. tostring(snapshot.entityContextReady)
      lines[#lines + 1] = "snapshot_local_player_status=" .. tostring(snapshot.localPlayerStatus)
    end
    if value ~= nil then
      lines[#lines + 1] = "status=available"
      lines[#lines + 1] = "handle_present=" .. tostring(value.handle ~= nil)
      lines[#lines + 1] = "entity_id_present=" .. tostring(value.entityId ~= nil)
      lines[#lines + 1] = "generation_present=" .. tostring(value.generation ~= nil)
      lines[#lines + 1] = "sequence_present=" .. tostring(value.sequence ~= nil)
    else
      lines[#lines + 1] = "status=unavailable"
      lines[#lines + 1] = "reason=" .. tostring(reason)
    end
    pcall(function()
      io.export("embervault/local-client-attributes-v1.tsv", table.concat(lines, "\n") .. "\n")
    end)
    done = true
  end,
}
