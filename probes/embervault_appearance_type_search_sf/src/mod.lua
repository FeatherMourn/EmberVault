-- Read-only reflected type-name search. No entities, fields, writes, natives, or saves.
local lines={"schema_version=1","probe_id=appearance-type-search","probe_version=1.0.0","evidence_state=observed","collection_status=started","limitations=type-name candidates only; no semantic or writable-field claim"}
local needles={"appearance","hair","beard","facial","body","scale","character","model","mesh","attachment","cosmetic"}
local function lower(v) return string.lower(tostring(v)) end
local function matches(name)
  local text=lower(name)
  for _,needle in ipairs(needles) do if string.find(text,needle,1,true) then return needle end end
  return nil
end
local ok,types=pcall(function() return runtime.types.get_all() end)
if not ok or type(types)~="table" then
  lines[4]="evidence_state=partial"
  table.insert(lines,"error\ttype_registry\t"..tostring(types))
else
  local count=0
  for key,value in pairs(types) do
    local name=tostring(key)
    local hit=matches(name) or matches(value)
    if hit then count=count+1; table.insert(lines,"candidate\t"..hit.."\t"..name.."\t"..tostring(value)) end
  end
  table.insert(lines,"candidate_count\t"..tostring(count))
end
lines[5]="collection_status=completed"
local ok_export,export_error=pcall(function() io.export("embervault/appearance-type-search-v1.tsv",table.concat(lines,"\n").."\n") end)
if not ok_export then print("EMBERVAULT_APPEARANCE_TYPE_SEARCH|EXPORT_ERROR|"..tostring(export_error)) end
