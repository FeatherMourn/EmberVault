-- Packaged copy is generated from 1.0/probes/common/ecs_read_scheduler.lua.
local Scheduler = {}
Scheduler.__index = Scheduler
function Scheduler.new(runtime, options)
  options = options or {}
  return setmetatable({runtime=runtime, jobs={}, order={}, cursor=1, active=nil, ticks=0, timeout_seconds=options.timeout_seconds or 180, max_total_seconds=options.max_total_seconds or options.timeout_seconds or 180, max_items_per_job=options.max_items_per_job or 160, completed={}, errors={}}, Scheduler)
end
function Scheduler:add(id, operation, options)
  options = options or {}
  self.jobs[id] = {id=id, operation=operation, timeout_seconds=options.timeout_seconds or self.timeout_seconds, max_items=options.max_items or self.max_items_per_job, attempts=0, status="queued", started_at=nil, result=nil, error=nil}
  self.order[#self.order+1] = id
end
local function scanning(reason)
  if type(reason)~="string" then return false end
  return string.find(reason,"scanning",1,true)~=nil or string.find(reason,"not ready",1,true)~=nil
    or string.find(reason,"invalid arguments",1,true)~=nil or string.find(reason,"unavailable",1,true)~=nil
    or string.find(reason,"retry",1,true)~=nil or string.find(reason,"context changed",1,true)~=nil
end
function Scheduler:step()
  self.ticks=self.ticks+1
  if self.ticks > self.max_total_seconds then
    if self.active then self.active.status="timeout"; self.active.error="census deadline exceeded"; self.active=nil end
    for _,id in ipairs(self.order) do
      local job=self.jobs[id]
      if job and (job.status=="queued" or job.status=="waiting" or job.status=="running") then job.status="timeout"; job.error="census deadline exceeded" end
    end
    return true
  end
  if self.active then
    local job=self.active
    if self.ticks-(job.started_at or self.ticks) > job.timeout_seconds then job.status="timeout"; job.error="worker timeout"; self.active=nil
    else
      local ok,done,result,reason=pcall(job.operation,job)
      if not ok then job.status="error"; job.error=tostring(done); self.active=nil
      elseif done==true then job.status="complete"; job.result=result; self.active=nil
      elseif scanning(reason) then job.status="waiting"; self.active=nil
      elseif reason~=nil then job.status="error"; job.error=tostring(reason); self.active=nil
      else job.status="waiting"; self.active=nil end
    end
  end
  if self.active then return false end
  for _=1,#self.order do
    local id=self.order[self.cursor]; self.cursor=(self.cursor % #self.order)+1; local job=self.jobs[id]
    if job and (job.status=="queued" or job.status=="waiting") then
      job.started_at=job.started_at or self.ticks; job.attempts=job.attempts+1; job.status="running"; self.active=job; return false
    end
  end
  return true
end
function Scheduler:summary()
  local result={}
  for _,id in ipairs(self.order) do
    local job=self.jobs[id]
    local result_status = type(job.result)=="table" and job.result.status or nil
    local result_reason = type(job.result)=="table" and job.result.reason or nil
    result[#result+1]={id=id,status=result_status or job.status,attempts=job.attempts,error=job.error,reason=result_reason}
  end
  return result
end
function Scheduler:checkpoint()
  local jobs = {}
  for _, id in ipairs(self.order) do
    local job = self.jobs[id]
    jobs[#jobs + 1] = {id=id,status=job.status,attempts=job.attempts}
  end
  return {cursor=self.cursor,active=self.active and self.active.id or nil,ticks=self.ticks,jobs=jobs}
end
return Scheduler
