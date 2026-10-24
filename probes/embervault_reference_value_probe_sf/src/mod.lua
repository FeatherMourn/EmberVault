-- Read-only scalar reference probe. No mutation, patching, or save access.
local lines={"schema_version=1","probe_id=reference-value","probe_version=1.0.0","evidence_state=observed","collection_status=started","limitations=scalar reference values only; userdata and semantics are not inferred"}
local had_error=false
local function err(scope,msg) had_error=true; table.insert(lines,"error\t"..tostring(scope).."\t"..tostring(msg)) end
local function scalar(value)
    local kind=type(value)
    if value==nil then return "missing","" end
    if kind=="string" or kind=="number" or kind=="boolean" then return "scalar",tostring(value) end
    for _,key in ipairs({"value","guid","hash","id"}) do
        local ok,nested=pcall(function() return value[key] end)
        if ok and nested~=nil then
            local nested_kind,nested_value=scalar(nested)
            if nested_kind=="scalar" then return key,nested_value end
        end
    end
    return kind,""
end
local function inspect(resource,type_name,paths)
    for _,path in ipairs(paths) do
        local ok,value=pcall(function()
            local current=resource.data
            for part in string.gmatch(path,"[^%.]+") do current=current[part] end
            return current
        end)
        if not ok then err(type_name..":"..tostring(resource.guid)..":"..path,value)
        else
            local state,output=scalar(value)
            table.insert(lines,table.concat({"value",tostring(resource.guid),type_name,tostring(resource.part),path,state,output},"\t"))
        end
    end
end
local function scan(type_name,paths)
    local ok,resources=pcall(function() return game.assets.get_resources_by_type(type_name) end)
    if not ok or type(resources)~="table" then err("get_resources_by_type:"..type_name,resources); return end
    table.insert(lines,"family\t"..type_name.."\tcount="..tostring(#resources))
    for _,resource in ipairs(resources) do inspect(resource,type_name,paths) end
end
scan("keen::ItemInfo",{"itemId","objectId","iconImage","iconModel","iconScene","equipment.placedEntity","equipment.visualEntity","equipment.visualModel","equipment.material","equipment.texture"})
scan("keen::RecipeRegistryResource",{"recipes.1.recipeId","recipes.1.itemId","recipes.1.result","recipes.1.outputs","recipes.1.inputs"})
scan("keen::ItemRegistryResource",{"itemRefs.1","itemRefs.1.value","itemRefs.1.guid","itemRefs.1.itemId"})
scan("keen::FbUiBundle",{"menu.crafting.recipes.trees.1","menu.crafting.recipes.trees.1.entries"})
if had_error then lines[4]="evidence_state=partial" end
lines[5]="collection_status=completed"
local ok_export,export_error=pcall(function() io.export("embervault/reference-value-v1.tsv",table.concat(lines,"\n").."\n") end)
if not ok_export then print("EMBERVAULT_REFERENCE_VALUE|EXPORT_ERROR|"..tostring(export_error)) end
