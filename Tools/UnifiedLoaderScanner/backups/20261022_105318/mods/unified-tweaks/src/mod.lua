-- ============================================================================
-- ShroudForge Settings Loader
-- Overrides config values from the Modloader UI. Core logic below is unchanged.
-- ============================================================================

local _FALLBACKS = {
            ["Enable_NoIntroVideo"] = false,
    ["Enable_PlayerItemLevelTweaks"] = false,
    ["Enable_ItemLevelCapSync"] = false,
    ["PlayerLevelMax"] = 100,
    ["PlayerLevelCap"] = 50,
    ["ItemLevelCap"] = 55,
    ["SkillPointsPerLevel"] = 2,
    ["Enable_ItemLevelMinimums"] = false,
    ["Enable_ItemLevelMin_Weapon"] = false,
    ["ItemLevelMin_Weapon"] = 50,
    ["Enable_ItemLevelMin_Armor"] = false,
    ["ItemLevelMin_Armor"] = 50,
    ["Enable_ItemLevelMin_Shield"] = false,
    ["ItemLevelMin_Shield"] = 50,
    ["Enable_ItemLevelMin_Gem"] = false,
    ["ItemLevelMin_Gem"] = 0,
    ["Enable_ItemLevelMin_Ring"] = false,
    ["ItemLevelMin_Ring"] = 0,
    ["Enable_ItemLevelMin_Spell"] = false,
    ["ItemLevelMin_Spell"] = 0,
    ["Enable_ItemLevelMin_Arrow"] = false,
    ["ItemLevelMin_Arrow"] = 0,
    ["Enable_ItemLevelMin_Tool"] = false,
    ["ItemLevelMin_Tool"] = 0,
    ["Enable_ItemLevelMin_Misc"] = false,
    ["ItemLevelMin_Misc"] = 0,
    ["Enable_AttributeScaling"] = false,
    ["AttributeScaling_HealthPerCon"] = 10,
    ["AttributeScaling_ManaPerSpi"] = 5,
    ["AttributeScaling_StaminaPerEnd"] = 5,
    ["AttributeScaling_DamagePerAttr"] = "0.0",
    ["Enable_PlayerBaseStats"] = false,
    ["PlayerBase_Health"] = 100,
    ["PlayerBase_Mana"] = 100,
    ["PlayerBase_Stamina"] = 100,
    ["PlayerBase_Oxygen"] = 30,
    ["PlayerBase_FogResistance"] = 240,
    ["PlayerFog_PerFlameLevel"] = 60,
    ["Enable_DamageTweaks"] = false,
    ["DamageMult_Melee1H"] = "1.0",
    ["DamageMult_Melee2H"] = "1.0",
    ["DamageMult_Range"] = "1.0",
    ["DamageMult_Wand"] = "1.0",
    ["DamageMult_Arrow"] = "1.0",
    ["DamageMult_Spell"] = "1.0",
    ["Enable_ToolTweaks"] = false,
    ["ToolMult_Axe"] = "1.0",
    ["ToolMult_Pickaxe"] = "1.0",
    ["Enable_SpellTweaks"] = false,
    ["SpellCastTime_Multiplier"] = "1.0",
    ["SpellManaCost_Multiplier"] = "1.0",
                    ["RegenMult_Health"] = "1.0",
    ["RegenMult_Mana"] = "1.0",
    ["RegenMult_Stamina"] = "1.0",
    ["Enable_GearStatTweaks"] = false,
    ["GearMult_HealthBonus"] = "1.0",
    ["GearMult_StaminaBonus"] = "1.0",
    ["GearMult_ManaBonus"] = "1.0",
    ["Enable_BackpackTweaks"] = false,
    ["Backpack_MaxSlots"] = 20,
    ["Enable_StackSizeTweaks"] = false,
    ["StackSize_MaxStack"] = 100,
    ["Enable_ChestSizeTweaks"] = false,
    ["Chest_MaxSlots"] = 48,
    ["Enable_MagicFurniture"] = false,
    ["Enable_MagicFactories"] = false,
    ["Enable_LootTweaks"] = false,
    ["Loot_EquipmentDropMultiplier"] = "1.0",
    ["Loot_ConsumableDropMultiplier"] = "1.0",
    ["Loot_ArrowDropMultiplier"] = "1.0",
    ["Loot_GemDropMultiplier"] = "1.0",
    ["Loot_ExplosiveDropMultiplier"] = "1.0",
    ["Loot_MaxStackSize"] = 100,
    ["Enable_GemTweaks"] = false,
    ["GemTweaks_SalvageRate"] = "1.0",
    ["GemTweaks_Probability_Common"] = "1.0",
    ["GemTweaks_Probability_Uncommon"] = "1.0",
    ["GemTweaks_Probability_Rare"] = "1.0",
    ["GemTweaks_Probability_Epic"] = "1.0",
    ["GemTweaks_Probability_Legendary"] = "1.0",
    ["Enable_CraftingTweaks"] = false,
    ["CraftingTweaks_UnlockAllRecipes"] = false,
    ["CraftingTweaks_CreativeMode"] = false,
    ["CraftingTweaks_FreeFactories"] = false,
    ["CraftingTweaks_FreeFlameAltar"] = false,
    ["CraftingTweaks_FreeFood"] = false,
    ["CraftingTweaks_OutputMultiplier"] = "1.0",
    ["Enable_FastTravelTweaks"] = false,
    ["FastTravel_FlameMarkers"] = false,
    ["FastTravel_DungeonMarkers"] = false,
    ["FastTravel_LocationMarkers"] = false,
    ["FastTravel_None"] = false,
    ["Enable_FogOfWarTweaks"] = false,
    ["FogOfWar_Range"] = 100,
    ["Enable_SkillTweaks_Updraft"] = false,
    ["Updraft_IgnoreManaCost"] = false,
    ["GroundRelative_Y"] = "",
    ["Enable_SlopeTweaks"] = false,
    ["steepFloorAngle"] = "45.0",
    ["slidingAngle"] = "45.0",
    ["fallDamageAngle"] = "45.0",
    ["Max_Angle"] = "45.0",
    ["Enable_FlameAltarTweaks"] = false,
    ["MaxFlameAltars_Multiplier"] = "1.0",
    ["MaxFlameAltars_Cap"] = 8,
    ["Enable_BaseSizeTweaks"] = false,
    ["BaseSize_Multiplier"] = "1.0",
    ["Enable_PlacementTweaks"] = false,
    ["Enable_BuildingTweaks"] = false,
    ["PlacementTweaks_BuildInFog"] = false,
    ["PlacementTweaks_NoBuildZoneNeeded"] = false,
    ["Enable_FogTweaks"] = false,
    ["Rain_Opacity"] = "1.0",
    ["Snow_Opacity"] = "1.0",
    ["Blizzard_Opacity"] = "1.0",
    ["Ambient_Fog_Density"] = "6.0",
    ["Fog_M1_Density"] = "0.3",
    ["Fog_M1_Opacity"] = "0.1",
    ["HeightFog_Density"] = "0.0012",
    ["HeightFog_Opacity"] = "0.15",
    ["Shroud_Fog_Dangerous_Density"] = "0.64",
    ["Shroud_Fog_Dangerous_Opacity"] = "0.23",
    ["Dangerous_Fog_Barrier_Exposed_Emissive_Intensity"] = "0.1",
    ["Dangerous_Fog_Barrier_Emissive_Intensity"] = "0.0",
    ["Dangerous_Fog_Barrier_Opacity"] = "0.3",
    ["Dangerous_Fog_Barrier_Scatter_Boost"] = "2.0",
    ["Shroud_Fog_Deadly_Density"] = "0.64",
    ["Shroud_Fog_Deadly_Opacity"] = "0.23",
    ["Deadly_Fog_Barrier_Exposed_Emissive_Intensity"] = "0.2",
    ["Deadly_Fog_Barrier_Emissive_Intensity"] = "0.0",
    ["Deadly_Fog_Barrier_Opacity"] = "0.5",
    ["Deadly_Fog_Barrier_Scatter_Boost"] = "2.0",
    ["Enable_GliderTuning"] = false,
    ["Glider_T1_accelerationForward"] = "0.85",
    ["Glider_T1_airResistanceLongitudinal"] = "0.32",
    ["Glider_T1_airResistanceLateral"] = "2.0",
    ["Glider_T1_airResistanceVertical"] = "0.85",
    ["Glider_T1_yawAngleSpeed"] = "80.0",
    ["Glider_T1_pitchAngleSpeed"] = "90.0",
    ["Glider_T1_rollAngleSpeed"] = "160.0",
    ["Glider_T2_accelerationForward"] = "0.95",
    ["Glider_T2_airResistanceLongitudinal"] = "0.24",
    ["Glider_T2_airResistanceLateral"] = "1.75",
    ["Glider_T2_airResistanceVertical"] = "1.35",
    ["Glider_T2_yawAngleSpeed"] = "70.0",
    ["Glider_T2_pitchAngleSpeed"] = "85.0",
    ["Glider_T2_rollAngleSpeed"] = "165.0",
    ["Glider_T3_accelerationForward"] = "1.0",
    ["Glider_T3_airResistanceLongitudinal"] = "0.16",
    ["Glider_T3_airResistanceLateral"] = "1.5",
    ["Glider_T3_airResistanceVertical"] = "1.85",
    ["Glider_T3_yawAngleSpeed"] = "60.0",
    ["Glider_T3_pitchAngleSpeed"] = "80.0",
    ["Glider_T3_rollAngleSpeed"] = "150.0",
    ["Glider_T4_REWARD_accelerationForward"] = "1.0",
    ["Glider_T4_REWARD_airResistanceLongitudinal"] = "0.08",
    ["Glider_T4_REWARD_airResistanceLateral"] = "1.25",
    ["Glider_T4_REWARD_airResistanceVertical"] = "2.35",
    ["Glider_T4_REWARD_yawAngleSpeed"] = "50.0",
    ["Glider_T4_REWARD_pitchAngleSpeed"] = "75.0",
    ["Glider_T4_REWARD_rollAngleSpeed"] = "145.0",
    ["MakeUnbreakableBreakable"] = false,
    ["Enable_TerrainDropTweaks"] = false,
    ["TerrainDrop_ExchangeRate"] = "1.0",
    ["Enable_ExpandedGameSettings"] = false,
    ["EGS_Standard"] = "0.10, 0.25, 0.50, 0.75, 1.0, 1.5, 2.0, 2.5, 3.0, 4.0, 5.0, 6.0, 8.0, 10.0, 12.0, 14.0, 16.0, 18.0, 20.0",
    ["EGS_XP"] = "0.00, 0.10, 0.25, 0.50, 0.75, 1.0, 1.5, 2.0, 2.5, 3.0, 4.0, 5.0, 6.0, 8.0, 10.0, 12.0, 14.0, 16.0, 18.0, 20.0",
    ["EGS_Time"] = "1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 20.0, 30.0, 45.0, 60.0, 120.0, 180.0, 240.0, 360.0, 480.0",
    ["GroundRelative_X"] = "",
    ["GroundRelative_Z"] = "",
    ["PlayerRelative_X"] = "",
    ["PlayerRelative_Y"] = "",
    ["PlayerRelative_Z"] = "",
    ["Boost_Duration"] = "",
    ["Updraft_ManaCost_Value"] = "",
}

local function S(key)
    local fallback = _FALLBACKS[key]
    if not shroudforge or not shroudforge.settings then
        return fallback
    end
    local ok, val = pcall(function()
        return shroudforge.settings.get(key, fallback)
    end)
    if ok and val ~= nil then
        return val
    end
    return fallback
end

-- Logging
Enable_NoIntroVideo = S("Enable_NoIntroVideo")

-- Levels & Progression
Enable_PlayerItemLevelTweaks = S("Enable_PlayerItemLevelTweaks")
Enable_ItemLevelCapSync = S("Enable_ItemLevelCapSync")
PlayerLevelMax = 100 -- hardcoded
PlayerLevelCap = S("PlayerLevelCap")
ItemLevelCap = S("ItemLevelCap")
SkillPointsPerLevel = S("SkillPointsPerLevel")
Enable_ItemLevelMinimums = S("Enable_ItemLevelMinimums")
Enable_ItemLevelMin_Weapon = S("Enable_ItemLevelMin_Weapon")
ItemLevelMin_Weapon = S("ItemLevelMin_Weapon")
Enable_ItemLevelMin_Armor = S("Enable_ItemLevelMin_Armor")
ItemLevelMin_Armor = S("ItemLevelMin_Armor")
Enable_ItemLevelMin_Shield = S("Enable_ItemLevelMin_Shield")
ItemLevelMin_Shield = S("ItemLevelMin_Shield")
Enable_ItemLevelMin_Gem = S("Enable_ItemLevelMin_Gem")
ItemLevelMin_Gem = S("ItemLevelMin_Gem")
Enable_ItemLevelMin_Ring = S("Enable_ItemLevelMin_Ring")
ItemLevelMin_Ring = S("ItemLevelMin_Ring")
Enable_ItemLevelMin_Spell = S("Enable_ItemLevelMin_Spell")
ItemLevelMin_Spell = S("ItemLevelMin_Spell")
Enable_ItemLevelMin_Arrow = S("Enable_ItemLevelMin_Arrow")
ItemLevelMin_Arrow = S("ItemLevelMin_Arrow")
Enable_ItemLevelMin_Tool = S("Enable_ItemLevelMin_Tool")
ItemLevelMin_Tool = S("ItemLevelMin_Tool")
Enable_ItemLevelMin_Misc = S("Enable_ItemLevelMin_Misc")
ItemLevelMin_Misc = S("ItemLevelMin_Misc")
Enable_AttributeScaling = S("Enable_AttributeScaling")
AttributeScaling_HealthPerCon = S("AttributeScaling_HealthPerCon")
AttributeScaling_ManaPerSpi = S("AttributeScaling_ManaPerSpi")
AttributeScaling_StaminaPerEnd = S("AttributeScaling_StaminaPerEnd")
AttributeScaling_DamagePerAttr = tonumber(S("AttributeScaling_DamagePerAttr"))
Enable_PlayerBaseStats = S("Enable_PlayerBaseStats")
PlayerBase_Health = S("PlayerBase_Health")
PlayerBase_Mana = S("PlayerBase_Mana")
PlayerBase_Stamina = S("PlayerBase_Stamina")
PlayerBase_Oxygen = S("PlayerBase_Oxygen")
PlayerBase_FogResistance = S("PlayerBase_FogResistance")
PlayerFog_PerFlameLevel = S("PlayerFog_PerFlameLevel")

-- Hardcoded clamps and safety skips
PlayerItemLevel_MaxClamp = 150
SkillPoints_MaxClamp = 15
ItemLevelSync_SafetySkip = "Material"

-- Combat & Tools
Enable_DamageTweaks = S("Enable_DamageTweaks")
DamageMult_Melee1H = tonumber(S("DamageMult_Melee1H"))
DamageMult_Melee2H = tonumber(S("DamageMult_Melee2H"))
DamageMult_Range = tonumber(S("DamageMult_Range"))
DamageMult_Wand = tonumber(S("DamageMult_Wand"))
DamageMult_Arrow = tonumber(S("DamageMult_Arrow"))
DamageMult_Spell = tonumber(S("DamageMult_Spell"))
Enable_ToolTweaks = S("Enable_ToolTweaks")
ToolMult_Axe = tonumber(S("ToolMult_Axe"))
ToolMult_Pickaxe = tonumber(S("ToolMult_Pickaxe"))

-- Spells & Buffs
Enable_SpellTweaks = S("Enable_SpellTweaks")
SpellCastTime_Multiplier = tonumber(S("SpellCastTime_Multiplier"))
SpellManaCost_Multiplier = tonumber(S("SpellManaCost_Multiplier"))
RegenMult_Health = tonumber(S("RegenMult_Health"))
RegenMult_Mana = tonumber(S("RegenMult_Mana"))
RegenMult_Stamina = tonumber(S("RegenMult_Stamina"))
Enable_GearStatTweaks = S("Enable_GearStatTweaks")
GearMult_HealthBonus = tonumber(S("GearMult_HealthBonus"))
GearMult_StaminaBonus = tonumber(S("GearMult_StaminaBonus"))
GearMult_ManaBonus = tonumber(S("GearMult_ManaBonus"))
SpellTweaks_MinMultiplier = 0.0  -- hardcoded safety clamp

