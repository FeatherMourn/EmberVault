if not loader.features.export then
    return
end

local lines = {
    "schema_version=1",
    "probe_id=workshops",
    "probe_version=1.0.0-eml",
    "evidence_state=observed",
    "collection_status=started",
    "limitations=read-only workshop registry metadata; no writes"
}

local ok, resources = pcall(function()
    return game.assets.get_resources_by_type("keen::WorkshopRegistryResource")
end)

if not ok or type(resources) ~= "table" then
    lines[4] = "evidence_state=partial"
    table.insert(lines, "error\tget_resources_by_type\t" .. tostring(resources))
else
    table.insert(lines, "resource_count\t" .. tostring(#resources))
    for index, resource in ipairs(resources) do
        if index <= 32 then
            table.insert(lines, "resource\t" .. tostring(resource.guid) .. "\t" .. tostring(resource))
            table.insert(lines, "data\t" .. tostring(resource.data))
        end
    end
end

lines[5] = "collection_status=completed"
io.export("embervault/workshops-v1.tsv", table.concat(lines, "\n") .. "\n")
