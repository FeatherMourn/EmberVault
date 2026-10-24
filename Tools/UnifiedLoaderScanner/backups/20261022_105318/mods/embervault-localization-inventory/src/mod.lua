if not loader.features.export then
    return
end

local lines = {
    "schema_version=1",
    "probe_id=localization-inventory",
    "probe_version=1.0.0-eml",
    "evidence_state=observed",
    "collection_status=started",
    "limitations=read-only localization inventory; no text translation; no writes"
}

local types = {
    "keen::LocaTag",
    "keen::LocaTagResource",
    "keen::LocaTagCollectionResource",
    "keen::LocaTagReference",
    "keen::LanguageId"
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
            if index <= 128 then
                table.insert(lines, "resource\t" .. type_name .. "\t" .. tostring(resource.guid) .. "\t" .. tostring(resource))
            end
        end
    end
end

lines[5] = "collection_status=completed"
io.export("embervault/localization-inventory-v1.tsv", table.concat(lines, "\n") .. "\n")
