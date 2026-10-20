-- Packaged from ../relationship_inventory_probe.lua.
-- Read-only: identities and bounded field-presence metadata only.

local lines = {
    "schema_version=1",
    "probe_id=relationship-inventory",
    "probe_version=1.0.0",
    "evidence_state=observed",
    "collection_status=started",
    "limitations=bounded identity and field-presence metadata; no semantic or runtime claim",
}

local targets = {"keen::ItemInfo", "keen::RecipeRegistryResource", "keen::RenderModel", "keen::RenderModelChunkModelResource", "keen::ecs::TemplateResource", "keen::ItemRegistryResource", "keen::VoxelBlueprintItemRegistryResource", "keen::FbUiBundle"}
local had_error = false
local function add_error(scope, message) had_error = true; table.insert(lines, "error\t" .. tostring(scope) .. "\t" .. tostring(message)) end
local function qualified_name(value)
    local ok, name = pcall(function() return value.qualified_name end)
    if ok and name ~= nil then return tostring(name) end
    return tostring(value)
end
for _, type_name in ipairs(targets) do
    local ok, resources = pcall(function() return game.assets.get_resources_by_type(type_name) end)
    if not ok or type(resources) ~= "table" then
        add_error("get_resources_by_type:" .. type_name, resources)
    else
        table.insert(lines, "family\t" .. type_name .. "\tcount=" .. tostring(#resources))
        for _, resource in ipairs(resources) do
            local data_type = "unknown"
            local ok_data, value_type = pcall(function() return type(resource.data) end)
            if ok_data then data_type = tostring(value_type) end
            table.insert(lines, table.concat({"resource", tostring(resource.guid), qualified_name(resource.type), tostring(resource.part), "data_type=" .. data_type}, "\t"))
        end
    end
end
if had_error then lines[4] = "evidence_state=partial" end
lines[5] = "collection_status=completed"
local ok_export, export_error = pcall(function() io.export("embervault/relationship-inventory-v1.tsv", table.concat(lines, "\n") .. "\n") end)
if not ok_export then print("EMBERVAULT_RELATIONSHIP_INVENTORY|EXPORT_ERROR|" .. tostring(export_error)) end