-- Inventory & Loot
Enable_BackpackTweaks = S("Enable_BackpackTweaks")
Backpack_MaxSlots = S("Backpack_MaxSlots")
Enable_StackSizeTweaks = S("Enable_StackSizeTweaks")
StackSize_MaxStack = S("StackSize_MaxStack")
Enable_ChestSizeTweaks = S("Enable_ChestSizeTweaks")
Chest_MaxSlots = S("Chest_MaxSlots")
Enable_MagicFurniture = S("Enable_MagicFurniture")
Enable_MagicFactories = S("Enable_MagicFactories")
Enable_LootTweaks = S("Enable_LootTweaks")
Loot_EquipmentDropMultiplier = tonumber(S("Loot_EquipmentDropMultiplier"))
Loot_ConsumableDropMultiplier = tonumber(S("Loot_ConsumableDropMultiplier"))
Loot_ArrowDropMultiplier = tonumber(S("Loot_ArrowDropMultiplier"))
Loot_GemDropMultiplier = tonumber(S("Loot_GemDropMultiplier"))
Loot_ExplosiveDropMultiplier = tonumber(S("Loot_ExplosiveDropMultiplier"))
Loot_MaxStackSize = S("Loot_MaxStackSize")
Loot_DropMultiplierMaxClamp = 1000.0
Loot_MaxStackSizeClamp = 65535
Enable_GemTweaks = S("Enable_GemTweaks")
GemTweaks_SalvageRate = tonumber(S("GemTweaks_SalvageRate"))
GemTweaks_Probability_Common = tonumber(S("GemTweaks_Probability_Common"))
GemTweaks_Probability_Uncommon = tonumber(S("GemTweaks_Probability_Uncommon"))
GemTweaks_Probability_Rare = tonumber(S("GemTweaks_Probability_Rare"))
GemTweaks_Probability_Epic = tonumber(S("GemTweaks_Probability_Epic"))
GemTweaks_Probability_Legendary = tonumber(S("GemTweaks_Probability_Legendary"))

-- Crafting
Enable_CraftingTweaks = S("Enable_CraftingTweaks")
CraftingTweaks_UnlockAllRecipes = S("CraftingTweaks_UnlockAllRecipes")
CraftingTweaks_CreativeMode = S("CraftingTweaks_CreativeMode")
CraftingTweaks_FreeFactories = S("CraftingTweaks_FreeFactories")
CraftingTweaks_FreeFlameAltar = S("CraftingTweaks_FreeFlameAltar")
CraftingTweaks_FreeFood = S("CraftingTweaks_FreeFood")
CraftingTweaks_OutputMultiplier = tonumber(S("CraftingTweaks_OutputMultiplier"))

-- Exploration
Enable_FastTravelTweaks = S("Enable_FastTravelTweaks")
FastTravel_FlameMarkers = S("FastTravel_FlameMarkers")
FastTravel_DungeonMarkers = S("FastTravel_DungeonMarkers")
FastTravel_LocationMarkers = S("FastTravel_LocationMarkers")
FastTravel_None = S("FastTravel_None")
Enable_FogOfWarTweaks = S("Enable_FogOfWarTweaks")
FogOfWar_Range = S("FogOfWar_Range")
FogOfWar_MaxRangeClamp = 20000
Enable_SkillTweaks_Updraft = S("Enable_SkillTweaks_Updraft")
Updraft_IgnoreManaCost = S("Updraft_IgnoreManaCost")
local function opt(key)
    local v = S(key)
    if v == "" or v == nil then return nil end
    local n = tonumber(v)
    return n ~= nil and n or nil
end
GroundRelative_X = opt("GroundRelative_X")
GroundRelative_Y = opt("GroundRelative_Y")
GroundRelative_Z = opt("GroundRelative_Z")
PlayerRelative_X = opt("PlayerRelative_X")
PlayerRelative_Y = opt("PlayerRelative_Y")
PlayerRelative_Z = opt("PlayerRelative_Z")
Boost_Duration = opt("Boost_Duration")
Updraft_ManaCost_Value = opt("Updraft_ManaCost_Value")
Enable_SlopeTweaks = S("Enable_SlopeTweaks")
steepFloorAngle = tonumber(S("steepFloorAngle"))
slidingAngle = tonumber(S("slidingAngle"))
fallDamageAngle = tonumber(S("fallDamageAngle"))
Max_Angle = 89.0 -- hardcoded safety clamp

-- Fog & Weather
Enable_FogTweaks = S("Enable_FogTweaks")
Rain_Opacity = tonumber(S("Rain_Opacity"))
Snow_Opacity = tonumber(S("Snow_Opacity"))
Blizzard_Opacity = tonumber(S("Blizzard_Opacity"))
Ambient_Fog_Density = tonumber(S("Ambient_Fog_Density"))
Fog_M1_Density = tonumber(S("Fog_M1_Density"))
Fog_M1_Opacity = tonumber(S("Fog_M1_Opacity"))
HeightFog_Density = tonumber(S("HeightFog_Density"))
HeightFog_Opacity = tonumber(S("HeightFog_Opacity"))
Shroud_Fog_Dangerous_Density = tonumber(S("Shroud_Fog_Dangerous_Density"))
Shroud_Fog_Dangerous_Opacity = tonumber(S("Shroud_Fog_Dangerous_Opacity"))
Dangerous_Fog_Barrier_Exposed_Emissive_Intensity = tonumber(S("Dangerous_Fog_Barrier_Exposed_Emissive_Intensity"))
Dangerous_Fog_Barrier_Emissive_Intensity = tonumber(S("Dangerous_Fog_Barrier_Emissive_Intensity"))
Dangerous_Fog_Barrier_Opacity = tonumber(S("Dangerous_Fog_Barrier_Opacity"))
Dangerous_Fog_Barrier_Scatter_Boost = tonumber(S("Dangerous_Fog_Barrier_Scatter_Boost"))
Shroud_Fog_Deadly_Density = tonumber(S("Shroud_Fog_Deadly_Density"))
Shroud_Fog_Deadly_Opacity = tonumber(S("Shroud_Fog_Deadly_Opacity"))
Deadly_Fog_Barrier_Exposed_Emissive_Intensity = tonumber(S("Deadly_Fog_Barrier_Exposed_Emissive_Intensity"))
Deadly_Fog_Barrier_Emissive_Intensity = tonumber(S("Deadly_Fog_Barrier_Emissive_Intensity"))
Deadly_Fog_Barrier_Opacity = tonumber(S("Deadly_Fog_Barrier_Opacity"))
Deadly_Fog_Barrier_Scatter_Boost = tonumber(S("Deadly_Fog_Barrier_Scatter_Boost"))
Fog_Density_MaxClamp = 100.0
Fog_Opacity_MaxClamp = 100.0
Fog_Emissive_MaxClamp = 100.0
Fog_Scatter_MaxClamp = 20.0

-- Building
Enable_FlameAltarTweaks = S("Enable_FlameAltarTweaks")
MaxFlameAltars_Multiplier = tonumber(S("MaxFlameAltars_Multiplier"))
MaxFlameAltars_Cap = S("MaxFlameAltars_Cap")
FlameAltar_MaxMultiplierClamp = 3.0
Enable_BaseSizeTweaks = S("Enable_BaseSizeTweaks")
BaseSize_Multiplier = tonumber(S("BaseSize_Multiplier"))
BaseSize_MaxMultiplierClamp = 3.0
Enable_PlacementTweaks = S("Enable_PlacementTweaks")
Enable_BuildingTweaks = S("Enable_BuildingTweaks")
PlacementTweaks_BuildInFog = S("PlacementTweaks_BuildInFog")
PlacementTweaks_NoBuildZoneNeeded = S("PlacementTweaks_NoBuildZoneNeeded")
PlacementTweaks_SafetySkip = "Material"

-- Glider Physics
Enable_GliderTuning = S("Enable_GliderTuning")
local function G(tier, prop)
    return tonumber(S("Glider_" .. tier .. "_" .. prop))
end
GliderConfig = {
    T1 = {
        accelerationForward = G("T1", "accelerationForward"),
        airResistanceLongitudinal = G("T1", "airResistanceLongitudinal"),
        airResistanceLateral = G("T1", "airResistanceLateral"),
        airResistanceVertical = G("T1", "airResistanceVertical"),
        yawAngleSpeed = G("T1", "yawAngleSpeed"),
        pitchAngleSpeed = G("T1", "pitchAngleSpeed"),
        rollAngleSpeed = G("T1", "rollAngleSpeed"),
    },
    T2 = {
        accelerationForward = G("T2", "accelerationForward"),
        airResistanceLongitudinal = G("T2", "airResistanceLongitudinal"),
        airResistanceLateral = G("T2", "airResistanceLateral"),
        airResistanceVertical = G("T2", "airResistanceVertical"),
        yawAngleSpeed = G("T2", "yawAngleSpeed"),
        pitchAngleSpeed = G("T2", "pitchAngleSpeed"),
        rollAngleSpeed = G("T2", "rollAngleSpeed"),
    },
    T3 = {
        accelerationForward = G("T3", "accelerationForward"),
        airResistanceLongitudinal = G("T3", "airResistanceLongitudinal"),
        airResistanceLateral = G("T3", "airResistanceLateral"),
        airResistanceVertical = G("T3", "airResistanceVertical"),
        yawAngleSpeed = G("T3", "yawAngleSpeed"),
        pitchAngleSpeed = G("T3", "pitchAngleSpeed"),
        rollAngleSpeed = G("T3", "rollAngleSpeed"),
    },
    T4_REWARD = {
        accelerationForward = G("T4_REWARD", "accelerationForward"),
        airResistanceLongitudinal = G("T4_REWARD", "airResistanceLongitudinal"),
        airResistanceLateral = G("T4_REWARD", "airResistanceLateral"),
        airResistanceVertical = G("T4_REWARD", "airResistanceVertical"),
        yawAngleSpeed = G("T4_REWARD", "yawAngleSpeed"),
        pitchAngleSpeed = G("T4_REWARD", "pitchAngleSpeed"),
        rollAngleSpeed = G("T4_REWARD", "rollAngleSpeed"),
    },
}

-- Terraforming: single toggle makes Unbreakable -> VeryHard
MakeUnbreakableBreakable = S("MakeUnbreakableBreakable")
Enable_TerrainDropTweaks = S("Enable_TerrainDropTweaks")
TerrainDrop_ExchangeRate = tonumber(S("TerrainDrop_ExchangeRate"))
Enable_TerraformingTweaks = MakeUnbreakableBreakable
TerraformingTweaks = {}

-- Expanded Difficulty: three editable arrays
local function parse_array(str, fallback)
    local out = {}
    if type(str) == "string" then
        for token in string.gmatch(str, "[^,]+") do
            local n = tonumber(token)
            if n then table.insert(out, n) end
        end
    end
    if #out == 0 then return fallback end
    return out
end

Enable_ExpandedGameSettings = S("Enable_ExpandedGameSettings")
local standard_raw = S("EGS_Standard")
local xp_raw = S("EGS_XP")
local time_raw = S("EGS_Time")

ExpandedGameSettings_Values = {
    Standard = parse_array(standard_raw, {1.0}),
    XP = parse_array(xp_raw, {1.0}),
    Time = parse_array(time_raw, {10.0}),
}

ExpandedGameSettings_Config = {
    { Name = "playerHealth", Values = ExpandedGameSettings_Values.Standard, Enabled = true },
    { Name = "playerMana", Values = ExpandedGameSettings_Values.Standard, Enabled = true },
    { Name = "playerStamina", Values = ExpandedGameSettings_Values.Standard, Enabled = true },
    { Name = "bodyHeat", Values = ExpandedGameSettings_Values.Standard, Enabled = true },
    { Name = "foodDuration", Values = ExpandedGameSettings_Values.Standard, Enabled = true },
    { Name = "starvingTime", Values = ExpandedGameSettings_Values.Time, Enabled = true },
    { Name = "playerDivingTime", Values = ExpandedGameSettings_Values.Standard, Enabled = true },
    { Name = "shroudTime", Values = ExpandedGameSettings_Values.Standard, Enabled = true },
    { Name = "miningDamage", Values = ExpandedGameSettings_Values.Standard, Enabled = true },
    { Name = "plantGrowTime", Values = ExpandedGameSettings_Values.Standard, Enabled = true },
    { Name = "dropAmount", Values = ExpandedGameSettings_Values.Standard, Enabled = true },
    { Name = "productionTime", Values = ExpandedGameSettings_Values.Standard, Enabled = true },
    { Name = "weaponUpgradeCost", Values = ExpandedGameSettings_Values.Standard, Enabled = true },
    { Name = "durability", Values = ExpandedGameSettings_Values.Standard, Enabled = true },
    { Name = "enemyDamage", Values = ExpandedGameSettings_Values.Standard, Enabled = true },
    { Name = "enemyHealth", Values = ExpandedGameSettings_Values.Standard, Enabled = true },
    { Name = "enemyStamina", Values = ExpandedGameSettings_Values.Standard, Enabled = true },
    { Name = "enemyPerceptionRange", Values = ExpandedGameSettings_Values.Standard, Enabled = true },
    { Name = "enemyAttackFrequency", Values = ExpandedGameSettings_Values.Standard, Enabled = true },
    { Name = "bossDamage", Values = ExpandedGameSettings_Values.Standard, Enabled = true },
    { Name = "bossHealth", Values = ExpandedGameSettings_Values.Standard, Enabled = true },
    { Name = "dayTime", Values = ExpandedGameSettings_Values.Time, Enabled = true },
    { Name = "nightTime", Values = ExpandedGameSettings_Values.Time, Enabled = true },
    { Name = "combatXp", Values = ExpandedGameSettings_Values.XP, Enabled = true },
    { Name = "miningXp", Values = ExpandedGameSettings_Values.XP, Enabled = true },
    { Name = "questXp", Values = ExpandedGameSettings_Values.XP, Enabled = true },
    { Name = "perkUpgradeRecyclingFactor", Values = ExpandedGameSettings_Values.Standard, Enabled = true },
}

--                           UTILITIES & LOGGING
-- ============================================================================
-- ============================================================================

-- [!] IMPORTANT: EML Userdata arrays rely on strict C++ metamethods. 
-- Do not alter pairs() vs ipairs() iteration usage below without extensive testing.

-- Localize standard library for fast loop execution
local pcall = pcall
local ipairs = ipairs
local pairs = pairs
local type = type
local tostring = tostring
local tonumber = tonumber
local m_floor = math.floor
local m_min = math.min
local m_max = math.max
local m_abs = math.abs
local s_lower = string.lower
local s_find = string.find
local s_format = string.format
local t_concat = table.concat
local t_insert = table.insert

local safe_LOG_LEVEL = (Enable_DebugLog == false) and 0 or (type(LOG_LEVEL) == "number" and LOG_LEVEL or 1)

-- Logging disabled
local function _out(msg) if shroudforge and shroudforge.log then shroudforge.log.info(msg) end end

-- ========================================
-- RESOURCE CACHING ENGINE
-- ========================================

local _RESOURCE_CACHE = {}
local function get_cached_resources_by_type(typeName)
    if not _RESOURCE_CACHE[typeName] then
        _RESOURCE_CACHE[typeName] = game.assets.get_resources_by_type(typeName)
    end
    return _RESOURCE_CACHE[typeName]
end

local _SINGLE_RESOURCE_CACHE = {}
local function get_cached_resource(guid, typeName, instance)
    local key = tostring(guid) .. "_" .. tostring(typeName) .. "_" .. tostring(instance)
    if not _SINGLE_RESOURCE_CACHE[key] then
        _SINGLE_RESOURCE_CACHE[key] = game.assets.get_resource(guid, typeName, instance)
    end
    return _SINGLE_RESOURCE_CACHE[key]
end

-- ========================================
-- SCOPED UTILITIES
-- ========================================

local function try(fn)
    local ok, res = pcall(fn)
    if ok then return true, res end
    return false, res
end

local function get_first_resource_by_type(typeName)
    local list = get_cached_resources_by_type(typeName)
    if list and #list > 0 then return list[1] end
    return nil
end

local function find_component_by_type(components, typeName)
    if not components then return nil end
    for _, c in ipairs(components) do
        if c and c.type == typeName then
            return c
        end
    end
    return nil
end

local function _emit(lines)
    if not lines or #lines == 0 then return end
    for i = 1, #lines do
        _out("[UnifiedEML] " .. tostring(lines[i]))
    end
end

local _feature = nil

local function feature_begin(title, level)
    level = level or 1
    if safe_LOG_LEVEL < level then
        _feature = { muted = true, level = level }
        return
    end
    _feature = {
        muted = false,
        level = level,
        title = tostring(title),
        lines = {}
    }
end

local function feature_end(didWork)
    local f = _feature
    _feature = nil
    if not f or f.muted then return end

    local status = didWork and "OK" or "SKIP/FAIL"
    _emit({ "▾▾▾ " .. f.title .. " [" .. status .. "] ▾▾▾" })
    if didWork and f.lines and #f.lines > 0 then
        _emit(f.lines)
    end
    _emit({ "▴▴▴ " .. f.title .. " ▴▴▴" })
end

local function log_line(msg, level)
    level = level or 1
    if safe_LOG_LEVEL < level then return end

    if _feature and not _feature.muted then
        t_insert(_feature.lines, tostring(msg))
        return
    end
    _emit({ tostring(msg) })
end

local function log_block(lines, level)
    level = level or 1
    if safe_LOG_LEVEL < level then return end
    if not lines or #lines == 0 then return end

    if _feature and not _feature.muted then
        for i = 1, #lines do
            t_insert(_feature.lines, tostring(lines[i]))
        end
        return
    end
    _emit(lines)
end

local function log_kv(prefix, t, level)
    level = level or 1
    if safe_LOG_LEVEL < level then return end

    local parts = {}
    for k, v in pairs(t) do
        t_insert(parts, s_format("%s=%s", tostring(k), tostring(v)))
    end
    log_line(prefix .. " " .. t_concat(parts, " "), level)
end


-- ============================================================================
-- ============================================================================
--                                 FEATURES
-- ============================================================================
-- ============================================================================

