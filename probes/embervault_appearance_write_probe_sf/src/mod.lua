-- Guarded no-op write test. Private/local scope only. No save access, entity enumeration, or native calls.
local lines={"schema_version=1","probe_id=appearance-write","probe_version=1.0.0","evidence_state=observed","operation_status=started","limitations=no-op write only; tests preset resource path, not live player ownership"}
local function add(k,v) table.insert(lines,k.."\t"..tostring(v)) end
local function scalar(v)
  if v==nil then return nil end
  local ok,value=pcall(function() return v.value end)
  if ok and value~=nil then return value end
  return v
end
local ok,resources=pcall(function() return game.assets.get_resources_by_type("keen::CharacterPresetCollection") end)
if not ok or type(resources)~="table" or #resources<1 then
  add("status","not_run")
  add("reason",resources or "CharacterPresetCollection unavailable")
else
  local ok_data,data=pcall(function() return resources[1].data end)
  local ok_presets,presets=pcall(function() return data.presets end)
  local ok_preset,preset=pcall(function() return presets[1] end)
  local ok_hair,hair=pcall(function() return preset.hair end)
  local before=ok_hair and scalar(hair) or nil
  add("resource_available",true)
  add("target_field","CharacterPresetCollection.presets[1].hair")
  add("before",before)
  if before==nil then
    add("status","not_run")
    add("reason","hair value unavailable")
  else
    local ok_write,write_error=pcall(function() hair.value=before end)
    add("write_attempted",true)
    add("write_result",ok_write and "accepted" or "rejected")
    if not ok_write then add("write_error",write_error) end
    local after=scalar(hair)
    add("after",after)
    add("readback_match",after==before)
    local ok_restore,restore_error=pcall(function() hair.value=before end)
    add("restore_result",ok_restore and "accepted" or "rejected")
    if not ok_restore then add("restore_error",restore_error) end
    add("restored_value",scalar(hair))
    add("status",(ok_write and after==before and ok_restore) and "passed_noop" or "failed")
  end
end
add("entities","not_enumerated")
add("saves","not_accessed")
local ok_export,export_error=pcall(function() io.export("embervault/appearance-write-v1.tsv",table.concat(lines,"\n").."\n") end)
if not ok_export then print("EMBERVAULT_APPEARANCE_WRITE|EXPORT_ERROR|"..tostring(export_error)) end
