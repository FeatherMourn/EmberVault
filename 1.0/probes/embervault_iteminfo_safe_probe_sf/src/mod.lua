-- Read-only single-family probe. No recipes, templates, RenderModel traversal, or saves.
local lines={"schema_version=1","probe_id=iteminfo-safe","probe_version=1.0.0","evidence_state=observed","collection_status=started","limitations=ItemInfo scalar/reference fields only"}
local had_error=false
local function scalar(v)
  if v==nil then return "missing","" end
  local k=type(v)
  if k=="string" or k=="number" or k=="boolean" then return "scalar",tostring(v) end
  for _,key in ipairs({"value","guid","id","hash"}) do
    local ok,n=pcall(function() return v[key] end)
    if ok and n~=nil then local sk,sv=scalar(n); if sk=="scalar" then return key,sv end end
  end
  return k,""
end
local function read(data,path)
  local current=data
  for part in string.gmatch(path,"[^%.]+") do current=current[part] end
  return current
end
local ok,items=pcall(function() return game.assets.get_resources_by_type("keen::ItemInfo") end)
if not ok or type(items)~="table" then
  had_error=true; lines[4]="evidence_state=partial"; table.insert(lines,"error\titeminfo_lookup\t"..tostring(items))
else
  table.insert(lines,"family\tkeen::ItemInfo\tcount="..tostring(#items))
  local fields={"itemId","objectId","iconImage","iconModel","iconScene","equipment.placedEntity","equipment.visualEntity","equipment.visualModel"}
  for _,resource in ipairs(items) do
    for _,path in ipairs(fields) do
      local got,value=pcall(function() return read(resource.data,path) end)
      if not got then had_error=true; lines[4]="evidence_state=partial"; table.insert(lines,"error\t"..tostring(path).."\t"..tostring(value))
      else local state,out=scalar(value); table.insert(lines,table.concat({"value",tostring(resource.guid),"keen::ItemInfo",tostring(resource.part),path,state,out},"\t")) end
    end
  end
end
lines[5]="collection_status=completed"
local ok_export,export_error=pcall(function() io.export("embervault/iteminfo-safe-v1.tsv",table.concat(lines,"\n").."\n") end)
if not ok_export then print("EMBERVAULT_ITEMINFO_SAFE|EXPORT_ERROR|"..tostring(export_error)) end
