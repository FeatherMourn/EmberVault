-- Example read-only worker orchestration for an EmberVault runtime probe.

local Scheduler = require("ecs_read_scheduler")
local Workers = require("census_workers")

local Runtime = {}

function Runtime.create(runtime, options)
  options = options or {}
  local output = {schema_version = 1, read_only = true, writes = "not_attempted", saves = "not_accessed"}
  local scheduler = Scheduler.new(runtime, {
    timeout_seconds = options.timeout_seconds or 180,
    max_items_per_job = options.max_items_per_job or 160,
  })
  scheduler:add("player-context", Workers.player_context(runtime, output), {timeout_seconds = 60})
  scheduler:add("inventory-links", Workers.inventory_links(runtime, output), {timeout_seconds = 180})
  scheduler:add("inventory-scan", Workers.inventory_scan(runtime, output), {timeout_seconds = 180})
  scheduler:add("equipment", Workers.equipment(runtime, output), {timeout_seconds = 180})

  return {
    scheduler = scheduler,
    output = output,
    update = function()
      local complete = scheduler:step()
      output.workers = scheduler:summary()
      return complete, output
    end,
  }
end

return Runtime