local function ApplyNoIntroVideo()
    feature_begin("No Intro Video", 1)

    if not Enable_NoIntroVideo then
        feature_end(false)
        return
    end

    -- Direct access like the working example
    local uiList = game.assets.get_resources_by_type("keen::FbUiBundle")
    local ui = uiList and uiList[1] and uiList[1].data
    local didWork = false

    if ui and ui.preGame and ui.preGame.startUpSequence then
        ui.preGame.startUpSequence.logoFadeDuration.value = 0
        ui.preGame.startUpSequence.logoIdleDuration.value = 0
        ui.preGame.startUpSequence.postLogoDelay.value = 0
        ui.preGame.startUpSequence.mainMenuFadeInDuration.value = 0
        ui.preGame.startGameFadeOutDuration.value = 0
        didWork = true
        log_line("patched startup sequence timings", 1)
    else
        log_line("WARN: keen::FbUiBundle not present; skipping (ignore for servers).", 1)
    end

    feature_end(didWork)
end


local function ApplyPlayerAttributes()
    feature_begin("Player Attributes", 1)

    if not Enable_AttributeScaling then
        feature_end(false)
        return
    end

    local btRes = get_first_resource_by_type("keen::BalancingTable")
    local bt = btRes and btRes.data
    if not bt then
        feature_end(false)
        return
    end

    local changed = false
    pcall(function()
        if type(AttributeScaling_HealthPerCon) == "number" then bt.playerHealthPerAP = AttributeScaling_HealthPerCon; changed = true; end
        if type(AttributeScaling_ManaPerSpi) == "number" then bt.playerManaPerAP = AttributeScaling_ManaPerSpi; changed = true; end
        if type(AttributeScaling_StaminaPerEnd) == "number" then bt.playerStaminaPerAP = AttributeScaling_StaminaPerEnd; changed = true; end
        if type(AttributeScaling_DamagePerAttr) == "number" then bt.damageScalePerAttributePoint = AttributeScaling_DamagePerAttr; changed = true; end
    end)
    
    feature_end(changed)
end

local function ApplyPlayerBaseStats()
    feature_begin("Player Base Stats", 1)
    
    if not Enable_PlayerBaseStats then
        feature_end(false)
        return
    end
    
    local btRes = get_first_resource_by_type("keen::BalancingTable")
    local bt = btRes and btRes.data
    if not bt then
        feature_end(false)
        return
    end
    
    local changed = false
    pcall(function()
        if type(PlayerBase_Health) == "number" then bt.playerBaseHealth = PlayerBase_Health; changed = true; end
        if type(PlayerBase_Mana) == "number" then bt.playerBaseMana = PlayerBase_Mana; changed = true; end
        if type(PlayerBase_Stamina) == "number" then bt.playerBaseStamina = PlayerBase_Stamina; changed = true; end
        if type(PlayerBase_Oxygen) == "number" then bt.playerBaseOxygen = PlayerBase_Oxygen; changed = true; end
        if type(PlayerBase_FogResistance) == "number" then bt.playerBaseFogResistance = PlayerBase_FogResistance; changed = true; end
        if type(PlayerFog_PerFlameLevel) == "number" then bt.playerFogResistancePerFlameLevel = PlayerFog_PerFlameLevel; changed = true; end
    end)
    
    if changed then
        log_line(("PlayerBaseStats: Health=%s Mana=%s Stamina=%s Oxygen=%s FogRes=%s"):format(
            tostring(PlayerBase_Health), tostring(PlayerBase_Mana), tostring(PlayerBase_Stamina),
            tostring(PlayerBase_Oxygen), tostring(PlayerBase_FogResistance)
        ), 1)
    end
    
    feature_end(changed)
end

local function ApplyPlayerItemLevelTweaks()
    feature_begin("Player / Item Level Tweaks", 1)

    if not Enable_PlayerItemLevelTweaks then
        feature_end(false)
        return
    end

    local plevelMax = type(PlayerLevelMax) == "number" and PlayerLevelMax or nil
    local plevelCap = type(PlayerLevelCap) == "number" and PlayerLevelCap or nil
    local ilevelCap = type(ItemLevelCap) == "number" and ItemLevelCap or nil
    local skillPointsPL = type(SkillPointsPerLevel) == "number" and SkillPointsPerLevel or nil

    local maxClamp = type(PlayerItemLevel_MaxClamp) == "number" and PlayerItemLevel_MaxClamp or nil
    if maxClamp and maxClamp >= 1 then
        if plevelMax and plevelMax > maxClamp then 
            log_line(("WARN: PlayerLevelMax (%s) > clamp (%s); clamping"):format(tostring(plevelMax), tostring(maxClamp)), 1)
            plevelMax = maxClamp 
        end
        if plevelCap and plevelCap > maxClamp then 
            log_line(("WARN: PlayerLevelCap (%s) > clamp (%s); clamping"):format(tostring(plevelCap), tostring(maxClamp)), 1)
            plevelCap = maxClamp 
        end
        if ilevelCap and ilevelCap > maxClamp then 
            log_line(("WARN: ItemLevelCap (%s) > clamp (%s); clamping"):format(tostring(ilevelCap), tostring(maxClamp)), 1)
            ilevelCap = maxClamp 
        end
    end

    local skillClamp = type(SkillPoints_MaxClamp) == "number" and SkillPoints_MaxClamp or nil
    if skillClamp and skillClamp >= 1 then
        if skillPointsPL and skillPointsPL > skillClamp then 
            log_line(("WARN: SkillPoints (%s) > clamp (%s); clamping"):format(tostring(skillPointsPL), tostring(skillClamp)), 1)
            skillPointsPL = skillClamp 
        end
    end

    if plevelCap and plevelMax and plevelCap > plevelMax then
        log_line(("WARN: PlayerLevelCap (%s) > PlayerLevelMax (%s); clamping cap to max"):format(tostring(plevelCap), tostring(plevelMax)), 1)
        plevelCap = plevelMax
    end

    local btRes = get_first_resource_by_type("keen::BalancingTable")
    local bt = btRes and btRes.data
    if not bt then
        log_line("WARN: keen::BalancingTable not found; skipping", 1)
        feature_end(false)
        return
    end

    local patchedFields = 0

    if bt.playerLevelMax ~= nil and plevelMax ~= nil then
        bt.playerLevelMax = plevelMax; patchedFields = patchedFields + 1;
    end

    if bt.playerLevelCap ~= nil and plevelCap ~= nil then
        bt.playerLevelCap = plevelCap; patchedFields = patchedFields + 1;
    end

    if bt.itemLevelCap ~= nil and ilevelCap ~= nil then
        bt.itemLevelCap = ilevelCap; patchedFields = patchedFields + 1;
    end

    if bt.skillPointsPerLevel ~= nil and skillPointsPL ~= nil then
        bt.skillPointsPerLevel = skillPointsPL; patchedFields = patchedFields + 1;
    end

    log_line(("BalancingTable patchedFields=%d playerLevelMax=%s playerLevelCap=%s itemLevelCap=%s skillPointsPerLevel=%s"):format(
        patchedFields, tostring(plevelMax), tostring(plevelCap), tostring(ilevelCap), tostring(skillPointsPL)
    ), 1)

    local syncedItemsChanged = 0
    local didSyncRun = false

    if Enable_ItemLevelCapSync and ilevelCap ~= nil then
        didSyncRun = true
        local skipNeedle = tostring(ItemLevelSync_SafetySkip or "")
        if skipNeedle == "" then
            log_line("WARN: ItemLevelSync_SafetySkip is blank; will not skip any items", 1)
        end

        local items = get_cached_resources_by_type("keen::ItemInfo")
        
        if not items or #items == 0 then
            log_line("WARN: No ItemInfo entries found for maxLevel match", 1)
            feature_end(patchedFields > 0)
            return
        end

        local scanned = 0
        local eligible = 0
        local skipped = 0
        local shown = 0
        local SHOW_LIMIT = 25

        for _, it in ipairs(items) do
            scanned = scanned + 1

            local ok, err = pcall(function()
                local d = it and it.data
                if not d then 
                    skipped = skipped + 1
                    return 
                end

                local dbg = tostring(d.debugName or "")
                if skipNeedle ~= "" and s_find(dbg, skipNeedle, 1, true) ~= nil then 
                    skipped = skipped + 1
                    return 
                end

                local range = d.itemLevelRange
                if not range or type(range) ~= "table" or range.maxLevel == nil then 
                    skipped = skipped + 1
                    return 
                end

                eligible = eligible + 1

                local before = range.maxLevel
                if type(before) == "number" and before == ilevelCap then return end

                range.maxLevel = ilevelCap
                syncedItemsChanged = syncedItemsChanged + 1

                if safe_LOG_LEVEL >= 2 and shown < SHOW_LIMIT then
                    shown = shown + 1
                    log_line(("item[%d] debugName=%s maxLevel: %s -> %s"):format(
                        shown, dbg, tostring(before), tostring(ilevelCap)
                    ), 2)
                end
            end)

            if not ok then
                skipped = skipped + 1
                if safe_LOG_LEVEL >= 2 then
                    log_line("WARN: ItemInfo patch failed guid=" .. tostring(it and it.guid or "nil") .. " err=" .. tostring(err), 2)
                end
            end
        end

        log_line(("ItemLevelCapSync scanned=%d eligible=%d changed=%d skipped=%d (skipIfContains=%s)"):format(
            scanned, eligible, syncedItemsChanged, skipped, tostring(ItemLevelSync_SafetySkip)
        ), 1)

        if safe_LOG_LEVEL >= 2 and syncedItemsChanged > SHOW_LIMIT then
            log_line("(Display list truncated, increase SHOW_LIMIT to print all)", 2)
        end
    else
        if Enable_ItemLevelCapSync then
            log_line("ItemLevelCapSync: skipped (ItemLevelCap is nil)", 1)
        else
            log_line("ItemLevelCapSync: disabled", 1)
        end
    end

    local didWork = (patchedFields > 0) or (didSyncRun and syncedItemsChanged > 0)
    feature_end(didWork)
end

local function ApplyEquipmentMultipliers()
    feature_begin("Equipment Damage & Tools", 1)

    if not Enable_DamageTweaks and not Enable_ToolTweaks then
        feature_end(false)
        return
    end

    local items = get_cached_resources_by_type("keen::ItemInfo")
    if not items then
        feature_end(false)
        return
    end

    local changed = 0
    for _, it in ipairs(items) do
        local d = it and it.data
        if d and d.equipment and d.damageSetup and d.damageSetup.distribution then
            pcall(function()
                local dbg = s_lower(tostring(d.debugName or ""))
                local slot = s_lower(tostring(d.equipment.slot or ""))
                local dist = d.damageSetup.distribution
                
                local applied = false

                if Enable_ToolTweaks then
                    local toolMult = 1.0
                    if s_find(dbg, "axe", 1, true) and not s_find(dbg, "pickaxe", 1, true) and (slot == "tool" or slot == "buildtool") then
                        toolMult = type(ToolMult_Axe) == "number" and ToolMult_Axe or 1.0
                        if toolMult ~= 1.0 and dist.woodDamage then dist.woodDamage = dist.woodDamage * toolMult; applied = true; end
                    elseif s_find(dbg, "pickaxe", 1, true) then
                        toolMult = type(ToolMult_Pickaxe) == "number" and ToolMult_Pickaxe or 1.0
                        if toolMult ~= 1.0 then
                            if dist.stoneDamage then dist.stoneDamage = dist.stoneDamage * toolMult; applied = true; end
                            if dist.terrainDamage then dist.terrainDamage = dist.terrainDamage * toolMult; applied = true; end
                        end
                    end
                end

                if Enable_DamageTweaks then
                    local dmgMult = 1.0
                    if slot == "arrow" then dmgMult = type(DamageMult_Arrow) == "number" and DamageMult_Arrow or 1.0
                    elseif slot == "spell" then dmgMult = type(DamageMult_Spell) == "number" and DamageMult_Spell or 1.0
                    elseif slot == "meleeweapon" then
                        if s_find(dbg, "2h", 1, true) then dmgMult = type(DamageMult_Melee2H) == "number" and DamageMult_Melee2H or 1.0 
                        else dmgMult = type(DamageMult_Melee1H) == "number" and DamageMult_Melee1H or 1.0 end
                    elseif slot == "rangeweapon" then dmgMult = type(DamageMult_Range) == "number" and DamageMult_Range or 1.0
                    elseif slot == "midrangeweapon" then dmgMult = type(DamageMult_Wand) == "number" and DamageMult_Wand or 1.0
                    end

                    if dmgMult ~= 1.0 then
                        for k, v in pairs(dist) do dist[k] = v * dmgMult end
                        applied = true
                    end
                end

                if applied then changed = changed + 1 end
            end)
        end
    end

    
    -- Scale spell damage uiValues
    if Enable_DamageTweaks and DamageMult_Spell and DamageMult_Spell ~= 1.0 then
        for _, it in ipairs(items) do
            local d = it and it.data
            if d and d.uiValues and s_find(tostring(d.debugName or ""), "Spell", 1, true) then
                pcall(function()
                    for _, uv in ipairs(d.uiValues) do
                        local loca = uv.locaId and uv.locaId.value
                        if loca == 3386387946 and uv.value then
                            uv.value = uv.value * DamageMult_Spell
                            changed = changed + 1
                        end
                    end
                end)
            end
        end
    end

feature_end(changed > 0)
end

local function ApplyItemLevelMinimums()
    feature_begin("Item Level Minimums", 1)

    if not Enable_ItemLevelMinimums then
        feature_end(false)
        return
    end
    
    local items = get_cached_resources_by_type("keen::ItemInfo")
    if not items then
        feature_end(false)
        return
    end
    
    local changed = 0
    for _, it in ipairs(items) do
        local d = it and it.data
        if d and d.itemLevelRange and d.equipment then
            pcall(function()
                local dbg = s_lower(tostring(d.debugName or ""))
                local slot = s_lower(tostring(d.equipment.slot or ""))
                local targetMin = nil

                if s_find(slot, "armour", 1, true) and not s_find(slot, "ring", 1, true) then
                    if Enable_ItemLevelMin_Armor then targetMin = ItemLevelMin_Armor end
                elseif s_find(slot, "shield", 1, true) then
                    if Enable_ItemLevelMin_Shield then targetMin = ItemLevelMin_Shield end
                elseif s_find(slot, "ring", 1, true) or s_find(dbg, "ring", 1, true) then
                    if Enable_ItemLevelMin_Ring then targetMin = ItemLevelMin_Ring end
                elseif (s_find(slot, "melee", 1, true) or s_find(slot, "range", 1, true) or s_find(slot, "midrange", 1, true)) and not s_find(slot, "tool", 1, true) then
                    if not (s_find(dbg, "consumable", 1, true) or s_find(dbg, "grenade", 1, true)) then
                        if Enable_ItemLevelMin_Weapon then targetMin = ItemLevelMin_Weapon end
                    end
                elseif s_find(slot, "tool", 1, true) then
                    if Enable_ItemLevelMin_Tool then targetMin = ItemLevelMin_Tool end
                elseif s_find(slot, "arrow", 1, true) then
                    if Enable_ItemLevelMin_Arrow then targetMin = ItemLevelMin_Arrow end
                elseif s_find(slot, "spell", 1, true) then
                    if Enable_ItemLevelMin_Spell then targetMin = ItemLevelMin_Spell end
                elseif s_find(dbg, "gem", 1, true) then
                    if Enable_ItemLevelMin_Gem then targetMin = ItemLevelMin_Gem end
                else
                    if Enable_ItemLevelMin_Misc then targetMin = ItemLevelMin_Misc end
                end

                if type(targetMin) == "number" then
                    d.itemLevelRange.minLevel = targetMin
                    if type(d.itemLevelRange.maxLevel) == "number" and d.itemLevelRange.maxLevel < targetMin then 
                        d.itemLevelRange.maxLevel = targetMin 
                    end
                    changed = changed + 1
                end
            end)
        end
    end

    feature_end(changed > 0)
end

-- Calculation Helper localized for Updraft
local UPDRAFT_GUID = "56f35356-aa4b-4cc1-b5c6-088ecce9aa45"
local TARGET_TYPE  = "keen::actor::ActorSequenceResource"

local function normalize_duration_ns(v)
  if type(v) ~= "number" then return nil end
  if v < 1000 then return m_floor(v * 1000000000 + 0.5) end
  return m_floor(v + 0.5)
end

local function patch_scalar_if(obj, field, new_val, context)
  if new_val == nil or not obj then return end
  if obj[field] ~= new_val then
    log_line(s_format("%s %s: %s -> %s", context, field, tostring(obj[field]), tostring(new_val)), 2)
    obj[field] = new_val
    return true
  end
end

local function safe_get(obj, field)
  local ok, val = pcall(function() return obj[field] end)
  if ok then return val end
  return nil
end

local function safe_set(obj, field, value)
  local ok, err = pcall(function() obj[field] = value end)
  if ok then return true end
  return false, err
end

local function iter_array(arr, fn)
  local ok, iter, state, init = pcall(function() return ipairs(arr) end)
  if not ok then return false end
  for i, v in iter, state, init do
    fn(i, v)
  end
  return true
end

