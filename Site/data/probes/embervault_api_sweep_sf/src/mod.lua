-- Read-only API surface inventory. Never writes resources, ECS state, saves, or memory.
local reported = false

local function probe(label, fn)
  local ok, value = pcall(fn)
  return label .. "=" .. (ok and tostring(value) or "error:" .. tostring(value))
end

return {
  update_interval_ms = 1000,
  on_update = function()
    if reported then return end
    local lines = {
      "EMBERVAULT_API_SWEEP|version=1|read_only=true",
      probe("runtime", function() return type(runtime) end),
      probe("runtime.types", function() return type(runtime.types) end),
      probe("runtime.types.get_all", function() return type(runtime.types.get_all) end),
      probe("runtime.ecs", function() return type(runtime.ecs) end),
      probe("runtime.ecs.get_registry", function() return type(runtime.ecs.get_registry) end),
      probe("runtime.ecs.get_component", function() return type(runtime.ecs.get_component) end),
      probe("runtime.functions", function() return type(runtime.functions) end),
      probe("runtime.functions.list_native", function() return type(runtime.functions.list_native) end),
      probe("runtime.functions.get_operations", function() return type(runtime.functions.get_operations) end),
      probe("runtime.services", function() return type(runtime.services) end),
      probe("runtime.services.get", function() return type(runtime.services.get) end),
      probe("runtime.overrides", function() return type(runtime.overrides) end),
      probe("runtime.overrides.new", function() return type(runtime.overrides.new) end),
      probe("game", function() return type(game) end),
      probe("game.assets", function() return type(game.assets) end),
      probe("game.assets.get_loaded_resources_by_type", function() return type(game.assets.get_loaded_resources_by_type) end),
      probe("game.assets.get_resources_by_type", function() return type(game.assets.get_resources_by_type) end),
      probe("game.assets.get_content", function() return type(game.assets.get_content) end),
      probe("shroudforge.settings", function() return type(shroudforge.settings) end),
      probe("shroudforge.log", function() return type(shroudforge.log) end),
      probe("io.export", function() return type(io.export) end),
      "writes=not_attempted",
      "native_calls=not_attempted",
      "world_data=not_requested"
    }
    for _, line in ipairs(lines) do shroudforge.log.info(line) end
    reported = true
  end,
}
