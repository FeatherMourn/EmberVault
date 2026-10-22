-- Bounded read-only ECS query. No writes, saves, native calls, or unbounded entity dump.
local reported = false
local attempts = 0
local max_attempts = 90
local max_results = 32

local function encode(value)
  if value == nil then return "nil" end
  return tostring(value)
end

local function read_fields(entity, component, fields)
  local ok, values, reason = pcall(function()
    return runtime.ecs.read_fields(entity, component, fields)
  end)
  if not ok then return "call_error=" .. tostring(values) end
  if values == nil then return "unavailable=" .. tostring(reason) end
  local parts = {}
  for i = 1, #fields do
    local path = fields[i]
    local ok_value, value = pcall(function() return values[path] end)
    parts[#parts + 1] = path .. "=" .. (ok_value and encode(value) or "error")
  end
  return table.concat(parts, ";")
end

local function query(label, ...)
  local components = {...}
  local ok, entities, reason = pcall(function()
    return runtime.ecs.query(table.unpack(components))
  end)
  if not ok then return {label .. "\tquery_error=" .. tostring(entities)}, false end
  if entities == nil then return {label .. "\tquery_unavailable=" .. tostring(reason)}, true end
  local lines = {label .. "\tcount=" .. tostring(#entities)}
  local limit = math.min(#entities, max_results)
  for i = 1, limit do
    local entity = entities[i]
    lines[#lines + 1] = label .. "\tentity=" .. tostring(entity)
    if label == "player_candidate" then
      lines[#lines + 1] = "player_state\t" .. read_fields(entity, "keen::ecs::PlayerState", {"playerStateMask", "beamEntityId"})
      lines[#lines + 1] = "equipment\t" .. read_fields(entity, "keen::ecs::Equipment", {"visualMask", "impactMask", "bodyMaterialId"})
      lines[#lines + 1] = "character\t" .. read_fields(entity, "keen::ecs::CharacterSetup", {"presetId", "hair", "beard", "useNewProportions"})
    end
  end
  if #entities > max_results then lines[#lines + 1] = "truncated\t" .. tostring(#entities - max_results) end
  return lines, false
end

local function run_probe()
  local lines = {
    "schema_version=1",
    "probe_id=player-inventory-accessor",
    "probe_version=1.0.0",
    "evidence_state=observed",
    "limitations=bounded read-only query; no ownership or writable-field claim"
  }
  local first_lines, first_pending = query("player_candidate", "keen::ecs::PlayerState", "keen::ecs::Equipment")
  local second_lines, second_pending = query("player_character_candidate", "keen::ecs::PlayerState", "keen::ecs::CharacterSetup")
  local pending = false
  pending = first_pending or second_pending
  for _, line in ipairs(first_lines) do lines[#lines + 1] = line end
  for _, line in ipairs(second_lines) do lines[#lines + 1] = line end
  if pending then return false end
  lines[#lines + 1] = "writes\tnot_attempted"
  lines[#lines + 1] = "saves\tnot_accessed"
  lines[#lines + 1] = "native_calls\tnot_attempted"
  local ok_export, export_error = pcall(function()
    io.export("embervault/player-inventory-accessor-v1.tsv", table.concat(lines, "\n") .. "\n")
  end)
  if not ok_export then print("EMBERVAULT_PLAYER_INVENTORY|EXPORT_ERROR|" .. tostring(export_error)) end
end

return {
  update_interval_ms = 1000,
  on_update = function()
    if reported then return end
    attempts = attempts + 1
    local ok, registry = pcall(function() return runtime.ecs.get_registry() end)
    if (not ok or registry == nil) and attempts < max_attempts then return end
    local completed = run_probe()
    if completed ~= false then reported = true end
  end,
}
