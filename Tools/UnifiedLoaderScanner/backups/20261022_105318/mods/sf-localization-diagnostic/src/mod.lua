local reported = false

local function report()
    if reported then return end
    reported = true
    runtime.report_effect("observed", "ShroudForge localization diagnostic loaded; no writes performed")
end

report()
