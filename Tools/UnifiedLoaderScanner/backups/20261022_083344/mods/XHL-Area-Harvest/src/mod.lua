-- XHL Area Harvest 1.0 resource contract, v1.0.1.
-- Read-only: verifies player-planted growth chains and stock harvest markers.
-- 1.0 uses InteractionOfferRuntime.defaultVerbId/defaultSequence (HashKey32).
-- Seedlings sharing the fast action remain excluded by their Repot verb.
-- Mature one-shot crops use DefaultInventory; refill trees use InventorySetup.
-- Native companion keeps refill harvesting disabled.

local TAG = "[XHL-Area-Harvest]"
local VERSION = "1.0.1"
local VALIDATED_BUILDS = "1267041,1269579"
local CONTRACT_VERSION = "xhl-area-harvest-contract-v2"
local AREA_SIZE_METERS = 5.0

local GUID = {
    actionFastLoot = "0c4ff0cd-799e-4211-90b1-a3f04226e517",
    actionSlowLoot = "19bdf62c-d4ca-4fe8-825b-f727fee80d27",
    actionNone = "00000000-0000-0000-0000-000000000000",
    verbHarvest = "434ff371-ceb6-4067-b897-81219b1c113d",
    verbCollect = "5ae6345f-1226-4718-9108-ec80e2d0360b",
    verbRefillHarvest = "91161d96-c154-4cf8-9555-0560321b4260",
    verbRepot = "61e6115c-226b-44c5-a51c-358d5e64432d",
}

local TYPE = {
    interactionOffer = "keen::ecs::InteractionOfferRuntime",
    destroyOnLoot = "keen::ecs::DestroyOnLoot",
    interactionLootRefill = "keen::ecs::InteractionLootRefill",
    defaultInventory = "keen::ecs::DefaultInventory",
    inventory = "keen::ecs::InventorySetup",
    miningNode = "keen::ecs::MiningNode",
    upgrade = "keen::ecs::Upgrade",
}

local DEFAULT_CONFIG = {
    enabled = true,
}