local function apply_ignore_mana_cost(val, context)
  if not val then return false end
  local mask = safe_get(val, "ignoreCostMask")
  local target = "Mana"

  if mask == nil then
    if safe_set(val, "ignoreCostMask", { target }) then
        log_line(context .. " ignoreCostMask: set {Mana}", 2)
        return true
    end
    log_line(context .. " ignoreCostMask: failed to set", 1)
    return false
  end

  local found = false
  iter_array(mask, function(_, v)
      if tostring(v) == target then found = true end
  end)
  if found then 
      log_line(context .. " ignoreCostMask: already contains Mana", 2)
      return false 
  end

  local idx = 1
  iter_array(mask, function(i) idx = i + 1 end)
  local ok, err = safe_set(mask, idx, target)
  if ok then 
      log_line(context .. " ignoreCostMask: appended Mana", 2)
      return true 
  end
  
  ok, err = safe_set(val, "ignoreCostMask", { target })
  if ok then
      log_line(context .. " ignoreCostMask: replaced with {Mana}", 2)
      return true
  end

  log_line(context .. " ignoreCostMask: update failed (" .. tostring(err) .. ")", 1)
  return false
end

local function apply_mana_cost_override(val, new_value, context)
  if not val or type(new_value) ~= "number" then return false end
  local impacts = safe_get(val, "impactValues")
  if not impacts then return false end

  local changed = false
  iter_array(impacts, function(i, entry)
    local entry_val = safe_get(entry, "value") or safe_get(entry, "$value")
    if entry_val then
      local old = safe_get(entry_val, "value")
      if type(old) == "number" and old ~= new_value then
        local ok = safe_set(entry_val, "value", new_value)
        if ok then 
            log_line(s_format("%s impactValues[%d].value: %s -> %s", context, i, tostring(old), tostring(new_value)), 2)
            changed = true 
        end
      end
    end
  end)
  return changed
end

local function ApplyUpdraftTweaks()
  feature_begin("Updraft Tweaks", 1)

  if not Enable_SkillTweaks_Updraft then
    feature_end(false)
    return
  end

  local list = get_cached_resources_by_type(TARGET_TYPE)
  if not list or #list == 0 then
    log_line("WARN: No resources found for type: " .. TARGET_TYPE, 1)
    feature_end(false)
    return
  end

  for _, res in ipairs(list) do
    if tostring(res.guid) == UPDRAFT_GUID then
        local data = res.data
        if not data or not data.subSequences then 
            log_line("WARN: Invalid sequence structure (no subSequences)", 1)
            return 
        end

        local changed = 0
        for si, seq in ipairs(data.subSequences) do
          for ei, event in ipairs(seq.events or {}) do
            local context = s_format("Seq[%d].Event[%d](%s)", si, ei, tostring(event.type))
            local val = event.value
            if val then
              if event.type == "keen::actor::ImpulseEvent" then
                if val.uprightImpulse then
                  if type(GroundRelative_X) == "number" and patch_scalar_if(val.uprightImpulse, "x", GroundRelative_X, context .. ".uprightImpulse.x") then changed = changed + 1 end
                  if type(GroundRelative_Y) == "number" and patch_scalar_if(val.uprightImpulse, "y", GroundRelative_Y, context .. ".uprightImpulse.y") then changed = changed + 1 end
                  if type(GroundRelative_Z) == "number" and patch_scalar_if(val.uprightImpulse, "z", GroundRelative_Z, context .. ".uprightImpulse.z") then changed = changed + 1 end
                end

                if val.orientedImpulse then
                  if type(PlayerRelative_X) == "number" and patch_scalar_if(val.orientedImpulse, "x", PlayerRelative_X, context .. ".orientedImpulse.x") then changed = changed + 1 end
                  if type(PlayerRelative_Y) == "number" and patch_scalar_if(val.orientedImpulse, "y", PlayerRelative_Y, context .. ".orientedImpulse.y") then changed = changed + 1 end
                  if type(PlayerRelative_Z) == "number" and patch_scalar_if(val.orientedImpulse, "z", PlayerRelative_Z, context .. ".orientedImpulse.z") then changed = changed + 1 end
                end

                if val.duration and type(Boost_Duration) == "number" then
                  if patch_scalar_if(val.duration, "value", normalize_duration_ns(Boost_Duration), context .. ".duration.value") then changed = changed + 1 end
                end
              elseif event.type == "keen::actor::PayUsageCost" then
                if Updraft_IgnoreManaCost then
                  if apply_ignore_mana_cost(val, context .. ".ignoreCostMask") then changed = changed + 1 end
                end
                if type(Updraft_ManaCost_Value) == "number" then
                  if apply_mana_cost_override(val, Updraft_ManaCost_Value, context) then changed = changed + 1 end
                end
              end
            end
          end
        end
        
      if changed > 0 then
        log_line("Updraft changes applied: " .. tostring(changed), 1)
      end
      feature_end(changed > 0)
      return
    end
  end
  log_line("WARN: Updraft ActorSequence GUID not found: " .. UPDRAFT_GUID, 1)
  feature_end(false)
end

local function SlopeTweaks()
    feature_begin("Slope Tweaks", 1)

    if not Enable_SlopeTweaks then
        feature_end(false)
        return
    end

    local playerRes = get_cached_resource("c3db66d6-89a5-4a6c-a8e3-d9a1f6009812", "keen::ecs::TemplateResource", 0)
    if not playerRes or not playerRes.data then
        log_line("ERROR: player TemplateResource not found", 1)
        feature_end(false)
        return
    end

    local player = playerRes.data
    local patched = 0

    local maxAng = type(Max_Angle) == "number" and Max_Angle or 89.0
    local st = type(steepFloorAngle) == "number" and steepFloorAngle or nil
    local sl = type(slidingAngle) == "number" and slidingAngle or nil
    local fd = type(fallDamageAngle) == "number" and fallDamageAngle or nil

    if not st and not sl and not fd then
        log_line("Notice: All Slope angles are nil/invalid. Skipping.", 1)
        feature_end(false)
        return
    end

    for _, component in ipairs(player.components or {}) do
        if component.type == "keen::ecs::SlopeConfig" then
            local slope_config = component.value
            
            local before = {
                steep   = slope_config.slopeDefinition.steepFloorAngle,
                sliding = slope_config.slopeDefinition.slidingAngle,
                fall    = slope_config.slopeDefinition.fallDamageAngle,
            }

            if st then slope_config.slopeDefinition.steepFloorAngle = m_min(st, maxAng) end
            if sl then slope_config.slopeDefinition.slidingAngle    = m_min(sl, maxAng) end
            if fd then slope_config.slopeDefinition.fallDamageAngle = m_min(fd, maxAng) end
            
            patched = patched + 1

            if safe_LOG_LEVEL >= 2 then
                log_line(s_format("  component[%d]", patched), 2)
                if st then log_line(s_format("    steepFloorAngle: %.1f -> %.1f", before.steep, slope_config.slopeDefinition.steepFloorAngle), 2) end
                if sl then log_line(s_format("    slidingAngle:    %.1f -> %.1f", before.sliding, slope_config.slopeDefinition.slidingAngle), 2) end
                if fd then log_line(s_format("    fallDamageAngle: %.1f -> %.1f", before.fall, slope_config.slopeDefinition.fallDamageAngle), 2) end
            end
        end
    end

    feature_end(patched > 0)
end

local function ApplySpellTweaks()
    feature_begin("Spell Tweaks", 1)

    if not Enable_SpellTweaks then
        feature_end(false)
        return
    end

    local castMult = SpellCastTime_Multiplier
    local manaMult = SpellManaCost_Multiplier

    local validCast = (type(castMult) == "number" and castMult >= 0)
    local validMana = (type(manaMult) == "number" and manaMult >= 0)

    if not validCast and not validMana then
        log_line("WARN: Both Spell Multipliers are nil/invalid; skipping", 1)
        feature_end(false)
        return
    end

    if not validCast then log_line("Notice: SpellCastTime_Multiplier invalid/nil; skipping cast time reduction", 1) end
    if not validMana then log_line("Notice: SpellManaCost_Multiplier invalid/nil; skipping mana cost reduction", 1) end

    local minMult = SpellTweaks_MinMultiplier
    if type(minMult) == "number" then
        if validCast and castMult < minMult then
            log_line(("WARN: SpellCastTime_Multiplier (%s) < min (%s); clamping"):format(tostring(castMult), tostring(minMult)), 1)
            castMult = minMult
        end
        if validMana and manaMult < minMult then
            log_line(("WARN: SpellManaCost_Multiplier (%s) < min (%s); clamping"):format(tostring(manaMult), tostring(minMult)), 1)
            manaMult = minMult
        end
    end

    local items = get_cached_resources_by_type("keen::ItemInfo")
    if not items or #items == 0 then
        log_line("WARN: No ItemInfo entries found", 1)
        feature_end(false)
        return
    end

    local scanned = 0
    local matched = 0
    local skipped = 0
    local failed = 0
    local impactEntriesTouched = 0
    local uiEntriesTouched = 0

    local function floor_nonneg(n)
        if type(n) ~= "number" then return nil end
        local f = m_floor(n)
        if f < 0 then f = 0 end
        return f
    end

    for _, it in ipairs(items) do
        scanned = scanned + 1

        local ok, err = pcall(function()
            local d = it and it.data
            if not d then
                skipped = skipped + 1
                return
            end

            local dbg = tostring(d.debugName or "")
            if dbg == "" then
                skipped = skipped + 1
                return
            end

            local isAmmo = s_find(dbg, "Ammo", 1, true)
            local isSpell = s_find(dbg, "Spell", 1, true)

            if not isAmmo and not isSpell then
                return
            end

            matched = matched + 1

            -- Apply cast time multiplier to impact values
            local impacts = d.impactValues
            if impacts and validCast and castMult ~= 1.0 then
                for _, key in ipairs({"simple", "scaled"}) do
                    local ok2, arr = pcall(function() return impacts[key] end)
                    if ok2 and arr then
                        for i = 1, 20 do
                            local ok3, entry = pcall(function() return arr[i] end)
                            if not ok3 or not entry then break end
                            local ok4, v = pcall(function() return entry.value end)
                            if ok4 and v then
                                local ok5, valRaw = pcall(function() return v.value end)
                                if ok5 and type(valRaw) == "number" then
                                    v.value = floor_nonneg(valRaw * castMult)
                                    impactEntriesTouched = impactEntriesTouched + 1
                                end
                            end
                        end
                    end
                end
            end

            -- Apply mana cost multiplier to UI values
            local uiVals = d.uiValues
            if uiVals and validMana and manaMult ~= 1.0 then
                for i = 1, 20 do
                    local ok2, entry = pcall(function() return uiVals[i] end)
                    if not ok2 or not entry then break end
                    local ok3, v = pcall(function() return entry.value end)
                    if ok3 and v then
                        local ok4, valRaw = pcall(function() return v.value end)
                        if ok4 and type(valRaw) == "number" then
                            v.value = floor_nonneg(valRaw * manaMult)
                            uiEntriesTouched = uiEntriesTouched + 1
                        end
                    end
                end
            end
        end)

        if not ok then
            failed = failed + 1
        end
    end

    log_line(("ItemInfo scanned=%d matched(Ammo+Spell)=%d skipped=%d failed=%d"):format(
        scanned, matched, skipped, failed
    ), 1)
    log_line(("Touched entries: impactValues=%d uiValues=%d castMult=%s manaMult=%s"):format(
        impactEntriesTouched, uiEntriesTouched, tostring(castMult), tostring(manaMult)
    ), 1)

    feature_end((impactEntriesTouched + uiEntriesTouched) > 0)
end


-- Localization ID mappings for gear stats
local GEAR_LOCA = {
    [3144141133] = "HealthRegen",
    [2429421730] = "HealthRegen",
    [1748353866] = "ManaRegen",
    [3794775993] = "ManaRegen",
    [1661244498] = "StaminaRegen",
    [4245854444] = "StaminaRegen",
    [2298204525] = "Armor",
    [4085987468] = "HealthBonus",
    [1640932545] = "StaminaBonus",
    [3659778886] = "ManaBonus",
}

local function ApplyGearStatTweaks()
    feature_begin("Gear Stat Tweaks", 1)

    local ok, err = pcall(function()
        if not Enable_GearStatTweaks then
            return
        end

        local mults = {
            HealthRegen  = type(RegenMult_Health) == "number" and RegenMult_Health or 1.0,
            ManaRegen    = type(RegenMult_Mana) == "number" and RegenMult_Mana or 1.0,
            StaminaRegen = type(RegenMult_Stamina) == "number" and RegenMult_Stamina or 1.0,
            HealthBonus  = type(GearMult_HealthBonus) == "number" and GearMult_HealthBonus or 1.0,
            StaminaBonus = type(GearMult_StaminaBonus) == "number" and GearMult_StaminaBonus or 1.0,
            ManaBonus    = type(GearMult_ManaBonus) == "number" and GearMult_ManaBonus or 1.0,
        }

        local anyActive = false
        for _, m in pairs(mults) do
            if m ~= 1.0 then anyActive = true break end
        end
        if not anyActive then
            log_line("Gear Stat Tweaks: all multipliers are 1.0; skipping.", 1)
            return
        end

        local function classify_stat(str)
            if not str or str == "" then return nil end
            local s = s_lower(tostring(str))
            if s_find(s, "stamina", 1, true) then
                if s_find(s, "regen", 1, true) or s_find(s, "recovery", 1, true) or s_find(s, "ring_of_stamina", 1, true) then
                    return "StaminaRegen"
                elseif s_find(s, "bonus", 1, true) or s_find(s, "max", 1, true) then
                    return "StaminaBonus"
                end
            end
            if s_find(s, "mana", 1, true) then
                if s_find(s, "regen", 1, true) or s_find(s, "recovery", 1, true) or s_find(s, "ring_of_mana", 1, true) then
                    return "ManaRegen"
                elseif s_find(s, "bonus", 1, true) or s_find(s, "max", 1, true) then
                    return "ManaBonus"
                end
            end
            if s_find(s, "health", 1, true) or s_find(s, "hp", 1, true) then
                if s_find(s, "regen", 1, true) or s_find(s, "recovery", 1, true) or s_find(s, "ring_of_health", 1, true) then
                    return "HealthRegen"
                elseif s_find(s, "bonus", 1, true) or s_find(s, "max", 1, true) then
                    return "HealthBonus"
                end
            end
            if s_find(s, "armor", 1, true) or s_find(s, "armour", 1, true) then
                return "Armor"
            end
            return nil
        end

        local function scale_impact_by_index(impacts, statByIndex)
            if not impacts or not statByIndex then return 0 end
            local count = 0
            for _, arrName in ipairs({"simple", "scaled"}) do
                pcall(function()
                    local arr = impacts[arrName]
                    if arr then
                        for uiIdx, stat in pairs(statByIndex) do
                            local impactIdx = uiIdx + 1
                            local entry = arr[impactIdx]
                            if entry and stat and mults[stat] and mults[stat] ~= 1.0 then
                                local vObj = entry.value
                                if vObj then
                                    pcall(function()
                                        local numVal = vObj.value
                                        if type(numVal) == "number" and numVal > 0 then
                                            vObj.value = m_floor(numVal * mults[stat] + 0.5)
                                            count = count + 1
                                        end
                                    end)
                                end
                            end
                        end
                    end
                end)
            end
            return count
        end

        local uiChanged = 0
        local impactChanged = 0
        local buffChanged = 0

        local items = get_cached_resources_by_type("keen::ItemInfo")
        if items then
            for _, it in ipairs(items) do
                pcall(function()
                    local d = it and it.data
                    if not d then return end
                    local dbg = tostring(d.debugName or "")
                    local isGear = s_find(dbg, "Ring", 1, true) or s_find(dbg, "Armor", 1, true) or s_find(dbg, "Armour", 1, true)
                    if not isGear then return end

                    local fallbackStat = classify_stat(dbg)
                    local statByIndex = {}

                    if d.uiValues then
                        pcall(function()
                            local idx = 0
                            for _, uv in pairs(d.uiValues) do
                                idx = idx + 1
                                if uv and type(uv.value) == "number" and uv.value > 0 then
                                    local loca = uv.locaId and uv.locaId.value
                                    local st = loca and GEAR_LOCA[loca]
                                    if st then
                                        statByIndex[idx] = st
                                        if mults[st] and mults[st] ~= 1.0 then
                                            uv.value = m_floor(uv.value * mults[st] + 0.5)
                                            uiChanged = uiChanged + 1
                                        end
                                    end
                                end
                            end

                        end)
                    end

                    impactChanged = impactChanged + scale_impact_by_index(d.impactValues, statByIndex)
                end)
            end
        end

        local buffs = get_cached_resources_by_type("keen::BuffType")
        if buffs then
            for _, b in ipairs(buffs) do
                pcall(function()
                    local bd = b and b.data
                    if not bd then return end
                    local bName = tostring(bd.debugName or bd.name or "")
                    local buffStat = classify_stat(bName)
                    local isEquipmentBuff = buffStat or s_find(bName, "Ring", 1, true) or s_find(bName, "Armor", 1, true) or s_find(bName, "Regen", 1, true)
                    if isEquipmentBuff then
                        buffChanged = buffChanged + scale_impact_arrays(bd.impactValues, buffStat)
                    end
                end)
            end
        end

        log_line(s_format("Gear Stat Tweaks applied: ui=%d impacts=%d buffs=%d", uiChanged, impactChanged, buffChanged), 1)
    end)

    if not ok then
        log_line("ERROR in ApplyGearStatTweaks: " .. tostring(err), 1)
    end
    feature_end(ok)
