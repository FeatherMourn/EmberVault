-- Bounded read-only inventory. No writes, native calls, saves, or entity enumeration.
local reported = false
local attempts = 0
local max_attempts = 30

local function report(label, fn)
  local ok, value = pcall(fn)
  if not ok then return label .. "=error:" .. tostring(value) end
  if type(value) == "table" then
    local count = value.count or value.length or value.size
    return label .. "=table" .. (count and (";count=" .. tostring(count)) or "")
  end
  return label .. "=" .. tostring(value)
end

return {
  update_interval_ms = 1000,
  on_update = function()
    if reported then return end
    attempts = attempts + 1
    local ok_registry, registry = pcall(function() return runtime.ecs.get_registry() end)
    local ready = ok_registry and registry ~= nil
    if not ready and attempts < max_attempts then return end
    local lines = {"EMBERVAULT_LIVE_INVENTORY|version=1|read_only=true"}
    table.insert(lines, "attempt=" .. tostring(attempts) .. ";max_attempts=" .. tostring(max_attempts))
    table.insert(lines, report("types", function() return runtime.types.get_all() end))
    table.insert(lines, report("ecs_registry", function() return runtime.ecs.get_registry() end))
    local types = {
      "keen::GameSettingsPresetsResource",
      "keen::BalancingTable",
      "keen::RecipeRegistryResource",
      "keen::WorkshopRegistryResource",
      "keen::ItemInfo",
    }
    for _, name in ipairs(types) do
      table.insert(lines, report("loaded:" .. name, function()
        return game.assets.get_loaded_resources_by_type(name)
      end))
    end
    table.insert(lines, "writes=not_attempted")
    table.insert(lines, "entities=not_enumerated")
    table.insert(lines, "saves=not_accessed")
    for _, line in ipairs(lines) do shroudforge.log.info(line) end
    reported = true
  end,
}
