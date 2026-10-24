-- Read-only bounded localization tag probe.
local lines={"schema_version=1","probe_id=loca-tag","probe_version=1.0.0","evidence_state=observed","collection_status=started","limitations=bounded scalar fields only; no runtime claim"}
local had_error=false
local function err(scope,msg) had_error=true; local t=tostring(msg); if #t>240 then t=string.sub(t,1,240) end; table.insert(lines,"error\t"..tostring(scope).."\t"..t) end
local function scalar(v,d)
 if v==nil or (d or 0)>2 then return "" end
 local k=type(v); if k=="string" or k=="number" or k=="boolean" then return tostring(v) end
 for _,key in ipairs({"value","text","key","tag","id"}) do local ok,n=pcall(function() return v[key] end); if ok and n~=nil then local s=scalar(n,(d or 0)+1); if s~="" then return s end end end
 return ""
end
local ok,items=pcall(function() return game.assets.get_resources_by_type("keen::LocaTagCollectionResource") end)
if not ok or type(items)~="table" then err("get_resources_by_type","call_failed") else
 table.insert(lines,"family\tkeen::LocaTagCollectionResource\tcount="..tostring(#items))
 for _,item in ipairs(items) do
  local data=item.data; for _,path in ipairs({"value","text","key","tags","entries"}) do local success,val=pcall(function() return data[path] end); if success then table.insert(lines,table.concat({"loca",tostring(item.guid),tostring(item.part),path,scalar(val,0)},"\t")) else err(tostring(item.guid)..":"..path,"access_failed") end end
 end
end
if had_error then lines[4]="evidence_state=partial" end; lines[5]="collection_status=completed"; pcall(function() io.export("embervault/loca-tags-v1.tsv",table.concat(lines,"\n").."\n") end)