-- Exactly 28 player-planted crop families in the supported contract:
-- 23 canonical mature stages are one-shot DestroyOnLoot harvests, while five
-- fruit/nut families use the stock InteractionLootRefill path.
local FAMILIES = {
    {
        baseName = "T3_Plant_Growth_SugarCane",
        baseGuid = "0727b3cc-cda4-43be-a60a-04700175e516",
        canonicalName = "T3_Plant_Growth_SugarCane_Seedling_2_harvest",
        canonicalGuid = "5b2ec4fc-1339-4d53-a4f4-4df22e0bea50",
        kind = "destroy",
    },
    {
        baseName = "T2_Plant_Growth_Beets",
        baseGuid = "11767fc9-33c9-4fa2-886b-52a9c6c9d8bf",
        canonicalName = "T2_Plant_Growth_Beets_Seedling_2_harvest",
        canonicalGuid = "2048f09e-56b1-465d-acb3-677fcc8f9731",
        kind = "destroy",
    },
    {
        baseName = "T2_Plant_Growth_Strawberry",
        baseGuid = "15829af2-4578-4ab1-a492-8ec716ae2090",
        canonicalName = "T2_Plant_Growth_Strawberry_Seedling_2_harvest",
        canonicalGuid = "92a6a273-60f5-4bb7-b170-c33ff1a213e2",
        kind = "destroy",
    },
    {
        baseName = "T2_Plant_Growth_Nettle",
        baseGuid = "1814d593-a4b7-44a4-85e8-db02772da748",
        canonicalName = "T2_Plant_Growth_Nettle_Seedling_2_harvest",
        canonicalGuid = "d9a6a5a3-a73d-4bb3-b046-6d431fbf8159",
        kind = "destroy",
    },
    {
        baseName = "T3_Plant_Growth_Pepper",
        baseGuid = "1a445e1b-794c-47f0-b91e-28647e487e09",
        canonicalName = "T3_Plant_Growth_Pepper_Seedling_2_harvest",
        canonicalGuid = "88e563b5-cbc6-4963-8b1e-6beda9c57cf1",
        kind = "destroy",
    },
    {
        baseName = "T4_Plant_Growth_Saffron",
        baseGuid = "1a86d69d-2f06-4348-b5a9-a49d12f21f21",
        canonicalName = "T4_Plant_Growth_Saffron_Seedling_2_harvest",
        canonicalGuid = "1cb3cec9-f754-4ebe-b51f-76dc6589ab68",
        kind = "destroy",
    },
    {
        baseName = "T1_Plant_Growth_Mushrooms_Red",
        baseGuid = "21ea3964-8ef1-4313-aed4-7127d3366c31",
        canonicalName = "T1_Plant_Growth_Mushroom_2_harvest",
        canonicalGuid = "a86475f5-ad7b-4c84-8606-3b400dc79d91",
        kind = "destroy",
    },
    {
        baseName = "T2_Plant_Growth_Indigo",
        baseGuid = "28f0b8ed-fdd9-4831-bda6-8682fd37e2e6",
        canonicalName = "T2_Plant_Growth_Indigo_Seedling_2_harvest",
        canonicalGuid = "fbcc87cb-e965-4fd7-95c1-baa84ede5e70",
        kind = "destroy",
    },
    {
        baseName = "T3_Plant_Growth_Flax",
        baseGuid = "29315e3d-b84f-4468-8329-cdc46adac6e8",
        canonicalName = "T3_Plant_Growth_Flax_Seedling_2_harvest",
        canonicalGuid = "91118183-82ec-4b29-906a-4580f95354c0",
        kind = "destroy",
    },
    {
        baseName = "T1_Plant_Growth_Tomato",
        baseGuid = "33ae9de5-7cae-4105-a448-172f0e7681af",
        canonicalName = "T1_Plant_Growth_Tomato_Seedling_2_harvest",
        canonicalGuid = "5e4aa3d9-82dc-4db2-9017-3741fb7aa441",
        kind = "destroy",
    },
    {
        baseName = "T4_Plant_Growth_DevilsClaw",
        baseGuid = "39fd1b83-bb42-44e8-b520-7aaad2226ef4",
        canonicalName = "T4_Plant_Growth_DevilsClaw_Seedling_2_harvest",
        canonicalGuid = "41048895-751c-458d-aeae-59266b768abe",
        kind = "destroy",
    },
    {
        baseName = "T3_Plant_Growth_Sage",
        baseGuid = "52481826-366d-481c-8e56-15ccdbd78163",
        canonicalName = "T3_Plant_Growth_Sage_Seedling_2_harvest",
        canonicalGuid = "aa32df6a-4d53-4525-b4d6-3626f3e2249a",
        kind = "destroy",
    },
    {
        baseName = "T1_Plant_Growth_Corn",
        baseGuid = "7361d73a-8697-43de-b502-52f36f20c0ba",
        canonicalName = "T1_Plant_Growth_Corn_2_harvest",
        canonicalGuid = "23a51c55-0ec4-4ea4-9d77-b7675c6e90d3",
        kind = "destroy",
    },
    {
        baseName = "T1_Plant_Growth_St_Johns_Worth",
        baseGuid = "75ce285a-1329-47a4-984c-2c3e6014d9a9",
        canonicalName = "T1_Plant_Growth_St_Johns_Worth_Seedling_2_harvest",
        canonicalGuid = "fe5b1d32-9457-4a7d-9ae3-47bec3a6302c",
        kind = "destroy",
    },
    {
        baseName = "T1_Plant_Growth_BerryBushes",
        baseGuid = "8d14d8f0-cce6-4ae8-ba50-445fabd14cc6",
        canonicalName = "T2_Plant_Growth_BerryBush_3_harvest",
        canonicalGuid = "0f27f2bd-d7e2-48d3-baa5-0c107a7eedb1",
        kind = "destroy",
    },
    {
        baseName = "T2_Plant_Growth_AzureRussula_GlowShroom",
        baseGuid = "8fa7dce5-dd8c-463b-a9d9-e4859a3dcf7a",
        canonicalName = "T2_Plant_Growth_AzureRussula_GlowShroom_Seedling_2_harvest",
        canonicalGuid = "ea3da738-dc81-4149-8bec-7435f1860b5d",
        kind = "destroy",
    },
    {
        baseName = "T5_Plant_Growth_Tentacle_ShroudAdhesive",
        baseGuid = "9467ac7c-b659-43c1-8ef6-95f11d77fef6",
        canonicalName = "T5_Plant_Growth_Tentacle_ShroudAdhesive_3_harvest_animated",
        canonicalGuid = "393e2ac3-8c3c-4b1a-9d3d-33da79b82473",
        kind = "destroy",
    },
    {
        baseName = "T2_Plant_Growth_Chamomille",
        baseGuid = "a52053b4-2bd5-4578-94de-6dcae26a84dc",
        canonicalName = "T2_Plant_Growth_Chamomille_Seedling_2_harvest",
        canonicalGuid = "c35d06d2-dae6-44b7-b99e-c3f8c4c6755b",
        kind = "destroy",
    },
    {
        baseName = "T1_Plant_Growth_PlantFibre_Shrub",
        baseGuid = "bf9b9653-6097-40db-bab4-8319c68aec5f",
        canonicalName = "T1_Plant_Growth_PlantFibre_Bush_Seedling_3_harvest",
        canonicalGuid = "4aa41262-d7d2-4f6a-9687-980bf11c949c",
        kind = "destroy",
    },
    {
        baseName = "T4_Plant_Growth_Desert_flower",
        baseGuid = "ce37554c-52be-4716-bcfd-bbd9dbd1a6d7",
        canonicalName = "T4_Plant_Growth_Desert_Flower_Seedling_2_harvest",
        canonicalGuid = "7d802f75-9a60-4670-a5f0-9393deeca6a4",
        kind = "destroy",
    },
    {
        baseName = "T5_Plant_Growth_Wolfsbane",
        baseGuid = "cf219fc5-342c-4100-a101-8b74b9af3f25",
        canonicalName = "T5_Plant_Growth_Wolfsbane_2_harvest",
        canonicalGuid = "ce9f6b5e-9600-40ed-8fc8-55192a3a205b",
        kind = "destroy",
    },
    {
        baseName = "T3_Plant_Growth_Rooibos",
        baseGuid = "e21bbc1a-b9ce-449a-8910-b7be75fd6f13",
        canonicalName = "T3_Plant_Growth_Rooibos_Seedling_2_harvest",
        canonicalGuid = "b31cd1b9-0918-49b8-8aa3-a550959272c8",
        kind = "destroy",
    },
    {
        baseName = "T5_Plant_Growth_Yellow_Gentian",
        baseGuid = "ed70fde0-eeae-48c4-ba36-e85951da5be5",
        canonicalName = "T5_Plant_Growth_Yellow_Gentian_2_harvest",
        canonicalGuid = "05d6093c-f05a-4f82-b29a-88e4ab484d34",
        kind = "destroy",
    },
    {
        baseName = "T6_Plant_Growth_Banana",
        baseGuid = "1f6f99be-47a3-41f0-a982-ac5930160244",
        canonicalName = "Scatter_Loot_Wetland_Above_Bananaplant_01_e_fruits_harvest_PlayerPlanted_Refill",
        canonicalGuid = "7105ee61-f16b-46e1-a315-dbacc971ca18",
        kind = "refill",
    },
    {
        baseName = "T6_Plant_Growth_Coffee",
        baseGuid = "98141c46-2772-4da8-be85-518e27a3e506",
        canonicalName = "Scatter_Loot_Wetland_Coffeetree_d_fruits_harvest_Playerplanted_Refill",
        canonicalGuid = "d23ecd82-83a9-4d01-a6a4-14adbc1e1315",
        kind = "refill",
    },
    {
        baseName = "T2_Plant_Growth_Hazelnut_bush",
        baseGuid = "aa0d6061-54f0-4aed-9308-1b6ffb74cefd",
        canonicalName = "Scatter_Loot_DeepWoods_Hazelnut_d_nuts_harvest_Playerplanted_Refill",
        canonicalGuid = "f47fa06b-7320-443f-9c54-0917aafc9387",
        kind = "refill",
    },
    {
        baseName = "T4_Plant_Growth_DatePalm",
        baseGuid = "e538ce49-1f93-4545-a4a9-03e226a54798",
        canonicalName = "Scatter_Loot_Desert_Above_Datepalm_01_e_fruits_harvest_PlayerPlanted_Refill",
        canonicalGuid = "133919d1-e838-4fbc-b2dc-6d3dafefd21f",
        kind = "refill",
    },
    {
        baseName = "T6_Plant_Growth_Coconut",
        baseGuid = "9d633060-e818-4c6c-ad85-470ea9444ff6",
        canonicalName = "Scatter_Loot_Wetland_Above_Coconutpalm_01_e_fruits_harvest_PlayerPlanted_Refill",
        canonicalGuid = "320835c4-62a8-4fbf-8f8e-76d733596e35",
        kind = "refill",
    },
}

