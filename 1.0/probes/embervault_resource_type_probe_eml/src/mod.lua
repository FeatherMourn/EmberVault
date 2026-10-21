if not loader.features.export then
    return
end

local lines = {
    "schema_version=1",
    "probe_id=resource-type",
    "probe_version=1.0.0-eml",
    "evidence_state=observed",
    "collection_status=started",
    "limitations=visible type names only; no resource payloads or collection traversal"
}

local ok, types = pcall(function()
    return game.assets.get_resource_types()
end)

if not ok or type(types) ~= "table" then
    lines[4] = "evidence_state=partial"
    table.insert(lines, "error\tget_resource_types\t" .. tostring(types))
else
    table.insert(lines, "type_count\t" .. tostring(#types))
    for index, name in ipairs(types) do
        if index <= 20000 then
            table.insert(lines, "resource_type\t" .. tostring(name))
        end
    end
end

lines[5] = "collection_status=completed"
io.export("embervault/resource-types-v1.tsv", table.concat(lines, "\n") .. "\n")
