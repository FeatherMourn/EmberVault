-- Read-only donor candidate probe. No mutation, patching, or save access.
local lines={"schema_version=1","probe_id=donor-candidate","probe_version=1.0.0","evidence_state=observed","collection_status=started","limitations=identity and reference metadata only; no donor suitability or runtime claim"}
local had_error=false
local function err(scope,msg) had_error=true; table.insert(lines,"error\t"..tostring(scope).."\t"..tostring(msg)) end
local function scalar(value)
    if value==nil then return "" end
    local kind=type(value)
    if kind=="string" or kind=="number" or kind=="boolean" then return tostring(value) end
    for _,key in ipairs({"value","guid","hash","id"}) do
        local ok,nested=pcall(function() return value[key] end)
        if ok and nested~=nil then local result=scalar(nested); if result~="" then return result end end
    end
    return ""
end
local function field(data,path)
    local ok,value=pcall(function()
        local current=data
        for part in string.gmatch(path,"[^%.]+") do current=current[part] end
        return current
    end)
    if not ok then return "",tostring(value) end
    return scalar(value),""
end
local ok,items=pcall(function() return game.assets.get_resources_by_type("keen::ItemInfo") end)
if not ok or type(items)~="table" then
    err("get_resources_by_type:keen::ItemInfo",items)
else
    table.insert(lines,"family\tkeen::ItemInfo\tcount="..tostring(#items))
    for _,item in ipairs(items) do
        local values={}
        local failures={}
        for _,path in ipairs({"itemId","name","caption","description","objectId","iconImage","iconModel","iconScene","equipment.placedEntity","equipment.visualEntity","equipment.visualModel"}) do
            local value,failure=field(item.data,path); values[path]=value; if failure~="" then failures[path]=failure end
        end
        table.insert(lines,table.concat({"donor",tostring(item.guid),tostring(item.part),values.itemId,values.name,values.caption,values.description,values.objectId,values.iconImage,values.iconModel,values.iconScene,values["equipment.placedEntity"],values["equipment.visualEntity"],values["equipment.visualModel"]},"\t"))
        for path,message in pairs(failures) do err(tostring(item.guid)..":"..path,message) end
    end
end
if had_error then lines[4]="evidence_state=partial" end
lines[5]="collection_status=completed"
local ok_export,export_error=pcall(function() io.export("embervault/donor-candidates-v1.tsv",table.concat(lines,"\n").."\n") end)
if not ok_export then print("EMBERVAULT_DONOR_CANDIDATE|EXPORT_ERROR|"..tostring(export_error)) end
