-- Bounded scalar reads only. No writes, overrides, native calls, or save access.
local reported = false
local attempts = 0
local max_attempts = 90

local function line(label, fn)
  local ok, value = pcall(fn)
  return label .. "=" .. (ok and tostring(value) or "error:" .. tostring(value))
end

local function fields_text(values)
  local parts = {}
  if type(values) ~= "table" then return tostring(values) end
  for key, value in pairs(values) do table.insert(parts, tostring(key) .. "=" .. tostring(value)) end
  table.sort(parts)
  return table.concat(parts, ",")
end

local function read_resource(type_name, fields)
  local resources = game.assets.get_loaded_resources_by_type(type_name)
  local first = resources and resources[1]
  if not first then return type_name .. "=no_resource" end
  local out = {type_name .. "=resource"}
  for _, path in ipairs(fields) do
    table.insert(out, line(path, function()
      local value, reflected = game.assets.read_loaded_field(first, path)
      return tostring(value) .. ";type=" .. tostring(reflected)
    end))
  end
  return table.concat(out, "|")
end

return {
  update_interval_ms = 1000,
  on_update = function()
    if reported then return end
    attempts = attempts + 1
    local ok_registry, registry = pcall(function() return runtime.ecs.get_registry() end)
    local ok_resources, resources = pcall(function() return game.assets.get_loaded_resources_by_type("keen::BalancingTable") end)
    local ok_service, service = pcall(function() return runtime.services.get("ecs::GameSettings") end)
    local services_ready = ok_service and service ~= nil
    if (not (ok_registry and registry) or not (ok_resources and resources) or not services_ready) and attempts < max_attempts then return end
    local lines = {"EMBERVAULT_SCALAR_READ|version=1|read_only=true"}
    table.insert(lines, "attempt=" .. tostring(attempts) .. ";max_attempts=" .. tostring(max_attempts))
    table.insert(lines, line("settings_service", function()
      local values = service:read_fields({"factoryProductionSpeedFactor", "enemyHealthFactor", "playerHealthFactor"})
      return fields_text(values)
    end))
    table.insert(lines, line("presets", function()
      return read_resource("keen::GameSettingsPresetsResource", {"minValues.playerHealthFactor", "maxValues.playerHealthFactor", "minValues.factoryProductionSpeedFactor", "maxValues.factoryProductionSpeedFactor"})
    end))
    table.insert(lines, line("balancing", function()
      return read_resource("keen::BalancingTable", {"playerLevelCap", "itemLevelCap", "flameLevelMax", "altarLevelMax", "durabilityLossCap"})
    end))
    table.insert(lines, "writes=not_attempted")
    table.insert(lines, "overrides=not_created")
    for _, value in ipairs(lines) do shroudforge.log.info(value) end
    reported = true
  end,
}
