-- Read-only nested reference probe. No mutation, patching, or save access.
local lines={"schema_version=1","probe_id=nested-reference","probe_version=1.0.0","evidence_state=observed","collection_status=started","limitations=bounded nested reference presence and type metadata; no semantic or runtime claim"}
local had_error=false
local function err(scope,msg) had_error=true; table.insert(lines,"error\t"..tostring(scope).."\t"..tostring(msg)) end
local function inspect(resource,type_name,paths)
    for _,path in ipairs(paths) do
        local ok,value=pcall(function()
            local current=resource.data
            for part in string.gmatch(path,"[^%.]+") do current=current[part] end
            return current
        end)
        local state="missing"; local value_type=""
        if not ok then state="error"; value_type=tostring(value); had_error=true
        elseif value~=nil then state="present"; value_type=type(value) end
        table.insert(lines,table.concat({"reference",tostring(resource.guid),type_name,tostring(resource.part),path,state,value_type},"\t"))
    end
end
local function scan(type_name,paths)
    local ok,resources=pcall(function() return game.assets.get_resources_by_type(type_name) end)
    if not ok or type(resources)~="table" then err("get_resources_by_type:"..type_name,resources); return end
    table.insert(lines,"family\t"..type_name.."\tcount="..tostring(#resources))
    for _,resource in ipairs(resources) do inspect(resource,type_name,paths) end
end
scan("keen::ItemInfo",{"equipment.placedEntity","equipment.visualModel","equipment.visualEntity","equipment.iconModel","equipment.iconScene","equipment.material","equipment.texture","placedEntity","visualModel","visualEntity","iconModel","iconScene","objectId"})
scan("keen::RecipeRegistryResource",{"recipes","recipes.1.recipeId","recipes.1.itemId","recipes.1.result","recipes.1.outputs","recipes.1.inputs"})
scan("keen::ItemRegistryResource",{"itemRefs","items","entries"})
scan("keen::VoxelBlueprintItemRegistryResource",{"itemRefs","items","entries"})
scan("keen::ecs::TemplateResource",{"model","visualModel","components","entities","entityData"})
scan("keen::FbUiBundle",{"menu.crafting.recipes.trees","menu.crafting.recipes.entries","menu.crafting.groups"})
if had_error then lines[4]="evidence_state=partial" end
lines[5]="collection_status=completed"
local ok_export,export_error=pcall(function() io.export("embervault/nested-reference-v1.tsv",table.concat(lines,"\n").."\n") end)
if not ok_export then print("EMBERVAULT_NESTED_REFERENCE|EXPORT_ERROR|"..tostring(export_error)) end
