if not loader.features.export then
    return
end

local lines = {
    "schema_version=1",
    "probe_id=localization",
    "probe_version=1.0.0-eml",
    "evidence_state=observed",
    "collection_status=started",
    "limitations=read-only localization resource metadata; no writes"
}

local types = {
    "keen::LocaTagCollectionResource",
    "keen::LocaTagResource"
}

for _, type_name in ipairs(types) do
    local ok, resources = pcall(function()
        return game.assets.get_resources_by_type(type_name)
    end)
    if not ok or type(resources) ~= "table" then
        table.insert(lines, "error\t" .. type_name .. "\t" .. tostring(resources))
    else
        table.insert(lines, "resource_count\t" .. type_name .. "\t" .. tostring(#resources))
        for index, resource in ipairs(resources) do
            if index <= 32 then
                table.insert(lines, "resource\t" .. type_name .. "\t" .. tostring(resource.guid) .. "\t" .. tostring(resource))
                table.insert(lines, "data\t" .. type_name .. "\t" .. tostring(resource.data))
            end
        end
    end
end

lines[5] = "collection_status=completed"
io.export("embervault/localization-v1.tsv", table.concat(lines, "\n") .. "\n")
