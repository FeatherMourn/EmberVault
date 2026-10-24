-- Extend both the selectable steps and the actual world-setting bounds.
-- Existing world values, minimums and difficulty presets are left unchanged.
local TAG = "[XHL-Enemy-Difficulty-Limits]"
local SETTINGS = {
    {option = "enemyDamage", field = "enemyDamageFactor"},
    {option = "bossDamage", field = "bossDamageFactor"},
    {option = "enemyHealth", field = "enemyHealthFactor"},
    {option = "bossHealth", field = "bossHealthFactor"},
    {option = "enemyStamina", field = "enemyStaminaFactor"},
    {option = "enemyPerceptionRange", field = "enemyPerceptionRangeFactor"},
    {option = "enemyAttackFrequency", field = "threatBonus"},
}
local EXTRA_STEPS = {2.5, 3, 4, 5, 7.5, 10, 15, 20, 30, 50, 75, 100}

local bundles = game.assets.get_resources_by_type("keen::FbUiBundle")
assert(#bundles > 0, TAG .. " FbUiBundle not found")
local presetResources = game.assets.get_resources_by_type("keen::GameSettingsPresetsResource")
assert(#presetResources > 0, TAG .. " GameSettingsPresetsResource not found")

-- Validate the resource layout before changing any of the seven arrays.
local targets = {}
for _, resource in ipairs(bundles) do
    local settings = resource.data.difficultySettings.settingValues
    for _, mapping in ipairs(SETTINGS) do
        local key = mapping.option
        local setting = settings[key]
        assert(setting ~= nil, TAG .. " missing setting: " .. key)
        local steps = setting.steps
        assert(steps ~= nil and #steps > 0, TAG .. " missing steps: " .. key)
        targets[#targets + 1] = {key = key, steps = steps}
    end
end
for _, resource in ipairs(presetResources) do
    local limits = resource.data.maxValues
    for _, mapping in ipairs(SETTINGS) do
        assert(type(limits[mapping.field]) == "number", TAG .. " missing maximum: " .. mapping.field)
    end
end

for _, target in ipairs(targets) do
    local steps = target.steps
    local previousMaximum = steps[#steps]
    local added = 0
    for _, value in ipairs(EXTRA_STEPS) do
        if value > steps[#steps] then
            table.insert(steps, value)
            added = added + 1
        end
    end
    print(TAG .. " " .. target.key .. " max=" .. previousMaximum .. " -> " .. steps[#steps] ..
        ", added=" .. added)
end

for _, resource in ipairs(presetResources) do
    local limits = resource.data.maxValues
    for _, mapping in ipairs(SETTINGS) do
        local previousMaximum = limits[mapping.field]
        limits[mapping.field] = 100
        print(TAG .. " world limit " .. mapping.field .. "=" .. previousMaximum .. " -> " .. limits[mapping.field])
    end
end
