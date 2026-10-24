local attempts = 0
local max_attempts = 120
local reported = false
local probe_version = "1.4.7"
pcall(function()
  io.export("embervault/inventory-equipment-ownership-startup-v1.tsv", "startup=loaded\n")
end)
local function log(message)
  shroudforge.log.info("EMBERVAULT_OWNERSHIP|" .. message)
end

local function export(lines)
  local ok, err = pcall(function()
    io.export("embervault/inventory-equipment-ownership-v3.tsv", table.concat(lines, "\n") .. "\n")
  end)
  if not ok then shroudforge.log.error("EMBERVAULT_OWNERSHIP|EXPORT_ERROR|" .. tostring(err)) end
end

local function export_readiness(snapshot, attempt, reason)
  local lines = {
    "schema_version=2",
    "probe_id=inventory-equipment-ownership-readiness",
    "probe_version=" .. probe_version,
    "writes=not_attempted",
    "saves=not_accessed",
    "native_calls=not_attempted",
    "attempt=" .. tostring(attempt),
    "status=waiting",
    "reason=" .. tostring(reason or "not_ready"),
  }
  if snapshot ~= nil then
    lines[#lines + 1] = "session_id=" .. tostring(snapshot.sessionId)
    lines[#lines + 1] = "ecs_ready=" .. tostring(snapshot.ecsReady)
    lines[#lines + 1] = "world_active=" .. tostring(snapshot.worldActive)
    lines[#lines + 1] = "entity_context_ready=" .. tostring(snapshot.entityContextReady)
    lines[#lines + 1] = "local_player_ready=" .. tostring(snapshot.localPlayerReady)
    lines[#lines + 1] = "player_status=" .. tostring(snapshot.localPlayerStatus)
  end
  local ok, err = pcall(function()
    io.export("embervault/inventory-equipment-ownership-readiness-v1.tsv", table.concat(lines, "\n") .. "\n")
  end)
  if not ok then shroudforge.log.error("EMBERVAULT_OWNERSHIP|READINESS_EXPORT_ERROR|" .. tostring(err)) end
end

return {
  update_interval_ms = 1000,
  on_update = function()
    if reported then return end
    attempts = attempts + 1
    if attempts == 1 or attempts % 10 == 0 then log("tick=" .. tostring(attempts)) end
    local lines = {
      "schema_version=1",
      "probe_id=inventory-equipment-ownership",
    "probe_version=" .. probe_version,
      "writes=not_attempted",
      "saves=not_accessed",
      "native_calls=not_attempted"
    }
    local ok_snapshot, snapshot, snapshot_reason = pcall(function()
      return runtime.ecs.get_snapshot()
    end)
    if not ok_snapshot or snapshot == nil then
      if attempts == 1 or attempts % 10 == 0 then log("snapshot_unavailable=" .. tostring(snapshot_reason or snapshot)) end
      if attempts >= max_attempts then
        lines[#lines + 1] = "status=unavailable"
        lines[#lines + 1] = "reason=" .. tostring(snapshot_reason or snapshot)
        export(lines); reported = true
      elseif attempts == 1 or attempts % 10 == 0 then
        export_readiness(nil, attempts, snapshot_reason or snapshot)
      end
      return
    end
    lines[#lines + 1] = "session_id=" .. tostring(snapshot.sessionId)
    lines[#lines + 1] = "ecs_ready=" .. tostring(snapshot.ecsReady)
    lines[#lines + 1] = "world_active=" .. tostring(snapshot.worldActive)
    lines[#lines + 1] = "entity_context_ready=" .. tostring(snapshot.entityContextReady)
    if attempts == 1 or attempts % 10 == 0 then
      export_readiness(snapshot, attempts)
    end
    local player_ready = snapshot.localPlayerReady == true or snapshot.localPlayerStatus == "ready"
    if not snapshot.ecsReady or not snapshot.worldActive or not player_ready then
      if attempts >= max_attempts then
        lines[#lines + 1] = "status=timeout"
        lines[#lines + 1] = "reason=readiness_timeout"
        export(lines); reported = true
      end
      return
    end
    log("snapshot_ready=true")
    local ok_setup, setup, reason = pcall(function()
      return runtime.ecs.read_local_inventory_setup()
    end)
    if not ok_setup or setup == nil then
      local transient = tostring(reason or setup or "unavailable")
      -- A nil/error result has no reliable status shape across loader versions.
      -- Treat it as transient until the bounded retry budget is exhausted.
      if attempts < max_attempts then
        if attempts == 1 or attempts % 10 == 0 then
          log("ownership_retry=" .. transient)
        end
        return
      end
      lines[#lines + 1] = "status=unavailable"
      lines[#lines + 1] = "reason=" .. transient
    else
      lines[#lines + 1] = "status=ready"
      lines[#lines + 1] = "setup_bytes=" .. tostring(#setup.bytes)
      lines[#lines + 1] = "player_entity_id=" .. tostring(setup.playerEntityId)
      lines[#lines + 1] = "generation=" .. tostring(setup.generation)
      lines[#lines + 1] = "sequence=" .. tostring(setup.sequence)
      local links = {}
      for index = 1, math.min(16, math.floor(#setup.bytes / 4)) do
        local base = (index - 1) * 4
        local b1, b2, b3, b4 = string.byte(setup.bytes, base + 1, base + 4)
        local id = b1 + b2 * 256 + b3 * 65536 + b4 * 16777216
        if id ~= 0 then links[#links + 1] = tostring(id) end
      end
      lines[#lines + 1] = "linked_entity_ids=" .. table.concat(links, ",")
      lines[#lines + 1] = "linked_entity_count=" .. tostring(#links)
    end
    export(lines)
    reported = true
  end,
}
