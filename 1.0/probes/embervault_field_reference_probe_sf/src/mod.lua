-- Read-only bounded field-reference probe. No mutation, patching, or save access.
local lines={"schema_version=1","probe_id=field-reference","probe_version=1.0.0","evidence_state=observed","collection_status=started","limitations=candidate field presence only; no semantic or runtime claim"}
local had_error=false
local function err(scope,msg) had_error=true; table.insert(lines,"error\t"..tostring(scope).."\t"..tostring(msg)) end
local function safe_field(data,path)
    local ok,value=pcall(function()
        local current=data
        for part in string.gmatch(path,"[^%.]+") do current=current[part] end
        return current
    end)
    if not ok then return "error",tostring(value) end
    if value==nil then return "missing","" end
    return "present",type(value)
end
local function scan(type_name,fields)
    local ok,resources=pcall(function() return game.assets.get_resources_by_type(type_name) end)
    if not ok or type(resources)~="table" then err("get_resources_by_type:"..type_name,resources); return end
    table.insert(lines,"family\t"..type_name.."\tcount="..tostring(#resources))
    for _,resource in ipairs(resources) do
        for _,field in ipairs(fields) do
            local state,value=safe_field(resource.data,field)
            table.insert(lines,table.concat({"field",tostring(resource.guid),type_name,tostring(resource.part),field,state,value},"\t"))
        end
    end
end
scan("keen::ItemInfo",{"itemId","name","caption","description","iconImage","equipment","placedEntity","model"})
scan("keen::RecipeRegistryResource",{"recipes","recipes.1.recipeId"})
scan("keen::RenderModel",{"model","mesh","materials","textures"})
scan("keen::ecs::TemplateResource",{"model","components","entities"})
scan("keen::FbUiBundle",{"menu","menu.crafting","menu.crafting.recipes","menu.crafting.recipes.trees"})
if had_error then lines[4]="evidence_state=partial" end
lines[5]="collection_status=completed"
local ok_export,export_error=pcall(function() io.export("embervault/field-reference-v1.tsv",table.concat(lines,"\n").."\n") end)
if not ok_export then print("EMBERVAULT_FIELD_REFERENCE|EXPORT_ERROR|"..tostring(export_error)) end