local ALOE_EXCLUSIONS = {
    {
        name = "Scatter_Loot_Steppes_Above_Aloe_01_b_harvest_small",
        guid = "db56a9c2-7608-4d22-beae-2213db455fbd",
    },
    {
        name = "Scatter_Loot_Steppes_Above_Aloe_01_c_harvest",
        guid = "b67b12c9-a733-4c0b-a9d2-938a8208fb61",
    },
}

local function safe_get(object, key)
    if object == nil then
        return nil
    end
    local ok, value = pcall(function()
        return object[key]
    end)
    if ok then
        return value
    end
    return nil
end

local function text(value)
    if value == nil then
        return ""
    end
    local ok, result = pcall(function()
        return tostring(value)
    end)
    if ok then
        return result
    end
    return "<error>"
end

local function trim(value)
    local result = text(value):gsub("^%s+", ""):gsub("%s+$", "")
    return result
end

local function clean(value)
    local result = text(value):gsub("[\t\r\n]", " ")
    return result
end

local function parse_bool(value, fallback)
    local normalized = trim(value):lower()
    if normalized == "true" or normalized == "1" or normalized == "yes" or normalized == "on" then
        return true
    end
    if normalized == "false" or normalized == "0" or normalized == "no" or normalized == "off" then
        return false
    end
    return fallback
