-- Read-only ECS worker scheduler for EmberVault probes.
--
-- The scheduler deliberately runs one registry operation at a time. ECS queries
-- can remain in a scanning state, so workers yield between updates instead of
-- blocking or repeatedly starting duplicate scans.

local Scheduler = {}
Scheduler.__index = Scheduler

function Scheduler.new(runtime, options)
  options = options or {}
  return setmetatable({
    runtime = runtime,
    jobs = {},
    order = {},
    cursor = 1,
    active = nil,
    ticks = 0,
    timeout_seconds = options.timeout_seconds or 180,
    max_total_seconds = options.max_total_seconds or options.timeout_seconds or 180,
    max_items_per_job = options.max_items_per_job or 160,
    completed = {},
    errors = {},
  }, Scheduler)
end

function Scheduler:add(id, operation, options)
  assert(type(id) == "string" and id ~= "", "worker id is required")
  assert(type(operation) == "function", "worker operation is required")
  options = options or {}
  self.jobs[id] = {
    id = id,
    operation = operation,
    timeout_seconds = options.timeout_seconds or self.timeout_seconds,
    max_items = options.max_items or self.max_items_per_job,
    attempts = 0,
    status = "queued",
    started_at = nil,
    result = nil,
    error = nil,
  }
  self.order[#self.order + 1] = id
  return self.jobs[id]
end

function Scheduler:status(id)
  local job = self.jobs[id]
  if not job then return nil end
  return {
    id = job.id,
    status = job.status,
    attempts = job.attempts,
    error = job.error,
  }
end

local function is_scanning(reason)
  return type(reason) == "string" and string.find(reason, "scanning", 1, true) ~= nil
end

local function is_retryable(reason)
  if type(reason) ~= "string" then return false end
  return string.find(reason, "not ready", 1, true) ~= nil
    or string.find(reason, "invalid arguments", 1, true) ~= nil
    or string.find(reason, "unavailable", 1, true) ~= nil
    or string.find(reason, "retry", 1, true) ~= nil
    or string.find(reason, "context changed", 1, true) ~= nil
    or is_scanning(reason)
end

function Scheduler:step()
  self.ticks = self.ticks + 1
  if self.ticks > self.max_total_seconds then
    if self.active then
      self.active.status = "timeout"
      self.active.error = "census deadline exceeded"
      self.errors[self.active.id] = self.active.error
      self.active = nil
    end
    for _, id in ipairs(self.order) do
      local job = self.jobs[id]
      if job and (job.status == "queued" or job.status == "waiting" or job.status == "running") then
        job.status = "timeout"
        job.error = "census deadline exceeded"
        self.errors[id] = job.error
      end
    end
    return true
  end
  if self.active then
    local job = self.active
    if self.ticks - job.started_at > job.timeout_seconds then
      job.status = "timeout"
      job.error = "worker timeout"
      self.errors[job.id] = job.error
      self.active = nil
    else
      local ok, done, result, reason = pcall(job.operation, job)
      if not ok then
        job.status = "error"
        job.error = tostring(done)
        self.errors[job.id] = job.error
        self.active = nil
      elseif done == true then
        job.status = "complete"
        job.result = result
        self.completed[job.id] = result
        self.active = nil
      elseif is_retryable(reason) then
        job.status = "waiting"
      elseif reason ~= nil then
        job.status = "error"
        job.error = tostring(reason)
        self.errors[job.id] = job.error
        self.active = nil
      else
        job.status = "waiting"
      end
    end
  end

  if self.active then return false end
  for _ = 1, #self.order do
    local id = self.order[self.cursor]
    self.cursor = (self.cursor % #self.order) + 1
    local job = self.jobs[id]
    if job and (job.status == "queued" or job.status == "waiting") then
      if not job.started_at then job.started_at = self.ticks end
      job.attempts = job.attempts + 1
      job.status = "running"
      self.active = job
      return false
    end
  end
  return true
end

function Scheduler:summary()
  local output = {}
  for _, id in ipairs(self.order) do
    local job = self.jobs[id]
    output[#output + 1] = {
      id = id,
      status = job.status,
      attempts = job.attempts,
      error = job.error,
    }
  end
  return output
end

return Scheduler
