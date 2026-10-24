-- Read-only ECS/template metadata search. No entity enumeration, writes, natives, or saves.
local lines={"schema_version=1","probe_id=ecs-appearance-component","probe_version=1.0.0","evidence_state=observed","collection_status=started","limitations=metadata and field-presence search only; no semantic or writable-field claim"}
local needles={"appearance","hair","beard","facial","body","scale","character","model","mesh","attachment","cosmetic"}
local function lower(v) return string.lower(tostring(v)) end
local function hit(name)
  local text=lower(name)
  for _,needle in ipairs(needles) do if string.find(text,needle,1,true) then return needle end end
end
local function add(label,value) table.insert(lines,label.."\t"..tostring(value)) end
local function safe(label,fn)
  local ok,value=pcall(fn)
  if ok then add(label,value) else add(label,"error="..tostring(value)) end
end
safe("ecs.registry",function() return runtime.ecs.get_registry() end)
safe("ecs.registry.type",function() return type(runtime.ecs.get_registry()) end)
safe("reflected.type.count",function()
  local all=runtime.types.get_all(); local count=0
  for _ in pairs(all) do count=count+1 end
  return count
end)
safe("template.resource.count",function() return #game.assets.get_resources_by_type("keen::ecs::TemplateResource") end)
safe("render.model.count",function() return #game.assets.get_resources_by_type("keen::RenderModel") end)
local ok,all=pcall(function() return runtime.types.get_all() end)
if ok and type(all)=="table" then
  for key,value in pairs(all) do
    local name=tostring(key)
    local match=hit(name) or hit(value)
    if match then add("candidate_type",match.."\t"..name.."\t"..tostring(value)) end
  end
end
for _,path in ipairs({"components","appearance","hair","facialHair","body","scale","model","mesh","materials","attachments"}) do add("template_candidate_field",path) end
add("entities","not_enumerated")
add("writes","not_attempted")
add("saves","not_accessed")
lines[5]="collection_status=completed"
local ok_export,export_error=pcall(function() io.export("embervault/ecs-appearance-component-v1.tsv",table.concat(lines,"\n").."\n") end)
if not ok_export then print("EMBERVAULT_ECS_APPEARANCE|EXPORT_ERROR|"..tostring(export_error)) end