end

local function load_config()
    local config = {}
    for key, value in pairs(DEFAULT_CONFIG) do
        config[key] = value
    end

    if not io.exists("config.txt") then
        return config
    end

    local content = io.read_to_string("config.txt")
    if content == nil then
        return config
    end

    for line in content:gmatch("[^\r\n]+") do
        local cleaned = trim(line)
        if cleaned ~= "" and not cleaned:match("^[#;]") then
            local key, raw_value = cleaned:match("^([^=]+)=(.*)$")
            if key and raw_value then
                key = trim(key)
                raw_value = trim(raw_value:match("^[^#;]*") or raw_value)
                if key == "enabled" then
                    config[key] = parse_bool(raw_value, config[key])
                end
            end
        end
    end
    return config
end

local function find_component(data, wanted_type)
    local components = safe_get(data, "components")
    if components == nil then
        return nil, nil
    end
    for _, component in ipairs(components) do
        if text(safe_get(component, "type")) == wanted_type then
            return component, safe_get(component, "value")
        end
    end
    return nil, nil
end

local function has_component(data, wanted_type)
    local component = find_component(data, wanted_type)
    return component ~= nil
end

local function protected_export(filename, payload)
    local ok, err = pcall(function()
        io.export(filename, payload)
    end)
    if not ok then
        local error_text = text(err)
        if error_text:find("exporting is disabled", 1, true) then
            print(TAG .. " export skipped (disabled): " .. filename)
        else
            warn(TAG .. " export failed " .. filename .. ": " .. error_text)
        end
    end
end

local config = load_config()
if not config.enabled then
    print(TAG .. " disabled")
    return
end

local half_extent_meters = AREA_SIZE_METERS / 2.0

local templates = game.assets.get_resources_by_type("keen::ecs::TemplateResource")
local data_by_guid = {}
local name_by_guid = {}

for _, resource in ipairs(templates) do
    local guid = text(safe_get(resource, "guid"))
    local data = safe_get(resource, "data")
    if guid ~= "" and data ~= nil then
        data_by_guid[guid] = data
        name_by_guid[guid] = text(safe_get(data, "name"))
    end
end

