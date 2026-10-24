-- EmberVault Platform Inventory Probe 1.0.0
-- Export-only. No patching, resource creation, save access, or runtime hooks.

local lines = {
    "schema_version=1",
    "probe_id=platform-inventory",
    "probe_version=1.0.0",
    "evidence_state=observed",
    "collection_status=started",
    "limitations=resource metadata only; no universal runtime or behavior claim",
}

local had_error = false

local function qualified_name(value)
    local ok, name = pcall(function()
        return value.qualified_name
    end)
    if ok and name ~= nil then
        return tostring(name)
    end
    return tostring(value)
end

local function add_error(scope, message)
    had_error = true
    table.insert(lines, "error\t" .. tostring(scope) .. "\t" .. tostring(message))
end

local ok_types, resource_types = pcall(function()
    return game.assets.get_resource_types()
end)

if not ok_types or type(resource_types) ~= "table" then
    add_error("get_resource_types", resource_types)
else
    for _, resource_type in ipairs(resource_types) do
        table.insert(lines, "type\t" .. qualified_name(resource_type))
        local ok_resources, resources = pcall(function()
            -- The current runtime does not expose the metadata-only helper.
            -- Use the documented resource-list API and keep each type bounded
            -- by its own protected call so one unsupported family cannot stop
            -- the complete inventory.
            return game.assets.get_resources_by_type(resource_type)
        end)
        if not ok_resources or type(resources) ~= "table" then
            add_error("get_resources_by_type:" .. tostring(resource_type), resources)
        else
            for _, resource in ipairs(resources) do
                table.insert(lines, table.concat({
                    "resource",
                    tostring(resource.guid),
                    qualified_name(resource.type),
                    tostring(resource.part),
                }, "\t"))
            end
        end
    end
end

if had_error then
    lines[4] = "evidence_state=partial"
end
lines[5] = "collection_status=completed"

local ok_export, export_error = pcall(function()
    io.export("embervault/platform-inventory-v1.tsv", table.concat(lines, "\n") .. "\n")
end)
if not ok_export then
    -- The export failure cannot itself be exported; retain it in the loader log.
    print("EMBERVAULT_PLATFORM_INVENTORY|EXPORT_ERROR|" .. tostring(export_error))
end
