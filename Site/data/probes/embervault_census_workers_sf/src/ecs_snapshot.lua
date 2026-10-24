local Snapshot = {}
Snapshot.__index = Snapshot
function Snapshot.new(runtime) return setmetatable({runtime=runtime,generation_key=nil,queries={},reads={}},Snapshot) end
function Snapshot:reset_if_changed()
  local ok,player=pcall(function() return self.runtime.ecs.get_local_player() end)
  if ok and player~=nil then
    local key=tostring(player.entityId)..":"..tostring(player.generation)..":"..tostring(player.sequence)
    if self.generation_key~=nil and self.generation_key~=key then self.queries={}; self.reads={} end
    self.generation_key=key
  end
end
function Snapshot:query(component)
  self:reset_if_changed(); if self.queries[component]~=nil then return self.queries[component],nil end
  local ok,entities,reason=pcall(function() return self.runtime.ecs.query(component) end)
  if not ok then return nil,tostring(entities) end; if entities==nil then return nil,reason end
  self.queries[component]=entities; return entities,nil
end
function Snapshot:read_fields(entity,component,fields)
  self:reset_if_changed(); local key=tostring(entity).."|"..component.."|"..table.concat(fields,",")
  if self.reads[key]~=nil then return self.reads[key],nil end
  local ok,values,reason=pcall(function() return self.runtime.ecs.read_fields(entity,component,fields) end)
  if not ok then return nil,tostring(values) end; if values==nil then return nil,reason end
  self.reads[key]=values; return values,nil
end
function Snapshot:stats()
  local q,r=0,0; for _ in pairs(self.queries) do q=q+1 end; for _ in pairs(self.reads) do r=r+1 end
  local generation_key = self.generation_key
  if generation_key == nil and self.runtime.world and self.runtime.world.session_id then
    local ok, session = pcall(function() return self.runtime.world.session_id() end)
    if ok and type(session) == "number" and session > 0 then generation_key = "session:" .. tostring(session) end
  end
  return {generation_key=generation_key,cached_queries=q,cached_reads=r}
end
return Snapshot