local function interaction_evidence(guid)
    local data = data_by_guid[guid]
    if data == nil then
        return {
            guid = guid,
            name = "",
            eligible = false,
            reason = "missing_template",
        }
    end

    local offer_component, offer = find_component(data, TYPE.interactionOffer)
    -- 1.0 templates store FNV HashKey32 IDs in InteractionOfferRuntime.
    -- Resolve only the known stock markers; unknown IDs stay ineligible.
    local verb_id = tonumber(safe_get(safe_get(offer, "defaultVerbId"), "value")) or 0
    local sequence_id = tonumber(safe_get(safe_get(offer, "defaultSequence"), "value")) or 0
    local verb = "hash32:" .. tostring(verb_id)
    local action = sequence_id == 0 and GUID.actionNone or ("hash32:" .. tostring(sequence_id))
    for _, key in ipairs({"verbHarvest", "verbCollect", "verbRefillHarvest", "verbRepot"}) do
        if verb_id == game.guid.hash(GUID[key]) then verb = GUID[key] end
    end
    for _, key in ipairs({"actionFastLoot", "actionSlowLoot"}) do
        if sequence_id == game.guid.hash(GUID[key]) then action = GUID[key] end
    end
    local has_destroy = has_component(data, TYPE.destroyOnLoot)
    local has_refill = has_component(data, TYPE.interactionLootRefill)
    local has_default_inventory = has_component(data, TYPE.defaultInventory)
    local has_inventory = has_component(data, TYPE.inventory)

    local marker_class = ""
    local eligible_kind = ""
    if offer_component == nil then
        marker_class = "missing_InteractionOffer"
    elseif verb == GUID.verbRepot then
        marker_class = "repot_rejected"
    elseif verb == GUID.verbHarvest and action == GUID.actionFastLoot
        and has_destroy and has_default_inventory and not has_refill
    then
        marker_class = "harvest_fast"
        eligible_kind = "destroy"
    elseif verb == GUID.verbCollect and action == GUID.actionSlowLoot
        and has_destroy and has_default_inventory and not has_refill
    then
        marker_class = "harvest_slow_collect"
        eligible_kind = "destroy"
    elseif verb == GUID.verbRefillHarvest and action == GUID.actionNone
        and has_refill and has_inventory and not has_destroy
    then
        marker_class = "harvest_refill"
        eligible_kind = "refill"
    else
        marker_class = "interaction_not_harvest_contract"
    end

    return {
        guid = guid,
        name = name_by_guid[guid] or "",
        eligible = eligible_kind ~= "",
        kind = eligible_kind,
        markerClass = marker_class,
        hasInteractionOffer = offer_component ~= nil,
        verb = verb,
        action = action,
        hasDestroyOnLoot = has_destroy,
        hasInteractionLootRefill = has_refill,
        hasDefaultInventory = has_default_inventory,
        hasInventory = has_inventory,
        reason = marker_class,
    }
end

local runtime_entries = {}
local runtime_by_guid = {}
local repot_candidates_rejected = 0

