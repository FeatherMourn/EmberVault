-- Read-only current-build localization exporter.
-- Exports one JSON file per language; does not patch game assets.
local function escape(value)
    local text = tostring(value or "")
    return text:gsub('[%z\1-\31\\"]', function(c)
        if c == "\\" then return "\\\\" end
        if c == '"' then return '\\"' end
        if c == "\n" then return "\\n" end
        if c == "\r" then return "\\r" end
        if c == "\t" then return "\\t" end
        return string.format("\\u%04X", c:byte())
    end)
end
local function quote(value) return '"' .. escape(value) .. '"' end
local function safe_name(value) return tostring(value or "unknown"):gsub("[^%w_%-]", "_") end
local function version_info(value)
    value = tostring(value or "")
    return {
        build = tonumber(value:match("^(%d+)")) or 0,
        branch = value:match("branches/([^|]+)") or "unknown",
        date = value:match("(%d%d%d%d%-%d%d%-%d%d)") or "unknown"
    }
end
local function document(version, language, entries)
    local keys = {}
    for id in pairs(entries) do table.insert(keys, id) end
    table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
    local lines = {
        "{", '  "version": {',
        '    "build": ' .. tostring(version.build) .. ',',
        '    "branch": ' .. quote(version.branch) .. ',',
        '    "date": ' .. quote(version.date),
        "  },", '  "language": ' .. quote(language) .. ',', '  "entries": {'
    }
    for index, id in ipairs(keys) do
        local comma = index < #keys and "," or ""
        table.insert(lines, "    " .. quote(id) .. ": " .. quote(entries[id]) .. comma)
    end
    table.insert(lines, "  }")
    table.insert(lines, "}")
    return table.concat(lines, "\n")
end
local ok, resources = pcall(function()
    return game.assets.get_resources_by_type("keen::LocaTagCollectionResource")
end)
if not ok or type(resources) ~= "table" or #resources == 0 then
    print("EMBERVAULT_LOCALIZATION|NO_RESOURCES")
    return
end
local localization = resources[1].data
local version = version_info(game.version)
local exported = 0
for _, language in ipairs(localization.languages or {}) do
    local name = language.language or "UNKNOWN"
    local content_guid = game.guid.from_content_hash(language.dataHash)
    local content = game.assets.get_content(content_guid)
    if content then
        local data = content:read_data():read_resource("keen::LocaTagCollectionResourceData")
        local entries = {}
        for _, tag in ipairs(data.tags or {}) do
            local id = tag.id and tag.id.value
            local text = tag.text
            if id and text and tostring(text) ~= "" then entries[tostring(id)] = tostring(text) end
        end
        io.export("embervault/localization/" .. safe_name(name) .. ".json", document(version, name, entries))
        exported = exported + 1
        print("EMBERVAULT_LOCALIZATION|EXPORTED|" .. tostring(name) .. "|" .. tostring(#data.tags))
    end
end
print("EMBERVAULT_LOCALIZATION|COMPLETE|build=" .. tostring(version.build) .. "|languages=" .. tostring(exported))
