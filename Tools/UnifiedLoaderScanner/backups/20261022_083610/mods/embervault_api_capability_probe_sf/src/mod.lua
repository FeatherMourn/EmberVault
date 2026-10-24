-- Read-only EMM capability probe. Does not enumerate resources or access saves.
local lines = {
  "schema_version=1",
  "probe_id=api-capability",
  "probe_version=1.0.0",
  "evidence_state=observed",
  "collection_status=started",
  "limitations=capability presence only; no resources traversed; no runtime behavior inferred"
}

local function check(label, fn)
  local ok, value = pcall(fn)
  table.insert(lines, table.concat({"capability", label, ok and tostring(value) or "error", ok and "" or tostring(value)}, "\t"))
end

check("game", function() return type(game) end)
check("game.assets", function() return type(game.assets) end)
check("game.assets.get_resources_by_type", function() return type(game.assets.get_resources_by_type) end)
check("io", function() return type(io) end)
check("io.export", function() return type(io.export) end)
check("pcall", function() return type(pcall) end)

lines[5] = "collection_status=completed"
local ok_export, export_error = pcall(function()
  io.export("embervault/api-capability-v1.tsv", table.concat(lines, "\n") .. "\n")
end)
if not ok_export then
  print("EMBERVAULT_API_CAPABILITY|EXPORT_ERROR|" .. tostring(export_error))
end