local function add_runtime_entry(family_index, family, guid, source)
    if runtime_by_guid[guid] ~= nil then
        return runtime_by_guid[guid]
    end
    local evidence = interaction_evidence(guid)
    if evidence.markerClass == "repot_rejected" then
        repot_candidates_rejected = repot_candidates_rejected + 1
        return nil
    end
    if not evidence.eligible then
        return nil
    end
    local entry = {
        familyIndex = family_index,
        familyName = family.baseName,
        familyKind = family.kind,
        source = source,
        evidence = evidence,
    }
    runtime_entries[#runtime_entries + 1] = entry
    runtime_by_guid[guid] = entry
    return entry
end

local failures = 0
local destroy_families = 0
local refill_families = 0
local family_rows = {
    table.concat({
        "familyIndex",
        "baseName",
        "baseGuid",
        "kind",
        "canonicalName",
        "canonicalGuid",
        "canonicalMarkerClass",
        "canonicalVerb",
        "canonicalAction",
        "hasInteractionOffer",
        "hasInventoryEvidence",
        "hasDestroyOnLoot",
        "hasInteractionLootRefill",
        "eligibleStageCount",
        "eligibleStageGuids",
        "status",
        "detail",
    }, "\t"),
}

for family_index, family in ipairs(FAMILIES) do
    if family.kind == "destroy" then
        destroy_families = destroy_families + 1
    elseif family.kind == "refill" then
        refill_families = refill_families + 1
    end

    local base_data = data_by_guid[family.baseGuid]
    local base_name = name_by_guid[family.baseGuid] or ""
    local detail_parts = {}
    local status = "verified"

    if base_data == nil then
        status = "failed"
        detail_parts[#detail_parts + 1] = "missing_base_template"
    elseif base_name ~= family.baseName then
        status = "failed"
        detail_parts[#detail_parts + 1] = "base_name_mismatch:" .. base_name
    else
        local _, upgrade = find_component(base_data, TYPE.upgrade)
        local levels = safe_get(upgrade, "levels")
        if levels == nil then
            status = "failed"
            detail_parts[#detail_parts + 1] = "missing_upgrade_levels"
        else
            for _, level in ipairs(levels) do
                local stage_guid = text(safe_get(level, "upgradeEntity"))
                if stage_guid ~= "" then
                    local stage_evidence = interaction_evidence(stage_guid)
                    if stage_evidence.markerClass == "repot_rejected" then
                        repot_candidates_rejected = repot_candidates_rejected + 1
                    elseif stage_evidence.eligible then
                        add_runtime_entry(family_index, family, stage_guid, "growth-chain")
                    end
                end
            end
        end
    end

    -- Date palm's player-planted refill target is not referenced directly by
    -- its Upgrade list; adding every canonical target here also makes the
    -- canonical evidence independent of unusual chain layouts.
    add_runtime_entry(family_index, family, family.canonicalGuid, "canonical")

    local canonical = interaction_evidence(family.canonicalGuid)
    if canonical.name ~= family.canonicalName then
        status = "failed"
        detail_parts[#detail_parts + 1] = "canonical_name_mismatch:" .. canonical.name
    end
    if not canonical.eligible or canonical.kind ~= family.kind then
        status = "failed"
        detail_parts[#detail_parts + 1] = "canonical_evidence_mismatch:" .. canonical.markerClass
    end

    local eligible_guids = {}
    for _, entry in ipairs(runtime_entries) do
        if entry.familyIndex == family_index then
            eligible_guids[#eligible_guids + 1] = entry.evidence.guid
        end
    end
    table.sort(eligible_guids)
    if #eligible_guids == 0 then
        status = "failed"
        detail_parts[#detail_parts + 1] = "no_eligible_runtime_stage"
    end

    if status ~= "verified" then
        failures = failures + 1
    else
        detail_parts[#detail_parts + 1] = "strict_harvest_contract_ok"
    end

    family_rows[#family_rows + 1] = table.concat({
        tostring(family_index),
        family.baseName,
        family.baseGuid,
        family.kind,
        family.canonicalName,
        family.canonicalGuid,
        canonical.markerClass or "",
        canonical.verb or "",
        canonical.action or "",
        tostring(canonical.hasInteractionOffer == true),
        tostring((canonical.hasDefaultInventory or canonical.hasInventory) == true),
        tostring(canonical.hasDestroyOnLoot == true),
        tostring(canonical.hasInteractionLootRefill == true),
        tostring(#eligible_guids),
        table.concat(eligible_guids, ";"),
        status,
        table.concat(detail_parts, ";"),
    }, "\t")
end

table.sort(runtime_entries, function(left, right)
    if left.familyIndex ~= right.familyIndex then
        return left.familyIndex < right.familyIndex
    end
    return left.evidence.guid < right.evidence.guid
end)

local runtime_rows = {
    table.concat({
        "familyIndex",
        "familyName",
        "familyKind",
        "templateName",
        "templateGuid",
        "runtimeKind",
        "markerClass",
        "verbLoca",
        "defaultAction",
        "hasInteractionOffer",
        "hasInventoryEvidence",
        "hasDestroyOnLoot",
        "hasInteractionLootRefill",
        "source",
    }, "\t"),
}

local native_contract_lines = {
    "contractVersion=" .. CONTRACT_VERSION,
    "validatedBuilds=" .. VALIDATED_BUILDS,
    "areaSizeMeters=5.0",
    "halfExtentMeters=2.5",
    "shape=horizontal_square_xz",
    "trigger=stock_interact_E",
    "strictHarvestOnly=true",
    "verbHarvest=" .. GUID.verbHarvest,
    "verbCollect=" .. GUID.verbCollect,
    "verbRefillHarvest=" .. GUID.verbRefillHarvest,
    "verbRepotRejected=" .. GUID.verbRepot,
    "actionFastLoot=" .. GUID.actionFastLoot,
    "actionSlowLoot=" .. GUID.actionSlowLoot,
    "actionRefill=" .. GUID.actionNone,
    "nativeSupportedTemplates=35",
    "nativeRefillSupported=false",
    "interactionOfferComponent=" .. TYPE.interactionOffer,
    "verbHarvestId=" .. tostring(game.guid.hash(GUID.verbHarvest)),
    "verbCollectId=" .. tostring(game.guid.hash(GUID.verbCollect)),
    "verbRefillHarvestId=" .. tostring(game.guid.hash(GUID.verbRefillHarvest)),
    "verbRepotRejectedId=" .. tostring(game.guid.hash(GUID.verbRepot)),
    "actionFastLootId=" .. tostring(game.guid.hash(GUID.actionFastLoot)),
    "actionSlowLootId=" .. tostring(game.guid.hash(GUID.actionSlowLoot)),
}

local destroy_runtime_templates = 0
local refill_runtime_templates = 0
for _, entry in ipairs(runtime_entries) do
    local evidence = entry.evidence
    if evidence.kind == "destroy" then
        destroy_runtime_templates = destroy_runtime_templates + 1
    elseif evidence.kind == "refill" then
        refill_runtime_templates = refill_runtime_templates + 1
    end
    runtime_rows[#runtime_rows + 1] = table.concat({
        tostring(entry.familyIndex),
        entry.familyName,
        entry.familyKind,
        clean(evidence.name),
        evidence.guid,
        evidence.kind,
        evidence.markerClass,
        evidence.verb,
        evidence.action,
        tostring(evidence.hasInteractionOffer == true),
        tostring((evidence.hasDefaultInventory or evidence.hasInventory) == true),
        tostring(evidence.hasDestroyOnLoot == true),
        tostring(evidence.hasInteractionLootRefill == true),
        entry.source,
    }, "\t")
    native_contract_lines[#native_contract_lines + 1] = table.concat({
        "template",
        evidence.guid,
        evidence.kind,
        evidence.verb,
        evidence.action,
        entry.familyName,
        clean(evidence.name),
    }, "|")
end

local aloe_rows = {
    "templateName\ttemplateGuid\thasInteractionOffer\thasInventory\thasMiningNode\teligible\taloe_excluded_reason",
}
local aloe_excluded = true
for _, aloe in ipairs(ALOE_EXCLUSIONS) do
    local data = data_by_guid[aloe.guid]
    local actual_name = name_by_guid[aloe.guid] or ""
    local has_offer = data ~= nil and has_component(data, TYPE.interactionOffer)
    local has_inventory = data ~= nil and (has_component(data, TYPE.defaultInventory) or has_component(data, TYPE.inventory))
    local has_mining = data ~= nil and has_component(data, TYPE.miningNode)
    local evidence = interaction_evidence(aloe.guid)
    local excluded_ok = data ~= nil
        and actual_name == aloe.name
        and not has_offer
        and not has_inventory
        and has_mining
        and not evidence.eligible
    if not excluded_ok then
        aloe_excluded = false
        failures = failures + 1
    end
    aloe_rows[#aloe_rows + 1] = table.concat({
        clean(actual_name),
        aloe.guid,
        tostring(has_offer == true),
        tostring(has_inventory == true),
        tostring(has_mining == true),
        tostring(evidence.eligible == true),
        "no_InteractionOffer;MiningNode_only;not_E_harvest",
    }, "\t")
end

protected_export("xhl-area-harvest-family-manifest.tsv", table.concat(family_rows, "\n"))
protected_export("xhl-area-harvest-runtime-whitelist.tsv", table.concat(runtime_rows, "\n"))
protected_export("xhl-area-harvest-native-contract.txt", table.concat(native_contract_lines, "\n"))
protected_export("xhl-area-harvest-exclusions.tsv", table.concat(aloe_rows, "\n"))

local status = failures == 0 and "complete" or "contract-failed"
print(string.format(
    "%s v%s %s validatedBuilds=%s families=%d destroyFamilies=%d refillFamilies=%d runtimeTemplates=%d destroyRuntimeTemplates=%d refillRuntimeTemplates=%d repotCandidatesRejected=%d aloeExcluded=%s failures=%d area=%.1fmx%.1fm halfExtent=%.1fm marker=InteractionOfferRuntime.defaultVerbId",
    TAG,
    VERSION,
    status,
    VALIDATED_BUILDS,
    #FAMILIES,
    destroy_families,
    refill_families,
    #runtime_entries,
    destroy_runtime_templates,
    refill_runtime_templates,
    repot_candidates_rejected,
    tostring(aloe_excluded),
    failures,
    AREA_SIZE_METERS,
    AREA_SIZE_METERS,
    half_extent_meters
))
