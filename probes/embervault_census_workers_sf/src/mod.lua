-- Root entry point kept in sync with src/mod.lua for loaders that do not scan src.
local started = false
local finished = false
local census
local cooldown = 0
local run_count = 0
local tick_count = 0
local last_worker_status = {}
local function trace(message) pcall(function() shroudforge.log.info("[embervault-census-v146] " .. tostring(message)) end) end

local function export_census()
  local output = census.output
  local has_nonempty_capture = false
  local lines = {
    "schema_version=1", "probe_id=embervault-census-workers-sf-v146", "probe_version=1.4.6",
    "read_only=true", "writes=not_attempted", "saves=not_accessed",
    "worker_model=independent_bounded_scheduler",
    "worker_graph_version=1.4.6",
    "reload_mode=lua_hot_reload_with_module_cache_guard",
    "checkpoint_model=bounded_scheduler_cursor_and_worker_states",
    "differential_report=worker_status_changes_since_previous_run",
    "run_count=" .. tostring(run_count),
    "export_identity=probe_id|probe_version|worker_graph_version|run_count|snapshot_generation",
    "stale_export_rule=ignore_exports_without_current_run_count_and_snapshot_generation",
  }
  if output.player then
    lines[#lines+1] = "player=status=available|entityId=" .. tostring(output.player.entityId)
      .. "|generation=" .. tostring(output.player.generation)
      .. "|sequence=" .. tostring(output.player.sequence)
  else lines[#lines+1] = "player=status=unavailable" end
  for _, worker in ipairs(output.workers or {}) do
    lines[#lines+1] = "worker=" .. tostring(worker.id) .. "|status=" .. tostring(worker.status)
      .. "|attempts=" .. tostring(worker.attempts) .. "|error=" .. tostring(worker.error or "")
      .. "|reason=" .. tostring(worker.reason or "")
    local previous = last_worker_status[worker.id] or "missing"
    if previous ~= worker.status then lines[#lines+1] = "worker_delta=" .. tostring(worker.id) .. "|from=" .. previous .. "|to=" .. tostring(worker.status) end
    last_worker_status[worker.id] = worker.status
  end
  if output.checkpoint then
    lines[#lines+1] = "checkpoint_cursor=" .. tostring(output.checkpoint.cursor)
    lines[#lines+1] = "checkpoint_active=" .. tostring(output.checkpoint.active or "")
    lines[#lines+1] = "checkpoint_ticks=" .. tostring(output.checkpoint.ticks)
  end
  lines[#lines+1] = "inventory_links_count=" .. tostring(#(output.inventory_links or {}))
  for i, row in ipairs(output.inventory_links or {}) do
    if i > 8 then break end
    for field, value in pairs(row.fields or {}) do lines[#lines+1] = "inventory_link_field=" .. tostring(field) .. "|value=" .. tostring(value) .. "|type=" .. type(value) end
  end
  lines[#lines+1] = "populated_inventories_count=" .. tostring(#(output.populated_inventories or {}))
  for i, row in ipairs(output.populated_inventories or {}) do
    if i > 8 then break end
    for field, value in pairs(row.fields or {}) do lines[#lines+1] = "inventory_slot_field=" .. tostring(field) .. "|value=" .. tostring(value) .. "|type=" .. type(value) end
  end
  lines[#lines+1] = "linked_inventories_count=" .. tostring(#(output.linked_inventories or {}))
  local linked_nonzero = 0
  local linked_count_without_id = 0
  local slot_summary = {empty=0, count_without_item_id=0, item_id_present=0, pide_present=0}
  for _, row in ipairs(output.linked_inventories or {}) do
    lines[#lines+1] = "linked_inventory_id=" .. tostring(row.id) .. "|status=" .. tostring(row.status)
    local row_nonzero = false
    local row_has_id = false
    local row_has_pide = false
    for field, value in pairs(row.fields or {}) do
      lines[#lines+1] = "linked_inventory_field=" .. tostring(field) .. "|value=" .. tostring(value) .. "|type=" .. type(value)
      if (string.find(field, "pide", 1, true) or string.find(field, "itemId", 1, true) or string.find(field, "count", 1, true)) and type(value) == "number" and value > 0 then row_nonzero = true end
      if (string.find(field, "pide.id", 1, true) or string.find(field, "item", 1, true)) and type(value) == "number" and value > 0 then row_has_id = true end
      if string.find(field, "pide.id", 1, true) and type(value) == "number" and value > 0 then row_has_pide = true end
    end
    if row_nonzero then linked_nonzero = linked_nonzero + 1 end
    if row_nonzero or row_has_id or row_has_pide then has_nonempty_capture = true end
    if row_nonzero and not row_has_id then linked_count_without_id = linked_count_without_id + 1 end
    if row_has_id then slot_summary.item_id_present = slot_summary.item_id_present + 1 end
    if row_has_pide then slot_summary.pide_present = slot_summary.pide_present + 1 end
    if row_nonzero and not row_has_id then slot_summary.count_without_item_id = slot_summary.count_without_item_id + 1 end
    if not row_nonzero and not row_has_id and not row_has_pide then slot_summary.empty = slot_summary.empty + 1 end
  end
  lines[#lines+1] = "linked_inventories_nonzero_count=" .. tostring(linked_nonzero)
  lines[#lines+1] = "linked_inventories_count_without_item_id=" .. tostring(linked_count_without_id)
  lines[#lines+1] = "slot_summary_empty=" .. tostring(slot_summary.empty)
  lines[#lines+1] = "slot_summary_count_without_item_id=" .. tostring(slot_summary.count_without_item_id)
  lines[#lines+1] = "slot_summary_item_id_present=" .. tostring(slot_summary.item_id_present)
  lines[#lines+1] = "slot_summary_pide_present=" .. tostring(slot_summary.pide_present)
  lines[#lines+1] = "equipment_readable_count=" .. tostring(#(output.equipment or {}))
  lines[#lines+1] = "default_inventory_count=" .. tostring(#(output.default_inventory or {}))
  lines[#lines+1] = "perk_container_count=" .. tostring(#(output.perk_containers or {}))
  lines[#lines+1] = "weapon_gem_slot_count=" .. tostring(#(output.weapon_gem_slots or {}))
  lines[#lines+1] = "equipment_links_count=" .. tostring(#(output.equipment_links or {}))
  for _, row in ipairs(output.slot_schema or {}) do
    lines[#lines+1] = "slot_schema_type=" .. tostring(row.type) .. "|status=" .. tostring(row.status)
    for _, field in ipairs(row.fields or {}) do
      lines[#lines+1] = "slot_schema_field=" .. tostring(row.type) .. "|name=" .. tostring(field.name)
        .. "|type=" .. tostring(field.type) .. "|offset=" .. tostring(field.offset or "")
    end
  end
  lines[#lines+1] = "item_states_count=" .. tostring(#(output.item_states or {}))
  lines[#lines+1] = "item_state_candidate_count=" .. tostring(#(output.item_state_candidates or {}))
  for _, id in ipairs(output.item_state_candidates or {}) do lines[#lines+1] = "item_state_candidate_id=" .. tostring(id) end
  lines[#lines+1] = "player_state_components_count=" .. tostring(#(output.player_state or {}))
  for _, component in ipairs(output.player_state or {}) do
    lines[#lines+1] = "player_state_component=" .. tostring(component.component) .. "|status=" .. tostring(component.status)
  end
  for _, item in ipairs(output.item_states or {}) do
      lines[#lines+1] = "item_state_id=" .. tostring(item.id) .. "|status=" .. tostring(item.status or "readable")
    for field, value in pairs(item.fields or {}) do
      lines[#lines+1] = "item_state_field=" .. tostring(field) .. "|value=" .. tostring(value) .. "|type=" .. type(value)
    end
  end
  if output.snapshot then
    lines[#lines+1] = "snapshot_cached_queries=" .. tostring(output.snapshot.cached_queries)
    lines[#lines+1] = "snapshot_cached_reads=" .. tostring(output.snapshot.cached_reads)
    lines[#lines+1] = "snapshot_generation=" .. tostring(output.snapshot.generation_key or "")
  end
  lines[#lines+1] = "export_run_token=" .. tostring(run_count) .. ":" .. tostring(output.snapshot and output.snapshot.generation_key or "unknown")
  local payload = table.concat(lines, "\n") .. "\n"
  local export_name = "embervault/census-workers-v146-run-" .. tostring(run_count) .. ".tsv"
  local ok_export, export_error = pcall(function() io.export(export_name, payload) end)
  pcall(function() io.export("embervault/census-workers-latest.tsv", payload) end)
  trace("export ok=" .. tostring(ok_export) .. " error=" .. tostring(export_error or ""))
  if has_nonempty_capture then
    pcall(function() io.export("embervault/census-workers-nonempty.tsv", payload) end)
  end
end

return {
  update_interval_ms = 1000,
  on_update = function()
    tick_count = tick_count + 1
    if finished then
      cooldown = cooldown - 1
      if cooldown > 0 then return end
      finished = false
      started = false
    end
    if not started then
      trace("creating runtime v146")
      local Runtime = require("census_runtime_v146")
      census = Runtime.create(runtime, {timeout_seconds=90, max_items_per_job=32})
      started = true
      trace("runtime created")
    end
    local complete = census.update()
    if tick_count % 10 == 0 then trace("tick=" .. tostring(tick_count) .. " complete=" .. tostring(complete)) end
    if complete then run_count = run_count + 1; export_census(); finished = true; cooldown = 30 end
  end,
}