end

local function ApplyInventoryTweaks()
    feature_begin("Inventory & Chest Sizes", 1)

    if not Enable_BackpackTweaks and not Enable_ChestSizeTweaks then
        feature_end(false)
        return
    end

    local validBp = type(Backpack_MaxSlots) == "number" and Backpack_MaxSlots > 0
    local validChest = type(Chest_MaxSlots) == "number" and Chest_MaxSlots > 0

    if not validBp and not validChest then
        log_line("Notice: Both MaxSlots configs are nil/invalid. Skipping.", 1)
        feature_end(false)
        return
    end

    local templates = get_cached_resources_by_type("keen::ecs::TemplateResource")
    if not templates then
        feature_end(false)
        return
    end

    local changed = 0
    for _, t in ipairs(templates) do
        pcall(function()
            local d = t.data
            local name = tostring(d.name or "")
            local comps = d.components or {}

            if Enable_BackpackTweaks and validBp and s_find(name, "Backpack", 1, true) then
                for _, c in pairs(comps) do
                    if c.type == "keen::ecs::InventorySetup" then
                        c.value.genericSlotCount = Backpack_MaxSlots
                        c.value.availableSlotCount = Backpack_MaxSlots
                        changed = changed + 1
                    end
                end
            end

            if Enable_ChestSizeTweaks and validChest and (s_find(name, "Prop_Decoration_T", 1, true) or s_find(name, "Factory", 1, true) or s_find(name, "Production", 1, true)) and not s_find(name, "Base", 1, true) then
                for _, c in pairs(comps) do
                    if c.type == "keen::ecs::InventorySetup" then
                        if type(c.value.genericSlotCount) == "number" then
                            c.value.genericSlotCount = m_min(c.value.genericSlotCount * 2, Chest_MaxSlots)
                        end
                        if type(c.value.availableSlotCount) == "number" then
                            c.value.availableSlotCount = m_min(c.value.availableSlotCount * 2, Chest_MaxSlots)
                        end
                        changed = changed + 1
                    end
                end
            end
        end)
    end
    
    if Enable_BackpackTweaks and validBp then
         local items = get_cached_resources_by_type("keen::ItemInfo")
         if items then
             for _, it in ipairs(items) do
                 pcall(function()
                     local d = it.data
                     local dbg = tostring(d.debugName or "")
                     if s_find(dbg, "Backpack", 1, true) and d.uiValues then
                         for _, v in pairs(d.uiValues) do
                             if v.value ~= nil then
                                 if type(v.value) == "number" then
                                     v.value = Backpack_MaxSlots
                                 elseif type(v.value) == "table" and v.value.value ~= nil then
                                     v.value.value = Backpack_MaxSlots
                                 end
                                 changed = changed + 1
                             end
                         end
                     end
                 end)
             end
         end
    end

    feature_end(changed > 0)
end

local function ApplyStackSizeTweaks()
    feature_begin("Stack Size Tweaks", 1)

    if not Enable_StackSizeTweaks then
        feature_end(false)
        return
    end

    local maxStack = type(StackSize_MaxStack) == "number" and StackSize_MaxStack or nil
    if maxStack and maxStack > 65535 then
        log_line("WARN: StackSize_MaxStack " .. tostring(maxStack) .. " exceeds 65535. Clamping to 65535.", 1)
        maxStack = 65535
    end

    if not maxStack or maxStack < 1 then
        log_line("Notice: StackSize_MaxStack is nil/invalid. Skipping.", 1)
        feature_end(false)
        return
    end

    local items = get_cached_resources_by_type("keen::ItemInfo")
    if not items or #items == 0 then
        feature_end(false)
        return
    end

    local changed = 0
    for _, it in ipairs(items) do
        local d = it and it.data
        local cur = d and d.maxStackSize
        if type(cur) == "number" and cur > 1 and cur ~= maxStack then
            local ok = pcall(function() d.maxStackSize = maxStack end)
            if ok then changed = changed + 1 end
        end
    end

    if changed > 0 then
        log_line((" Max Stack Size ➡ %s"):format(tostring(maxStack)), 1)
    end

    feature_end(changed > 0)
end

local function ApplyTerraformingTweaks()
    feature_begin("Terraforming Tweaks", 1)

    if not Enable_TerraformingTweaks then
        log_line("Terraforming: disabled by toggle", 1)
        feature_end(false)
        return
    end

    -- Use terrainConfigs array like the working Terraforming_Tweaks.lua
    local reg = get_first_resource_by_type("keen::TerraformingEfficiencyRegistryResource")
    local data = reg and reg.data
    local cfgs = data and data.terrainConfigs
    if not cfgs then
        log_line("WARN: TerraformingEfficiencyRegistryResource.terrainConfigs not found", 1)
        feature_end(false)
        return
    end

    local changed = 0
    local scanned = 0
    for _, c in ipairs(cfgs) do
        scanned = scanned + 1
        if c.hardness == "Unbreakable" then
            c.hardness = "Hard"
            changed = changed + 1
        end
    end

    log_line("  Scanned=" .. tostring(scanned) .. " Unbreakable->Hard=" .. tostring(changed), 1)
    feature_end(changed > 0)
end

local function ApplyTerrainDropTweaks()
    feature_begin("Terrain Loot Tweaks", 1)

    if not Enable_TerrainDropTweaks then
        feature_end(false)
        return
    end

    local reg = get_first_resource_by_type("keen::TerraformingEfficiencyRegistryResource")
    local data = reg and reg.data
    if not data then
        log_line("WARN: TerraformingEfficiencyRegistryResource not found", 1)
        feature_end(false)
        return
    end

    local rate = TerrainDrop_ExchangeRate
    if type(rate) ~= "number" or rate < 0 then
        log_line("WARN: TerrainDrop_ExchangeRate invalid, skipping: " .. tostring(rate), 1)
        feature_end(false)
        return
    end
    if rate > 1.0 then rate = 1.0 end

    local changedRate = 0
    pcall(function()
        for _, v in pairs(data) do
            if type(v) == "table" or type(v) == "userdata" then
                for _, e in pairs(v) do
                    if type(e) == "table" or type(e) == "userdata" then
                        if e.terrainPerLootItemExchangeRate ~= nil and e.terrainPerLootItemExchangeRate ~= rate then
                            e.terrainPerLootItemExchangeRate = rate
                            changedRate = changedRate + 1
                        end
                    end
                end
            end
        end
    end)
    
    if changedRate > 0 then
        log_line(("Patched terrainPerLootItemExchangeRate on %d entries (rate=%s)"):format(changedRate, tostring(rate)), 1)
    else
        log_line(("TerrainDrop rate already set (rate=%s)"):format(tostring(rate)), 1)
    end
    
    feature_end(true)
end

local function ApplyExtendedMagicStorage()
    feature_begin("Extended Magic Storage", 1)

    if not Enable_MagicFurniture and not Enable_MagicFactories then
        feature_end(false)
        return
    end

    local templates = get_cached_resources_by_type("keen::ecs::TemplateResource")
    if not templates or #templates == 0 then
        log_line("WARN: No TemplateResource entries found", 1)
        feature_end(false)
        return
    end

    log_line("  TemplateResource count: " .. tostring(#templates), 1)

    local magicTemplate = nil
    for _, t in ipairs(templates) do
        local name = t and t.data and t.data.name
        if name and s_find(name, "Prop_Decoration_T1_Storage_24_Magic", 1, true) then
            magicTemplate = t.data
            break
        end
    end

    if not magicTemplate then
        log_line("WARN: Magic storage template not found (Prop_Decoration_T1_Storage_24_Magic)", 1)
        feature_end(false)
        return
    end

    log_line("  Magic template found: " .. tostring(magicTemplate.name or "nil"), 1)

local magicComponent = find_component_by_type(magicTemplate.components, "keen::ecs::InventoryCraftingStock") or
                           find_component_by_type(magicTemplate.components, "keen::ecs::MagicChest") or
                           find_component_by_type(magicTemplate.components, "keen::ecs::MagicInventory") or
                           (magicTemplate.components and magicTemplate.components[4])

    if not magicComponent then
        log_line("WARN: Could not locate magic chest component to copy", 1)
        feature_end(false)
        return
    end

    log_line("  Magic component type: " .. tostring(magicComponent.type or "nil"), 1)

    local modified = 0
    local shown = 0
    local SHOW_LIMIT = 30
    for _, t in ipairs(templates) do
        local td = t and t.data
        local name = td and td.name

        if name then
            local isTarget = false
            if Enable_MagicFurniture and s_find(name, "Furniture", 1, true) and not s_find(name, "Loot", 1, true) then
                isTarget = true

            elseif Enable_MagicFactories and s_find(name, "Factory", 1, true) then
                isTarget = true

            end

            if isTarget then
                pcall(function()
                    td.components = td.components or {}
                    local already = find_component_by_type(td.components, magicComponent.type) ~= nil
                    if not already then
                        t_insert(td.components, magicComponent)
                        modified = modified + 1

                        if shown < SHOW_LIMIT then
                            shown = shown + 1
                            log_line("  patched: " .. tostring(name), 1)
                        end
                    end
                end)
            end
        end
    end

    if safe_LOG_LEVEL >= 2 and modified > SHOW_LIMIT then
        log_line("  (Display list truncated, increase SHOW_LIMIT to print all)", 2)
    end

    feature_end(modified > 0)
end

local function ApplyGliderTuning()
    feature_begin("Glider Stats", 1)

    if not Enable_GliderTuning then
        feature_end(false)
        return
    end

    local GLIDER_GUIDS = {
        ["33834394-99c5-47b2-93b2-36aa6a2eaa73"] = "T1",
        ["1da8d177-3a28-43b1-b430-44b38022d925"] = "T2",
        ["f5520401-f5aa-41cd-99e1-609b884cc492"] = "T3",
        ["80c9eaeb-7fa0-480d-a55f-91c2c51b383e"] = "T4_REWARD",
    }
    
    local GLIDER_NAMES = {
        ["Tool_Glider_T1"]        = "T1",
        ["Tool_Glider_T2"]        = "T2",
        ["Tool_Glider_T3"]        = "T3",
        ["Tool_Glider_T4_REWARD"] = "T4_REWARD",
    }
    
    local GLIDER_FIELDS = {
        "accelerationForward",
        "airResistanceLongitudinal",
        "airResistanceLateral",
        "airResistanceVertical",
        "yawAngleSpeed",
        "pitchAngleSpeed",
        "rollAngleSpeed",
    }

    local items = get_cached_resources_by_type("keen::ItemInfo")
    if not items then
        log_line("ERROR: get_resources_by_type('keen::ItemInfo') returned nil", 1)
        feature_end(false)
        return
    end

    local totalCount = #items
    log_line("Total ItemInfo resources: " .. tostring(totalCount), 1)

    local glidersFound = 0
    local glidersModified = 0

    local function fmt(v, decimals)
        if type(v) ~= "number" then return tostring(v) end
        decimals = decimals or 2
        return s_format("%." .. tostring(decimals) .. "f", v)
    end

    for idx = 1, totalCount do
        local res = items[idx]
        if not res then goto continue end

        local ok, err = pcall(function()
            local d = res.data
            if not d then return end

            local eq = d.equipment
            if not eq then return end
            if tostring(eq.slot) ~= "Glider" then return end

            glidersFound = glidersFound + 1
            log_line("Found glider: " .. tostring(d.debugName), 1)

            local guid = tostring(res.guid or "unknown")
            local debugName = tostring(d.debugName or "unknown")

            local tier = GLIDER_GUIDS[guid] or GLIDER_NAMES[debugName]
            if not tier then 
                log_line("WARNING: Unknown glider found - guid=" .. guid .. " debugName=" .. debugName, 2)
                return 
            end

            local tierConfig = GliderConfig[tier]
            if not tierConfig then 
                log_line("WARNING: No config for tier " .. tostring(tier), 2)
                return 
            end

            local gc = eq.gliderConfig
            if not gc then 
                log_line("WARNING: gliderConfig is nil for " .. debugName, 2)
                return 
            end

            log_line(s_format("- Glider - %s", tier), 1)

            local changedAny = false
            for _, field in ipairs(GLIDER_FIELDS) do
                local override = tierConfig[field]
                if override ~= nil then
                    local before = gc[field]
                    gc[field] = override
                    local after = gc[field]

                    local dec = (s_find(field, "AngleSpeed", 1, true) ~= nil) and 1 or 2

                    log_line(s_format(
                        "  %s: %s -> %s",
                        field,
                        fmt(before, dec),
                        fmt(after,  dec)
                    ), 1)

                    changedAny = true
                end
            end

            if changedAny then 
                glidersModified = glidersModified + 1 
            else
                log_line("Glider " .. tier .. " (" .. debugName .. ") - no overrides configured", 2)
            end
        end)

        if not ok then
            log_line("WARN: Glider patch failed for resource index=" .. tostring(idx) .. " err=" .. tostring(err), 1)
        end

        ::continue::
    end

    log_line("Gliders found=" .. tostring(glidersFound) .. " modified=" .. tostring(glidersModified), 1)
    feature_end(true)
end

local function ApplyFlameAltarTweaks()
    feature_begin("Flame Altar Tweaks", 1)

    if not Enable_FlameAltarTweaks then
        feature_end(false)
        return
    end

    local mult = type(MaxFlameAltars_Multiplier) == "number" and MaxFlameAltars_Multiplier > 0 and MaxFlameAltars_Multiplier or 1.0
    local cap = type(MaxFlameAltars_Cap) == "number" and MaxFlameAltars_Cap >= 1 and MaxFlameAltars_Cap or math.huge

    if mult == 1.0 and cap == math.huge then
        log_line("WARN: Both Flame Altar tweaks are nil/invalid; skipping", 1)
        feature_end(false)
        return
    end

    if not (type(MaxFlameAltars_Multiplier) == "number" and MaxFlameAltars_Multiplier > 0) then log_line("Notice: MaxFlameAltars_Multiplier is nil/invalid; skipping multiplier scaling", 1) end
    if not (type(MaxFlameAltars_Cap) == "number" and MaxFlameAltars_Cap >= 1) then log_line("Notice: MaxFlameAltars_Cap is nil/invalid; skipping cap limit", 1) end

    local btRes = get_first_resource_by_type("keen::BalancingTable")
    local bt = btRes and btRes.data
    if not bt then
        log_line("WARN: keen::BalancingTable not found; skipping", 1)
        feature_end(false)
        return
    end

    local altarLevels = bt.altarsPerFlameLevel
    if not altarLevels then
        log_line("WARN: BalancingTable.altarsPerFlameLevel missing; skipping", 1)
        feature_end(false)
        return
    end

    local vanillaMax = 0
    for _, v in ipairs(altarLevels) do
        if type(v) == "number" and v > vanillaMax then vanillaMax = v end
    end

    local clampMult = FlameAltar_MaxMultiplierClamp
    if type(clampMult) == "number" and clampMult > 0 and vanillaMax > 0 then
        if mult > clampMult then 
            log_line(("WARN: MaxFlameAltars_Multiplier (%s) > clamp (%s); clamping"):format(tostring(mult), tostring(clampMult)), 1)
            mult = clampMult 
        end
        local maxAllowedCap = m_floor((vanillaMax * clampMult) + 0.5)
        if cap > maxAllowedCap then 
            log_line(("WARN: MaxFlameAltars_Cap (%s) > clamp (%s = vanillaMax(%s)*%s); clamping"):format(
                tostring(cap), tostring(maxAllowedCap), tostring(vanillaMax), tostring(clampMult)
            ), 1)
            cap = maxAllowedCap 
        end
    end

    local scanned = 0
    local changed = 0
    local skipped = 0
    local failed  = 0
    local shown = 0
    local SHOW_LIMIT = 25

    for i, oldCount in ipairs(altarLevels) do
        scanned = scanned + 1

        local ok, err = pcall(function()
            if type(oldCount) ~= "number" then
                skipped = skipped + 1
                return
            end

            local rawNew = oldCount * mult
            local newCount = m_floor(rawNew + 0.5)
            if newCount > cap then newCount = cap end

            if newCount > oldCount then
                altarLevels[i] = newCount
                changed = changed + 1

                if safe_LOG_LEVEL >= 2 and shown < SHOW_LIMIT then
                    shown = shown + 1
                    log_line(("  flameLevel[%d] altars: %s -> %s (raw=%s cap=%s)"):format(
                        i, tostring(oldCount), tostring(newCount), tostring(rawNew), tostring(cap)
                    ), 2)
                end
            else
                skipped = skipped + 1
            end
        end)

        if not ok then
            failed = failed + 1
            if safe_LOG_LEVEL >= 2 then
                log_line("WARN: altarsPerFlameLevel patch failed idx=" .. tostring(i) .. " err=" .. tostring(err), 2)
            end
        end
    end

    log_line(("  altarsPerFlameLevel scanned=%d changed=%d skipped=%d failed=%d multiplier=%s cap=%s"):format(
        scanned, changed, skipped, failed, tostring(mult), tostring(cap)
    ), 1)

    if safe_LOG_LEVEL >= 2 and changed > SHOW_LIMIT then
        log_line("  (Display list truncated, increase SHOW_LIMIT to print all)", 2)
    end

    feature_end(changed > 0)
end

local function ApplyBaseSizeTweaks()
    feature_begin("Base Size Multipliers", 1)

    if not Enable_BaseSizeTweaks then
        feature_end(false)
        return
    end

    local mult = BaseSize_Multiplier
    if type(mult) ~= "number" or mult <= 0 then
        log_line("WARN: BaseSize_Multiplier invalid; skipping: " .. tostring(mult), 1)
        feature_end(false)
        return
    end

    local maxMult = BaseSize_MaxMultiplierClamp
    if type(maxMult) == "number" and maxMult > 0 and mult > maxMult then
        log_line(("WARN: BaseSize_Multiplier (%s) > clamp (%s); clamping"):format(tostring(mult), tostring(maxMult)), 1)
        mult = maxMult
    end

    local btRes = get_first_resource_by_type("keen::BalancingTable")
    local bt = btRes and btRes.data
    if not bt then
        log_line("WARN: keen::BalancingTable not found; skipping", 1)
        feature_end(false)
        return
    end

    local sizes = bt.buildzoneSizesPerAltarLevel
    if not sizes then
        log_line("WARN: BalancingTable.buildzoneSizesPerAltarLevel missing; skipping", 1)
        feature_end(false)
        return
    end

    local scanned = 0
    local eligible = 0
    local changed = 0
    local skipped = 0
    local failed = 0

    local shown = 0
    local SHOW_LIMIT = 25

    for idx, v in ipairs(sizes) do
        scanned = scanned + 1

        local ok, err = pcall(function()
            local x, y, z = v.x, v.y, v.z
            if type(x) ~= "number" or type(y) ~= "number" or type(z) ~= "number" then
                skipped = skipped + 1
                return
            end

            if x <= 0 then
                skipped = skipped + 1
                return
            end

            eligible = eligible + 1

            local beforeX, beforeY, beforeZ = x, y, z

            local function round_nearest(n) return m_floor(n + 0.5) end
            local newX = round_nearest(x * mult)
            local newY = round_nearest(y * mult)
            local newZ = round_nearest(z * mult)

            if m_abs(newX - x) > 0.01 or m_abs(newY - y) > 0.01 or m_abs(newZ - z) > 0.01 then
                v.x = newX
                v.y = newY
                v.z = newZ
                changed = changed + 1

                if safe_LOG_LEVEL >= 2 and shown < SHOW_LIMIT then
                    shown = shown + 1
                    log_line(s_format(
                        "  entry[%s] (x,y,z): (%.2f, %.2f, %.2f) -> (%.2f, %.2f, %.2f)",
                        tostring(idx),
                        beforeX, beforeY, beforeZ,
                        v.x, v.y, v.z
                    ), 2)
                end
            else
                skipped = skipped + 1
            end
        end)

        if not ok then
            failed = failed + 1
            if safe_LOG_LEVEL >= 2 then
                log_line("WARN: buildzoneSizesPerAltarLevel patch failed idx=" .. tostring(idx) .. " err=" .. tostring(err), 2)
            end
        end
    end

    log_line(("  buildzoneSizesPerAltarLevel scanned=%d eligible=%d changed=%d skipped=%d failed=%d multiplier=%s"):format(
        scanned, eligible, changed, skipped, failed, tostring(mult)
    ), 1)

    if safe_LOG_LEVEL >= 2 and shown >= SHOW_LIMIT then
        log_line("  (Display list truncated, increase SHOW_LIMIT to print all)", 2)
    end

    feature_end(changed > 0)
end

local function ApplyGemTweaks()
    feature_begin("Gem Tweaks", 1)

    if not Enable_GemTweaks then
        feature_end(false)
        return
    end

    local function clamp_gem_rate(val)
        if type(val) ~= "number" then return nil end
        return m_max(0.0, m_min(val, 1.0))
    end

    local salvageRate = clamp_gem_rate(GemTweaks_SalvageRate)
    local commonRate = clamp_gem_rate(GemTweaks_Probability_Common)
    local uncommonRate = clamp_gem_rate(GemTweaks_Probability_Uncommon)
    local rareRate = clamp_gem_rate(GemTweaks_Probability_Rare)
    local epicRate = clamp_gem_rate(GemTweaks_Probability_Epic)
    local legendaryRate = clamp_gem_rate(GemTweaks_Probability_Legendary)

    if not salvageRate and not commonRate and not uncommonRate and not rareRate and not epicRate and not legendaryRate then
        log_line("Notice: All GemTweaks parameters are nil/invalid. Skipping.", 1)
        feature_end(false)
        return
    end

    local btRes = get_first_resource_by_type("keen::BalancingTable")
    local bt = btRes and btRes.data
    if not bt then
        log_line("WARN: keen::BalancingTable not found; skipping", 1)
        feature_end(false)
        return
    end

    local patchedFields = 0

    pcall(function()
        if bt.gemCrafting ~= nil then
            if salvageRate ~= nil then
                if bt.gemCrafting.salvageGainPercentage ~= nil then
                    bt.gemCrafting.salvageGainPercentage = salvageRate
                    patchedFields = patchedFields + 1
                else
                    log_line("WARN: BalancingTable.gemCrafting.salvageGainPercentage missing; skipping field", 1)
                end
            end
        else
            log_line("WARN: BalancingTable.gemCrafting missing; skipping field", 1)
        end

        if bt.gemSlotProbability ~= nil then
            if commonRate ~= nil then if bt.gemSlotProbability.common ~= nil then bt.gemSlotProbability.common = commonRate; patchedFields = patchedFields + 1; else log_line("WARN: BalancingTable.gemSlotProbability.common missing; skipping field", 1) end end
            if uncommonRate ~= nil then if bt.gemSlotProbability.uncommon ~= nil then bt.gemSlotProbability.uncommon = uncommonRate; patchedFields = patchedFields + 1; else log_line("WARN: BalancingTable.gemSlotProbability.uncommon missing; skipping field", 1) end end
            if rareRate ~= nil then if bt.gemSlotProbability.rare ~= nil then bt.gemSlotProbability.rare = rareRate; patchedFields = patchedFields + 1; else log_line("WARN: BalancingTable.gemSlotProbability.rare missing; skipping field", 1) end end
            if epicRate ~= nil then if bt.gemSlotProbability.epic ~= nil then bt.gemSlotProbability.epic = epicRate; patchedFields = patchedFields + 1; else log_line("WARN: BalancingTable.gemSlotProbability.epic missing; skipping field", 1) end end
            if legendaryRate ~= nil then if bt.gemSlotProbability.legendary ~= nil then bt.gemSlotProbability.legendary = legendaryRate; patchedFields = patchedFields + 1; else log_line("WARN: BalancingTable.gemSlotProbability.legendary missing; skipping field", 1) end end
        else
            log_line("WARN: BalancingTable.gemSlotProbability missing; skipping field", 1)
        end
    end)

    log_line(("BalancingTable patchedFields=%d salvageRate=%s commonRate=%s uncommonRate=%s rareRate=%s epicRate=%s legendaryRate=%s"):format(
        patchedFields, tostring(salvageRate), tostring(commonRate), tostring(uncommonRate), tostring(rareRate), tostring(epicRate), tostring(legendaryRate)
    ), 1)

    feature_end(patchedFields > 0)
end

local function ApplyFogTweaks()
    feature_begin("Fog Tweaks", 1)

    if not Enable_FogTweaks then
        feature_end(false)
        return
    end

    local res = get_first_resource_by_type("keen::VolumetricFog3Resource")
    if not res or not res.data then
        log_line("WARN: keen::VolumetricFog3Resource missing; skipping.", 1)
        feature_end(false)
        return
    end

    local data = res.data
    local mats = data.materials
    if not mats then
        log_line("WARN: VolumetricFog3Resource.data.materials missing; skipping.", 1)
        feature_end(false)
        return
    end

    local changed_count = 0

    local function validate(val, clamp)
        if type(val) ~= "number" then return nil end
        if val > clamp then return clamp end
        if val < 0 then return 0 end
        return val
    end

    local function apply(target_tbl, field_name, new_val, log_name)
        if new_val == nil then return end
        if target_tbl[field_name] ~= new_val then
            if safe_LOG_LEVEL >= 2 then
                log_line(("%s: %s -> %s"):format(log_name, tostring(target_tbl[field_name]), tostring(new_val)), 2)
            end
            target_tbl[field_name] = new_val
            changed_count = changed_count + 1
        end
    end

    local function apply_material(index, density_cfg, opacity_cfg)
        local mat = mats[index]
        if not mat then return end

        local d = validate(density_cfg, Fog_Density_MaxClamp)
        local o = validate(opacity_cfg, Fog_Opacity_MaxClamp)

        apply(mat, "densityScale", d, ("Mat[%d].Density"):format(index))
        apply(mat, "extinction", o, ("Mat[%d].Opacity"):format(index))
    end

    local function apply_barrier_mat(target_tbl, name_prefix, emissiveExp_cfg, emissive_cfg, opacity_cfg, scatter_cfg)
        if not target_tbl then return end

        local ee = validate(emissiveExp_cfg, Fog_Emissive_MaxClamp)
        local e  = validate(emissive_cfg,    Fog_Emissive_MaxClamp)
        local o  = validate(opacity_cfg,     Fog_Opacity_MaxClamp)
        local s  = validate(scatter_cfg,     Fog_Scatter_MaxClamp)

        apply(target_tbl, "emissiveExposuredIntensity", ee, name_prefix .. ".EmissiveExposed")
        apply(target_tbl, "emissiveIntensity",          e,  name_prefix .. ".Emissive")
        apply(target_tbl, "extinction",                 o,  name_prefix .. ".Opacity")
        apply(target_tbl, "scatterBoost",               s,  name_prefix .. ".ScatterBoost")
    end

    local ok, err = pcall(function()
        apply_material(1, Fog_M1_Density, Fog_M1_Opacity)
        apply_material(2, Shroud_Fog_Dangerous_Density, Shroud_Fog_Dangerous_Opacity)
        apply_material(3, Shroud_Fog_Deadly_Density, Shroud_Fog_Deadly_Opacity)

        apply(data, "rainExtinction",     validate(Rain_Opacity, Fog_Opacity_MaxClamp),     "RainOpacity")
        apply(data, "snowExtinction",     validate(Snow_Opacity, Fog_Opacity_MaxClamp),     "SnowOpacity")
        apply(data, "blizzardExtinction", validate(Blizzard_Opacity, Fog_Opacity_MaxClamp), "BlizzardOpacity")

        if data.heightFogMaterial then
            local hfd = validate(HeightFog_Density, Fog_Density_MaxClamp)
            local hfo = validate(HeightFog_Opacity, Fog_Opacity_MaxClamp)
            apply(data.heightFogMaterial, "densityScale", hfd, "HeightFog.Density")
            apply(data.heightFogMaterial, "extinction",   hfo, "HeightFog.Opacity")
        end

        apply(data, "barrierFogThickness", validate(Ambient_Fog_Density, Fog_Density_MaxClamp), "BarrierThickness")

        apply_barrier_mat(data.dangerousBarrierFogMaterial, "DangerousBarrier",
            Dangerous_Fog_Barrier_Exposed_Emissive_Intensity,
            Dangerous_Fog_Barrier_Emissive_Intensity,
            Dangerous_Fog_Barrier_Opacity,
            Dangerous_Fog_Barrier_Scatter_Boost
        )

        apply_barrier_mat(data.deadlyBarrierFogMaterial, "DeadlyBarrier",
            Deadly_Fog_Barrier_Exposed_Emissive_Intensity,
            Deadly_Fog_Barrier_Emissive_Intensity,
            Deadly_Fog_Barrier_Opacity,
            Deadly_Fog_Barrier_Scatter_Boost
        )
    end)

    if not ok then
        log_line("ERROR applying fog tweaks: " .. tostring(err), 1)
        feature_end(false)
        return
    end

    log_line(("Applied changes to %d fields."):format(changed_count), 1)
    feature_end(changed_count > 0)
end

local function ApplyLootTweaks()
    feature_begin("Loot Tweaks", 1)
    if not Enable_LootTweaks then
        feature_end(false)
        return
    end

    local equipMulti = Loot_EquipmentDropMultiplier
    local consMulti = Loot_ConsumableDropMultiplier
    local arrowMulti = Loot_ArrowDropMultiplier
    local gemMulti = Loot_GemDropMultiplier
    local explosiveMulti = Loot_ExplosiveDropMultiplier
    local maxStack = Loot_MaxStackSize

    local function validate_mult(val, name)
        if type(val) ~= "number" or val <= 0 then
            log_line("WARN: " .. name .. " invalid; defaulting to 1.0", 1)
            return 1.0
        end
        local clamp = Loot_DropMultiplierMaxClamp
        if type(clamp) == "number" and clamp > 0 and val > clamp then
            log_line(("WARN: %s (%s) > clamp (%s); clamping"):format(name, tostring(val), tostring(clamp)), 1)
            return clamp
        end
        return val
    end

    equipMulti = validate_mult(equipMulti, "Loot_EquipmentDropMultiplier")
    consMulti = validate_mult(consMulti, "Loot_ConsumableDropMultiplier")
    arrowMulti = validate_mult(arrowMulti, "Loot_ArrowDropMultiplier")
    gemMulti = validate_mult(gemMulti, "Loot_GemDropMultiplier")
    explosiveMulti = validate_mult(explosiveMulti, "Loot_ExplosiveDropMultiplier")

    local maxStackClamp = Loot_MaxStackSizeClamp
    if type(maxStack) == "number" and maxStack >= 1 then
        if type(maxStackClamp) == "number" and maxStackClamp > 0 and maxStack > maxStackClamp then
            log_line(("WARN: Loot_MaxStackSize (%s) > clamp (%s); clamping"):format(tostring(maxStack), tostring(maxStackClamp)), 1)
            maxStack = maxStackClamp
        end
    else
        log_line("WARN: Loot_MaxStackSize invalid; stackSizeMaxScaled will not be set", 1)
        maxStack = nil
    end

    local function scale_field(obj, field, mult)
        if not obj or type(obj[field]) ~= "number" then return false end
        local before = obj[field]
        local after = before * mult
        if after < 0 then after = 0 end
        if mult == 1.0 then return false end
        if after ~= before then
            obj[field] = after
            return true
        end
        return false
    end

    local items = get_cached_resources_by_type("keen::ItemInfo")
    if not items or #items == 0 then
        log_line("WARN: No ItemInfo entries found; skipping", 1)
        feature_end(false)
        return
    end

    local eligibleItems = {}
    local itemMultipliers = {}
    local itemIsEquip = {}
    local CONSUMABLE_KEYWORDS = { "spell", "potion", "consumable", "food", "scroll", "bait" }
    local ARROW_KEYWORDS = { "arrow", "ammo" }
    local GEM_KEYWORDS = { "gem" }
    local EXPLOSIVE_KEYWORDS = { "grenade", "explosive" }

    -- Categorize items based on properties & strings rather than purely stack limits
    for _, it in ipairs(items) do
        local d = it and it.data
        if d and type(d.maxStackSize) == "number" then
            local id = d.itemId and d.itemId.value
            if type(id) == "number" then
                local dbg = s_lower(tostring(d.debugName or ""))

                local isArrow = false
                for _, kw in ipairs(ARROW_KEYWORDS) do
                    if s_find(dbg, kw, 1, true) then isArrow = true; break end
                end

                local isGem = false
                for _, kw in ipairs(GEM_KEYWORDS) do
                    if s_find(dbg, kw, 1, true) then isGem = true; break end
                end

                local isExplosive = false
                for _, kw in ipairs(EXPLOSIVE_KEYWORDS) do
                    if s_find(dbg, kw, 1, true) then isExplosive = true; break end
                end

                local isCons = false
                for _, kw in ipairs(CONSUMABLE_KEYWORDS) do
                    if s_find(dbg, kw, 1, true) then isCons = true; break end
                end

                -- Equipment naturally includes items with equipment data or items defaulting to maxStackSize 1
                local isEquip = false
                if not isCons and not isArrow and not isGem and not isExplosive and (d.equipment ~= nil or d.maxStackSize == 1) then
                    isEquip = true
                end

                itemIsEquip[id] = isEquip

                if isArrow then
                    itemMultipliers[id] = arrowMulti
                elseif isGem then
                    itemMultipliers[id] = gemMulti
                elseif isExplosive then
                    itemMultipliers[id] = explosiveMulti
                elseif isCons then
                    itemMultipliers[id] = consMulti
                elseif isEquip then
                    itemMultipliers[id] = equipMulti
                else
                    itemMultipliers[id] = 1.0
                end

                eligibleItems[id] = true
            end
        end
    end

    local didWork = false

    -- [1] Default Inventory (Starting Gear/Pickups)
    local defaultInv = get_cached_resources_by_type("keen::ecs::DefaultInventoryResource")
    if defaultInv and #defaultInv > 0 then
        local invScanned = 0
        local invChanged = 0
        local invFailed = 0
        local function patch_stacks(stacks)
            if not stacks then return end
            for _, stack in pairs(stacks) do
                local id = stack and stack.item and stack.item.value
                if id and eligibleItems[id] then
                    invScanned = invScanned + 1
                    local m = itemMultipliers[id] or 1.0
                    local any = false
                    any = scale_field(stack, "countMin", m) or any
                    any = scale_field(stack, "countMax", m) or any
                    if any then invChanged = invChanged + 1 end
                end
            end
        end
        for _, res in ipairs(defaultInv) do
            local ok, err = pcall(function()
                local root = res and res.data and res.data.rootGroup
                if not root then return end
                patch_stacks(root.stacks)
                for _, group in pairs(root.groups or {}) do
                    patch_stacks(group and group.stacks)
                end
            end)
            if not ok then
                invFailed = invFailed + 1
                if safe_LOG_LEVEL >= 2 then
                    log_line("WARN: DefaultInventoryResource patch failed guid=" .. tostring(res and res.guid or "nil") .. " err=" .. tostring(err), 2)
                end
            end
        end
        log_line(("DefaultInventoryResource scanned=%d changed=%d failed=%d"):format(
            invScanned, invChanged, invFailed
        ), 1)
        if invChanged > 0 then didWork = true end
    end

    -- [2] ItemInfo (World Drop Range)
    local itemScanned = 0
    local itemChanged = 0
    local itemFailed = 0
    for _, it in ipairs(items) do
        local ok, err = pcall(function()
            local d = it and it.data
            if not d then return end
            
            local id = d.itemId and d.itemId.value
            if id and eligibleItems[id] then
                local range = d.randomLootStackRange
                if range then
                    itemScanned = itemScanned + 1
                    local m = itemMultipliers[id] or 1.0
                    local beforeMin = range.minStackSize
                    local beforeMax = range.maxStackSize
                    local any = false
                    any = scale_field(range, "minStackSize", m) or any
                    any = scale_field(range, "maxStackSize", m) or any
                    if any then itemChanged = itemChanged + 1 end
                end
            end
        end)
        if not ok then
            itemFailed = itemFailed + 1
            if safe_LOG_LEVEL >= 2 then
                log_line("WARN: ItemInfo randomLootStackRange patch failed err=" .. tostring(err), 2)
            end
        end
    end
    log_line(("ItemInfo randomLootStackRange scanned=%d changed=%d failed=%d"):format(
        itemScanned, itemChanged, itemFailed
    ), 1)
    if itemChanged > 0 then didWork = true end

    -- [3] Lootable Items (Chests/Enemies)
    local lootRes = get_cached_resources_by_type("keen::LootableItemsResource")
    if lootRes and #lootRes > 0 then
        local lootScanned = 0
        local lootChanged = 0
        local lootFailed = 0
        for _, res in ipairs(lootRes) do
            local ok, err = pcall(function()
                local entries = res and res.data and res.data.items
                if not entries then return end
                for _, entry in pairs(entries) do
                    local id = entry and entry.itemId and entry.itemId.value
                    if id and eligibleItems[id] then
                        lootScanned = lootScanned + 1
                        local m = itemMultipliers[id] or 1.0
                        local any = false
                        
                        any = scale_field(entry, "stackSizeMin", m) or any
                        any = scale_field(entry, "stackSizeMax", m) or any
                        
                        if entry.stackSizeScalable ~= false then
                            entry.stackSizeScalable = false
                            any = true
                        end
                        local isEquip = itemIsEquip[id] or false
                        if maxStack ~= nil and not isEquip then
                            if entry.stackSizeMaxScaled ~= maxStack then
                                entry.stackSizeMaxScaled = maxStack
                                any = true
                            end
                        end
                        
                        if any then lootChanged = lootChanged + 1 end
                    end
                end
            end)
            if not ok then
                lootFailed = lootFailed + 1
                if safe_LOG_LEVEL >= 2 then
                    log_line("WARN: LootableItemsResource patch failed guid=" .. tostring(res and res.guid or "nil") .. " err=" .. tostring(err), 2)
                end
            end
        end
        log_line(("LootableItemsResource scanned=%d changed=%d failed=%d"):format(
            lootScanned, lootChanged, lootFailed
        ), 1)
        if lootChanged > 0 then didWork = true end
    end

    feature_end(didWork)
end

local function apply_fast_travel_tweaks()
    local toggles = {
        None = FastTravel_None,
        FlameRelated = FastTravel_FlameMarkers,
        Dungeons = FastTravel_DungeonMarkers,
        Locations = FastTravel_LocationMarkers,
    }

    local registry_res = get_first_resource_by_type("keen::MapMarkerRegistryResource")
    if not registry_res or not registry_res.data then
         log_line("ERROR: MapMarkerRegistryResource not found", 1)
         return false
    end

    local registry = registry_res.data
    local changed = 0
    local matched = 0
    local markers = registry.mapMarkers
    local markerList = markers and markers.values

    if not markerList then
         log_line("ERROR: mapMarkers.values list missing", 1)
         return false
    end

    local ok, err = pcall(function()
        for i, marker in ipairs(markerList) do
             local cat = marker.sortingCategory
             local enabled = toggles[cat]
             if enabled ~= nil then
                 matched = matched + 1
                 if marker.isFastTravelDestination ~= enabled then
                     marker.isFastTravelDestination = enabled
                     changed = changed + 1
                 end
             end
        end
    end)

    if not ok then
        log_line("ERROR in loop: " .. tostring(err), 1)
        return false
    end

    log_line(("Fast Travel markers matched=%d changed=%d"):format(matched, changed), 1)
    return true
end

local function apply_fog_of_war_tweaks()
    local range = FogOfWar_Range
    if type(range) ~= "number" or range <= 0 then
        log_line("WARN: FogOfWar_Range invalid; skipping: " .. tostring(range), 1)
        return false
    end

    local maxClamp = FogOfWar_MaxRangeClamp
    if type(maxClamp) == "number" and maxClamp > 0 and range > maxClamp then
        log_line(("WARN: FogOfWar_Range (%s) > clamp (%s); clamping"):format(tostring(range), tostring(maxClamp)), 1)
        range = maxClamp
    end

    local templates = get_cached_resources_by_type("keen::ecs::TemplateResource")
    if not templates or #templates == 0 then
        log_line("WARN: No TemplateResource entries found for Fog of War", 1)
        return false
    end

    local matched = 0
    local changed = 0

    local ok, err = pcall(function()
        for _, res in ipairs(templates) do
            local comps = res and res.data and res.data.components
            if comps then
                for _, comp in ipairs(comps) do
                    if comp and comp.type == "keen::ecs::FogOfWarDiscovery" then
                        matched = matched + 1
                        local v = comp.value
                        if v then
                            if v.discoveryRange ~= range then
                                v.discoveryRange = range
                                changed = changed + 1
                            end
                        end
                    end
                end
            end
        end
    end)

    if not ok then
        log_line("ERROR: Fog of War tweak failed: " .. tostring(err), 1)
        return false
    end

    log_line(("Fog of War discoveryRange matched=%d changed=%d range=%s"):format(
        matched, changed, tostring(range)
    ), 1)

    return true
end

local function ApplyFastTravelTweaks()
    feature_begin("Map Tweaks", 1)

    local didWork = false

    if Enable_FastTravelTweaks then
        didWork = apply_fast_travel_tweaks() or didWork
    end

    if Enable_FogOfWarTweaks then
        didWork = apply_fog_of_war_tweaks() or didWork
    end

    feature_end(didWork)
end

local function ApplyExpandedGameSettings()
    feature_begin("Expanded Game Settings", 1)

    if not Enable_ExpandedGameSettings then
        log_line("Feature Disabled check Config", 1)
        feature_end(false)
        return
    end

    local level = 1
    local function logInfo(msg) log_line(msg, level) end
    local function logWarn(msg) log_line("WARN: " .. tostring(msg), level) end
    local function logError(msg) log_line("ERROR: " .. tostring(msg), level) end

    local presets_res = get_first_resource_by_type("keen::GameSettingsPresetsResource")
    local ui_res = get_first_resource_by_type("keen::FbUiBundle")

    if not presets_res or not ui_res then
        logError("Required resources not found (GameSettingsPresetsResource or FbUiBundle)")
        feature_end(false)
        return
    end

    local VALID_GAME_SETTINGS = {
        playerHealthFactor = true, playerManaFactor = true, playerStaminaFactor = true,
        playerBodyHeatFactor = true, playerDivingTimeFactor = true, foodBuffDurationFactor = true,
        fromHungerToStarving = true, shroudTimeFactor = true, weatherFrequency = true,
        fishingDifficulty = true, miningDamageFactor = true, plantGrowthSpeedFactor = true,
        resourceDropStackAmountFactor = true, factoryProductionSpeedFactor = true,
        perkUpgradeRecyclingFactor = true, perkCostFactor = true, experienceCombatFactor = true,
        experienceMiningFactor = true, experienceExplorationQuestsFactor = true,
        randomSpawnerAmount = true, aggroPoolAmount = true, enemyDamageFactor = true,
        enemyHealthFactor = true, enemyStaminaFactor = true, enemyPerceptionRangeFactor = true,
        bossDamageFactor = true, bossHealthFactor = true, threatBonus = true,
        tamingStartleRepercussion = true, dayTimeDuration = true, nightTimeDuration = true,
        curseModifier = true,
    }

    local presets = presets_res.data
    local ui = ui_res.data

    local ConfigToPresetMap = {
        ["foodDuration"] = "foodBuffDurationFactor", ["starvingTime"] = "fromHungerToStarving",
        ["playerDivingTime"] = "playerDivingTimeFactor", ["shroudTime"] = "shroudTimeFactor",
        ["miningDamage"] = "miningDamageFactor", ["plantGrowTime"] = "plantGrowthSpeedFactor",
        ["dropAmount"] = "resourceDropStackAmountFactor", ["productionTime"] = "factoryProductionSpeedFactor",
        ["weaponUpgradeCost"] = "perkCostFactor", ["perkUpgradeRecyclingFactor"] = "perkUpgradeRecyclingFactor",
        ["combatXp"] = "experienceCombatFactor", ["miningXp"] = "experienceMiningFactor",
        ["questXp"] = "experienceExplorationQuestsFactor", ["enemyDamage"] = "enemyDamageFactor",
        ["enemyHealth"] = "enemyHealthFactor", ["enemyStamina"] = "enemyStaminaFactor",
        ["enemyPerceptionRange"] = "enemyPerceptionRangeFactor", ["enemyAttackFrequency"] = "aggroPoolAmount",
        ["bossDamage"] = "bossDamageFactor", ["bossHealth"] = "bossHealthFactor",
        ["dayTime"] = "dayTimeDuration", ["nightTime"] = "nightTimeDuration",
    }

    local function SafeSetPreset(key, min, max)
        if not VALID_GAME_SETTINGS[key] then return false end

        local ok, err = pcall(function()
             if presets.minValues[key] ~= nil then
                 local field = presets.minValues[key]
                 if type(field) == "userdata" or type(field) == "table" then
                     local s_field = tostring(field)
                     if s_find(s_field, "ValueWrapper") or field.value ~= nil then
                         field.value = min
                     else
                         log_line("WARN: Complex type for " .. key .. " not fully supported.", 1)
                     end
                 else
                     presets.minValues[key] = min
                 end
             end

             if presets.maxValues[key] ~= nil then
                  local fieldMax = presets.maxValues[key]
                  if type(fieldMax) == "userdata" or type(fieldMax) == "table" then
                      local s_fieldMax = tostring(fieldMax)
                      if s_find(s_fieldMax, "ValueWrapper") or fieldMax.value ~= nil then
                          fieldMax.value = max
                      else
                          log_line("WARN: Complex type for " .. key .. " not fully supported.", 1)
                      end
                  else
                      presets.maxValues[key] = max
                  end
             end
        end)

        if not ok then
            logError("Error setting preset " .. key .. ": " .. tostring(err))
            return false
        end
        return true
    end

    local function SetCustomRange(settingName, values)
        if not ui.difficultySettings or not ui.difficultySettings.settingValues then return end
        if not values or #values == 0 then return end

        if ui.difficultySettings.settingValues[settingName] then
            ui.difficultySettings.settingValues[settingName].steps = values
            logInfo(s_format("Updated UI steps for '%s' (%d steps)", settingName, #values))
        else
            logError("UI Setting not found: " .. tostring(settingName))
            return
        end

        local minVal, maxVal = values[1], values[1]
        for _, v in ipairs(values) do
            if v < minVal then minVal = v end
            if v > maxVal then maxVal = v end
        end

        local backendMin, backendMax = minVal, maxVal
        if settingName == "dayTime" or settingName == "nightTime" or settingName == "starvingTime" then
            local SEC = 1e9
            backendMin = backendMin * 60 * SEC
            backendMax = backendMax * 60 * SEC
        end

        local backendKeys = {}
        if ConfigToPresetMap[settingName] then t_insert(backendKeys, ConfigToPresetMap[settingName]) end
        t_insert(backendKeys, settingName .. "Factor")
        t_insert(backendKeys, settingName)

        local applied = false
        for _, key in ipairs(backendKeys) do
            if SafeSetPreset(key, backendMin, backendMax) then
                logInfo(s_format("SUCCESS: Mapped Config '%s' -> Backend '%s' [%s, %s]", settingName, key, tostring(backendMin), tostring(backendMax)))
                applied = true
                break
            end
        end

        if not applied then
            logWarn("Could not map Config '" .. settingName .. "' to any valid GameSettings key. Checked: " .. t_concat(backendKeys, ", "))
        end
    end

    local ok, err = pcall(function()
        log_line("Applying Enhanced Sliders...", 1)
        if ExpandedGameSettings_Config and type(ExpandedGameSettings_Config) == "table" then
            for _, cfg in ipairs(ExpandedGameSettings_Config) do
                if cfg.Enabled ~= false and type(cfg.Values) == "table" then
                    SetCustomRange(cfg.Name, cfg.Values)
                end
            end
        else
            logError("ExpandedGameSettings_Config not found or invalid.")
        end
    end)

    if not ok then
        logError("Critical error in ApplyExpandedGameSettings: " .. tostring(err))
        feature_end(false)
    else
        feature_end(true)
    end
end

local function BuildingTweaks()
    feature_begin("Building Tweaks", 1)
    
    local didWork = false

    if Enable_BuildingTweaks then
        local scenes = get_cached_resources_by_type("keen::SceneResource")
        if not scenes or #scenes == 0 then
            log_line("WARN: No SceneResource entries found", 1)
        else
            local TARGET_IBL = "9743d1a0-007d-4a8a-9088-82d34ce7a697"
            log_line("  Target IBL: " .. tostring(TARGET_IBL), 1)
            local sceneChanged = 0
            for _, s in ipairs(scenes) do
                local d = s and s.data
                if d and tostring(d.ibl) == TARGET_IBL then
                    if d.noBuildZones ~= nil then
                        d.noBuildZones = {}
                        sceneChanged = sceneChanged + 1
                    end
                end
            end
            log_line("  SceneResource noBuildZones cleared: " .. tostring(sceneChanged), 1)
            if sceneChanged > 0 then didWork = true end
        end
    else
        log_line("  Building Tweaks (NoBuildZones): disabled", 1)
    end
    
    if Enable_PlacementTweaks then
        local buildInFog = (PlacementTweaks_BuildInFog == true)
        local noZoneNeed = (PlacementTweaks_NoBuildZoneNeeded == true)
        if not buildInFog and not noZoneNeed then
            log_line("  Placement Tweaks: enabled, but all sub-tweaks are disabled", 1)
        else
            local items = get_cached_resources_by_type("keen::ItemInfo")
            if not items or #items == 0 then
                log_line("WARN: No ItemInfo entries found for placement-rule edits", 1)
            else
                local skipNeedle = tostring(PlacementTweaks_SafetySkip or "")
                if skipNeedle == "" then
                    log_line("  Placement Tweaks: no safety-skip string set", 2)
                end
                
                local scanned = 0
                local eligible = 0
                local skipped = 0
                local failed = 0
                local changedAllowBelowFog = 0
                local changedInhibitBuild = 0
                local changedBuildZoneReq = 0
                local changedInteraction = 0
                local changedPermissions = 0
                local shown = 0
                local SHOW_LIMIT = 25
                
                for _, it in ipairs(items) do
                    scanned = scanned + 1
                    local ok, err = pcall(function()
                        local d = it and it.data
                        if not d then
                            skipped = skipped + 1
                            return
                        end
                        local dbg = tostring(d.debugName or "")
                        if skipNeedle ~= "" and s_find(dbg, skipNeedle, 1, true) ~= nil then
                            skipped = skipped + 1
                            return
                        end
                        local eq = d.equipment
                        if not eq then
                            skipped = skipped + 1
                            return
                        end
                        
                        eligible = eligible + 1
                        local changedAny = false
                        
                        if buildInFog then
                            pcall(function()
                                if eq.allowPlacementBelowFog ~= true then
                                    eq.allowPlacementBelowFog = true
                                    changedAllowBelowFog = changedAllowBelowFog + 1
                                    changedAny = true
                                end
                            end)
                            pcall(function()
                                local current = tostring(eq.checkInhibitBuild)
                                if current == "Strict" or current == "Lenient" then
                                    eq.checkInhibitBuild = "None"
                                    changedInhibitBuild = changedInhibitBuild + 1
                                    changedAny = true
                                end
                            end)
                        end
                        if noZoneNeed then
                            pcall(function()
                                if eq.buildZoneRequired ~= false then
                                    eq.buildZoneRequired = false
                                    changedBuildZoneReq = changedBuildZoneReq + 1
                                    changedAny = true
                                end
                            end)
                            pcall(function()
                                if d.permissionSetup then
                                     if d.permissionSetup.isSet ~= false then
                                        d.permissionSetup.isSet = false
                                        changedPermissions = changedPermissions + 1
                                        changedAny = true
                                     end
                                end
                            end)
                            pcall(function()
                                local entity = eq.placedEntity
                                if entity and entity.components then
                                    local comp = find_component_by_type(entity.components, "keen::ecs::DismantleOverride")
                                    if comp then
                                        if comp.ignoreBuildZoneChecks ~= true then
                                            comp.ignoreBuildZoneChecks = true
                                            changedInteraction = changedInteraction + 1
                                            changedAny = true
                                        end
                                    else
                                        local newComp = {
                                            type = "keen::ecs::DismantleOverride",
                                            ignoreBuildZoneChecks = true,
                                            overrideMethod = false,
                                            method = 0,
                                            overrideVolumeClass = false,
                                            volumeClass = 0,
                                            preventDismantlingWithFilledInventory = false
                                        }
                                        t_insert(entity.components, newComp)
                                        changedInteraction = changedInteraction + 1
                                        changedAny = true
                                    end
                                end
                            end)
                        end
                        
                        if changedAny then
                            didWork = true
                        end
                        if safe_LOG_LEVEL >= 2 and changedAny and shown < SHOW_LIMIT then
                            shown = shown + 1
                            log_line(("  item[%d] debugName=%s patched"):format(shown, dbg), 2)
                        end
                    end)
                    
                    if not ok then
                        failed = failed + 1
                        if safe_LOG_LEVEL >= 2 then
                            log_line("WARN: ItemInfo placement-rule patch failed guid=" .. tostring(it and it.guid or "nil") .. " err=" .. tostring(err), 2)
                        end
                    end
                end
                
                log_line(("  ItemInfo scanned=%d eligible=%d skipped=%d failed=%d"):format(
                    scanned, eligible, skipped, failed
                ), 1)
                log_line(("  Patches: Fog=%d | Inhibit=%d | NoZone=%d | Perms=%d | Interaction(Inj)=%d"):format(
                    changedAllowBelowFog, changedInhibitBuild, changedBuildZoneReq, changedPermissions, changedInteraction
                ), 1)
                
                if safe_LOG_LEVEL >= 2 and shown >= SHOW_LIMIT then
                    log_line("  (Display list truncated, increase SHOW_LIMIT to print all)", 2)
                end
            end
        end
    else
        log_line("  Placement Tweaks: disabled", 1)
    end
    
    feature_end(didWork)
end

local function ApplyCraftingTweaks()
    feature_begin("Crafting Tweaks", 1)

    if not Enable_CraftingTweaks then
        feature_end(false)
        return
    end

    local unlockRecipes = CraftingTweaks_UnlockAllRecipes
    local creativeMode = CraftingTweaks_CreativeMode
    local outMult = type(CraftingTweaks_OutputMultiplier) == "number" and CraftingTweaks_OutputMultiplier or 1.0

    if not unlockRecipes and not creativeMode and not CraftingTweaks_FreeFactories and not CraftingTweaks_FreeFlameAltar and not CraftingTweaks_FreeFood and outMult == 1.0 then
        log_line("No sub-features enabled; skipping.", 1)
        feature_end(false)
        return
    end

    local emptyInput = {}
    local registryList = get_cached_resources_by_type("keen::RecipeRegistryResource")
    if not registryList or #registryList == 0 then
        log_line("WARN: keen::RecipeRegistryResource not found; skipping", 1)
        feature_end(false)
        return
    end

    local PROTECTED_KEYS = {
        ["debugName"] = true, ["recipeId"] = true, ["id"] = true, ["guid"] = true,
        ["input"] = true, ["inputs"] = true,
        ["output"] = true, ["outputs"] = true, ["craftingDuration"] = true,
        ["knowledgeRequirement"] = true, ["completionRequirementQueryId"] = true,
        ["category"] = true, ["sortingCategory"] = true, ["sortingOrder"] = true,
        ["sortOrder"] = true, ["station"] = true, ["workshop"] = true,
        ["icon"] = true, ["name"] = true, ["description"] = true,
    }

    local function strip_all_costs(obj, depth)
        if not obj or depth > 3 then return end
        pcall(function()
            for k, v in pairs(obj) do
                local keyStr = tostring(k)
                if not PROTECTED_KEYS[keyStr] then
                    local vType = type(v)
                    if vType == "number" and v > 0 and v <= 10000 then
                        pcall(function() obj[k] = 0 end)
                    elseif vType == "userdata" or vType == "table" then
                        strip_all_costs(v, depth + 1)
                    end
                end
            end
        end)
    end

    local unlockCount = 0
    local creativeCount = 0
    local freeFoodCount = 0
    local freeFactoryCount = 0
    local freeAltarCount = 0
    local didWork = false

    for _, reg in ipairs(registryList) do
        local data = reg and reg.data
        if data and data.recipes then
            for _, recipe in ipairs(data.recipes) do
                if recipe then
                    local dn = tostring(recipe.debugName or "")
                    local FACTORY_KEYS = { "Factory", "Production" }
                    local isFactory = false
                    for _, k in ipairs(FACTORY_KEYS) do
                        if s_find(dn, k, 1, true) then isFactory = true break end
                    end

                    if unlockRecipes and recipe.knowledgeRequirement then
                        pcall(function()
                            local req = recipe.knowledgeRequirement
                            local kid = req.knowledgeOrQueryId
                            if kid and kid.value and kid.value ~= 1715248921 then
                                kid.value = 1715248921
                                if req.compareValue ~= 1 then req.compareValue = 1 end
                                if req.compareOperator ~= "Equals" then req.compareOperator = "Equals" end
                                if req.type ~= "SimpleBool" then req.type = "SimpleBool" end
                                if req.isExplicitPlayerKnowledgeQuery ~= false then req.isExplicitPlayerKnowledgeQuery = false end
                                unlockCount = unlockCount + 1
                            end
                            local cid = recipe.completionRequirementQuery and recipe.completionRequirementQuery.knowledgeOrQueryId
                            if cid and cid.value and cid.value ~= 3584013164 then
                                cid.value = 3584013164
                            end
                        end)
                        didWork = true
                    end

                    -- Campfire cooking recipes (never free) - use isCookingRecipe flag + Campfire in name
                    local function isCampfireCooking(name, recipe)
                        local lower = string.lower(name)
                        return recipe.isCookingRecipe and string.find(lower, "campfire") and not string.find(lower, "fish") and not string.find(lower, "crab") and not string.find(lower, "grill") and not string.find(lower, "oven") and not string.find(lower, "meat") and not string.find(lower, "mushroom") and not string.find(lower, "corn") and not string.find(lower, "grain")
                    end
                    -- Category lists based on actual debugNames
                    local FACTORY_KEYS = { "Factory", "Production" }
                    local FOOD_KEYS = { "Food_", "Grill", "Fish", "Oven", "Mushroom", "Meat", "Corn", "Grain" }
                    local ALTAR_UPGRADE_KEYS = { "Flame_Level_", "FlameAltar_HomeBase_Upgrade_" }

                    local function matchesAny(name, keys)
                        for _, k in ipairs(keys) do
                            if s_find(name, k, 1, true) then return true end
                        end
                        return false
                    end

                    local isExcluded = isCampfireCooking(dn, recipe)
                    local isFactory = matchesAny(dn, FACTORY_KEYS)

                    local isFood = matchesAny(dn, FOOD_KEYS) and not s_find(dn, "Bait", 1, true) and not s_find(dn, "Potion", 1, true) and not s_find(dn, "Rod", 1, true)
                    local isAltarUpgrade = matchesAny(dn, ALTAR_UPGRADE_KEYS)

                    if isExcluded then
                        -- skip: campfire cooking never free
                    elseif CraftingTweaks_FreeFood and isFood then
                        freeFoodCount = freeFoodCount + 1
                        pcall(function()
                            if recipe.input then
                                for _, inp in ipairs(recipe.input) do
                                    if inp.itemStack and inp.itemStack.count then
                                        inp.itemStack.count = 0
                                    end
                                    if inp.inputItemCategory and inp.inputItemCategory.count then
                                        inp.inputItemCategory.count = 0
                                    end
                                end
                            end
                            if recipe.waterAmount then recipe.waterAmount = 0 end
                            if recipe.waterCharges then recipe.waterCharges = 0 end
                            if recipe.requiredPropsMask and recipe.requiredPropsMask ~= 0 then
                                recipe.requiredPropsMask = 0
                            end
                            if recipe.requiresSheltered then recipe.requiresSheltered = false end
                            creativeCount = creativeCount + 1
                        end)
                        didWork = true
                    elseif CraftingTweaks_FreeFlameAltar and isAltarUpgrade then
                        freeAltarCount = freeAltarCount + 1
                        pcall(function()
                            if recipe.input then
                                for _, inp in ipairs(recipe.input) do
                                    if inp.itemStack and inp.itemStack.count then
                                        inp.itemStack.count = 0
                                    end
                                    if inp.inputItemCategory and inp.inputItemCategory.count then
                                        inp.inputItemCategory.count = 0
                                    end
                                end
                            end
                            if recipe.requiredHappyNpcCount and recipe.requiredHappyNpcCount > 0 then
                                recipe.requiredHappyNpcCount = 0
                            end
                            creativeCount = creativeCount + 1
                        end)
                        didWork = true
                    elseif creativeMode and not isAltarUpgrade and not isFood and not s_find(dn, "Algae", 1, true) and (not isFactory or s_find(dn, "EctoplasmPress", 1, true) or s_find(dn, "BeeHive", 1, true) or s_find(dn, "Smoker_for_Beehive", 1, true)) then
                        -- Clear station requirements (Loom, Grindmill, etc.)
                        pcall(function()
                            if recipe.requiredPropsMask and recipe.requiredPropsMask ~= 0 then
                                recipe.requiredPropsMask = 0
                            end
                        end)
                        pcall(function()
                            if recipe.input then
                                for _, inp in ipairs(recipe.input) do
                                    if inp.itemStack and inp.itemStack.count then
                                        inp.itemStack.count = 0
                                    end
                                    if inp.inputItemCategory and inp.inputItemCategory.count then
                                        inp.inputItemCategory.count = 0
                                    end
                                    if inp.inputItemCategory and inp.inputItemCategory.alternatives then
                                        for _, alt in ipairs(inp.inputItemCategory.alternatives) do
                                            if alt.count then alt.count = 0 end
                                        end
                                    end
                                end
                            end
                            if not isAltar then
                                strip_all_costs(recipe, 1)
                            end
                            if recipe.waterAmount then recipe.waterAmount = 0 end
                            if recipe.waterCharges then recipe.waterCharges = 0 end
                            if recipe.requiredEnergy then recipe.requiredEnergy = 0 end
                            creativeCount = creativeCount + 1
                        end)
                        didWork = true
                    elseif CraftingTweaks_FreeFactories and isFactory and not isFood then
                        freeFactoryCount = freeFactoryCount + 1
                        pcall(function()
                            if recipe.input then
                                for _, inp in ipairs(recipe.input) do
                                    if inp.itemStack and inp.itemStack.count then
                                        inp.itemStack.count = 0
                                    end
                                    if inp.inputItemCategory and inp.inputItemCategory.count then
                                        inp.inputItemCategory.count = 0
                                    end
                                    if inp.inputItemCategory and inp.inputItemCategory.alternatives then
                                        for _, alt in ipairs(inp.inputItemCategory.alternatives) do
                                            if alt.count then alt.count = 0 end
                                        end
                                    end
                                end
                            end
                            strip_all_costs(recipe, 1)
                            if recipe.waterAmount then recipe.waterAmount = 0 end
                            if recipe.waterCharges then recipe.waterCharges = 0 end
                            if recipe.requiredEnergy then recipe.requiredEnergy = 0 end
                            creativeCount = creativeCount + 1
                        end)
                        didWork = true
                    end



                    if outMult ~= 1.0 and recipe.output then
                        pcall(function()
                            for _, out in ipairs(recipe.output) do
                                if out.count and out.itemRef then
                                    local itemRes = get_cached_resource(out.itemRef, "keen::ItemInfo", 0)
                                    local maxStack = itemRes and itemRes.data and itemRes.data.maxStackSize
                                    if maxStack and maxStack > 1 and maxStack < 65536 then
                                        local newCount = m_floor(out.count * outMult + 0.5)
                                        if newCount < 1 then newCount = 1 end
                                        if newCount > maxStack then newCount = maxStack end
                                        out.count = newCount
                                    end
                                end
                            end
                        end)
                        didWork = true
                    end


                end
            end
        end
    end

    log_line("Crafting Configs: Master=" .. tostring(Enable_CraftingTweaks) .. " Unlock=" .. tostring(unlockRecipes) .. " Creative=" .. tostring(creativeMode) .. " FreeFood=" .. tostring(CraftingTweaks_FreeFood) .. " FreeFactories=" .. tostring(CraftingTweaks_FreeFactories) .. " FreeAltar=" .. tostring(CraftingTweaks_FreeFlameAltar) .. " OutMult=" .. tostring(outMult), 1)
    if unlockRecipes then
        log_line("Unlock All Recipes: Patched " .. tostring(unlockCount) .. " recipes.", 1)
    end
    if creativeMode then
        log_line("Creative Mode: Patched " .. tostring(creativeCount) .. " recipes.", 1)
    end
    if CraftingTweaks_FreeFood then
        log_line("Free Food: Patched " .. tostring(freeFoodCount) .. " recipes.", 1)
    end
    if CraftingTweaks_FreeFactories then
        log_line("Free Factories: Patched " .. tostring(freeFactoryCount) .. " recipes.", 1)
    end
    if CraftingTweaks_FreeFlameAltar then
        log_line("Free Altar: Patched " .. tostring(freeAltarCount) .. " recipes.", 1)
    end
    if outMult ~= 1.0 then
        log_line("Output Multiplier: Applied " .. tostring(outMult), 1)
    end

    feature_end(didWork)
end



local function ExecuteAllTweaks()
        log_line("Initializing Enshrouded Tweaks Unified Script...", 1)
    log_line("Config Status: NoIntro=" .. tostring(Enable_NoIntroVideo) .. " Levels=" .. tostring(Enable_PlayerItemLevelTweaks) .. " Attr=" .. tostring(Enable_AttributeScaling) .. " BaseStats=" .. tostring(Enable_PlayerBaseStats) .. " Dmg=" .. tostring(Enable_DamageTweaks) .. " Tools=" .. tostring(Enable_ToolTweaks) .. " Spells=" .. tostring(Enable_SpellTweaks) .. " Gear=" .. tostring(Enable_GearStatTweaks), 1)
    log_line("Config Status: Inv=" .. tostring(Enable_BackpackTweaks) .. " Stack=" .. tostring(Enable_StackSizeTweaks) .. " Chest=" .. tostring(Enable_ChestSizeTweaks) .. " Magic=" .. tostring(Enable_MagicFurniture) .. " Loot=" .. tostring(Enable_LootTweaks) .. " Gems=" .. tostring(Enable_GemTweaks) .. " Craft=" .. tostring(Enable_CraftingTweaks), 1)
    log_line("Config Status: FastTravel=" .. tostring(Enable_FastTravelTweaks) .. " FogWar=" .. tostring(Enable_FogOfWarTweaks) .. " Updraft=" .. tostring(Enable_SkillTweaks_Updraft) .. " Slope=" .. tostring(Enable_SlopeTweaks) .. " Fog=" .. tostring(Enable_FogTweaks) .. " Glider=" .. tostring(Enable_GliderTuning) .. " Terrain=" .. tostring(Enable_TerraformingTweaks), 1)
    
    ApplyNoIntroVideo()
    ApplyPlayerAttributes()
    ApplyPlayerBaseStats()
    ApplyPlayerItemLevelTweaks()
    ApplyEquipmentMultipliers()
    ApplyItemLevelMinimums()
    ApplySpellTweaks()
        ApplyGearStatTweaks()
    ApplyInventoryTweaks()
    ApplyStackSizeTweaks()
    ApplyExtendedMagicStorage()
    ApplyLootTweaks()
    ApplyGemTweaks()
    ApplyCraftingTweaks()
    ApplyGliderTuning()
    SlopeTweaks()
    ApplyFastTravelTweaks()
    ApplyFogTweaks()
    ApplyUpdraftTweaks()
    ApplyFlameAltarTweaks()
    ApplyBaseSizeTweaks()
    BuildingTweaks()
    ApplyTerraformingTweaks()
    ApplyTerrainDropTweaks()
    ApplyExpandedGameSettings()
    
    log_line("Initialization Complete.", 1)
end

-- Run everything
ExecuteAllTweaks()

-- ============================================================================
