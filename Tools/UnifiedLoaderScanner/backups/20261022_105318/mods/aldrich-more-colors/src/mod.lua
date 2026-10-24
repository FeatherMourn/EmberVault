-- More Character Colors (EML)
-- Runs once before the game starts and edits data (no runtime).
--
-- Where the game keeps the colors:
--   keen::FbUiBundle.characterCustomizationOptions  -> swatches shown in the UI
--     skinColors / eyeColors / eyeBrowColors : colorPresetId + color + uiDisplayColor
--     hairColors                              : colorPresetId + colorGradient (texture) + uiDisplayColor
--   keen::CharacterPresetCollection                 -> what the character actually renders
--     colors          : colorPresetId -> color (skin, eyes, eyebrows) or colorGradient (hair, beard)
--     knowledgeUnlocks: options locked behind in-game unlocks
-- (Game 1.0 layout. Before 1.0 the ids were colorOptionId/presetId/paletteColorId and gradients had their own list.)
-- The save only stores the u32 ids, so new ids are derived from fixed names:
-- renaming or removing an entry below makes characters using it fall back.

-- =============================================================================
-- CONFIGURATION
-- =============================================================================

-- Show the 9 eye and 14 hair colors the game hides until unlocked in-game.
UnlockVanillaColors = true

-- Show the hairstyles, beards and voices the game hides until unlocked in-game.
UnlockVanillaStyles = true

-- How the swatch color (hex, as seen on screen) maps to the rendered color.
-- Calibrated against vanilla entries; tweak if new colors look off in-game.
SkinGamma = 1.5     -- vanilla skin sits between sRGB and linear
EyeGamma = 1.0      -- vanilla eyes use the swatch value as-is
-- Eyebrows use exact sRGB -> linear (matches vanilla closely).

-- Hair gradients copy the root-to-tip shading of this vanilla gradient (copper).
HairReferencePresetId = 592270785

-- Most swatches per skin / eye / eyebrow list, vanilla included. 55 is tested; 65 crashes on start
-- ("No allocator set in BaseDynamicArray"). Extra entries are skipped.
MaxColorsPerList = 55

-- Each list: { "name", "#RRGGBB" }. Name is the save id: don't rename.
NewSkinColors = {
    { "porcelain",      "#F6E3D4" },
    { "ivory",          "#EED5BE" },
    { "rosy_beige",     "#E8C0A8" },
    { "peach",          "#F0B896" },
    { "light_olive",    "#C9A27A" },
    { "olive",          "#A88458" },
    { "cinnamon",       "#B97A50" },
    { "caramel",        "#A0623A" },
    { "bronze",         "#8A5530" },
    { "chestnut",       "#6E4026" },
    { "ebony",          "#3E2418" },
    { "deep_ebony",     "#2A1710" },
    { "pale_elf",       "#CFD8E0" },
    { "undead_ash",     "#9AA0A0" },
    { "orc_green",      "#6F8F4E" },
    { "moss_green",     "#4E6B3A" },
    { "ice_blue",       "#7FA6C8" },
    { "night_blue",     "#3E5A86" },
    { "arcane_purple",  "#7A5A9A" },
    { "demon_red",      "#9A3A30" },
    -- Fantasy races
    { "drow_obsidian",  "#2B2A3A" },
    { "drow_slate",     "#4A4A63" },
    { "moon_elf",       "#E6E9F2" },
    { "wood_elf",       "#8A6A45" },
    { "dryad_green",    "#9CC48A" },
    { "goblin_lime",    "#A4C24A" },
    { "black_orc",      "#3A4A2A" },
    { "ork_waaagh",     "#5C7A2E" },
    { "ogre_grey",      "#8C8A78" },
    { "troll_teal",     "#4F8A80" },
    { "nurgle_rot",     "#8A9A5A" },
    { "khorne_crimson", "#8A1A1A" },
    { "slaanesh_lilac", "#C8A0D8" },
    { "tzeentch_azure", "#3A6AC8" },
    { "vampire_pallor", "#D8D4D8" },
    { "stone_golem",    "#7A746C" },
    { "sea_nymph",      "#6FC8C0" },
    { "frost_giant",    "#B8D8EC" },
    { "fire_salamander","#D8602A" },
    { "saurus_jade",    "#4A8A5A" },
}

NewEyeColors = {
    { "amber",          "#C88A1E" },
    { "hazel",          "#8A6A2E" },
    { "honey",          "#B5832F" },
    { "emerald",        "#1F9A4A" },
    { "olive_green",    "#6B7B2E" },
    { "jade",           "#3FA68A" },
    { "sky_blue",       "#5FA8E0" },
    { "sapphire",       "#1F4FB5" },
    { "turquoise",      "#2FB8C0" },
    { "bright_cyan",    "#20E0FF" },
    { "storm_grey",     "#6A7480" },
    { "silver",         "#C0C6CC" },
    { "violet",         "#8A4FC8" },
    { "lilac",          "#B48AD8" },
    { "pink",           "#E07AA8" },
    { "crimson",        "#B01E2E" },
    { "blood_red",      "#7A0A10" },
    { "fire_orange",    "#F06A10" },
    { "gold",           "#E8C030" },
    { "milky_white",    "#E8ECEF" },
    -- Fantasy / glowing
    { "moonsilver",     "#DDE8FF" },
    { "fey_green",      "#7CFF6A" },
    { "warp_green",     "#39FF14" },
    { "void_black",     "#0A0A10" },
    { "chaos_magenta",  "#FF2AA0" },
    { "daemon_yellow",  "#FFE600" },
    { "wraith_blue",    "#8AE8FF" },
    { "abyss_violet",   "#5A10A0" },
    { "ember",          "#FF7A2A" },
    { "frost_white",    "#F0FAFF" },
    { "dragon_gold",    "#FFB400" },
    { "serpent_lime",   "#B8FF2A" },
    { "deep_sea",       "#0A6A8A" },
    { "nebula_pink",    "#FF8AD8" },
    { "ghost_teal",     "#6AFFD8" },
    { "ruby",           "#E0115F" },
    { "amethyst",       "#9966CC" },
    { "copper_eye",     "#C87533" },
    { "sunfire",        "#FFD27A" },
    { "blood_moon",     "#FF3A1A" },
}

-- Used for both hair (gradient) and eyebrows (flat color), so they can match.
-- The game holds at most 32 hair gradients and vanilla 1.0 uses 23, so only the first 9
-- become hair colors; all 40 become eyebrow colors.
NewHairColors = {
    { "platinum",       "#EDE4C8" },
    { "copper",         "#A8481E" },
    { "blue_black",     "#1A1E2C" },
    { "snow_white",     "#F4F4F4" },
    { "pastel_pink",    "#F0A0C0" },
    { "purple",         "#6A2A9A" },
    { "navy",           "#1E3A7A" },
    { "teal",           "#20B0A8" },
    { "forest",         "#2E6A2E" },
    { "fire_red",       "#C81E1E" },
    { "strawberry",     "#D9946A" },
    { "mahogany",       "#6E2A1E" },
    { "chocolate",      "#4A2C1C" },
    { "steel_grey",     "#6E747C" },
    { "fuchsia",        "#D02A8A" },
    { "lavender",       "#B49AE0" },
    { "sky",            "#6AB0E8" },
    { "mint",           "#8AE0B0" },
    { "yellow",         "#F0D020" },
    { "orange",         "#F07820" },
    -- Fantasy (eyebrows only: hair is full)
    { "moon_silver",    "#C9D1DE" },
    { "rose_gold",      "#D8A08A" },
    { "ember_red",      "#E0401A" },
    { "toxic_green",    "#6AE02A" },
    { "warp_purple",    "#8A30E0" },
    { "ice_blue",       "#A8DCF8" },
    { "abyss_blue",     "#102A6A" },
    { "blood_crimson",  "#7A0A1A" },
    { "gold_leaf",      "#D8B040" },
    { "jade",           "#2E9A6A" },
    { "magenta",        "#E020A0" },
    { "cyan",           "#20D8E8" },
    { "bone",           "#E0D8C0" },
    { "ash_grey",       "#8A8A8A" },
    { "ink_black",      "#0A0A0A" },
    { "sunset_orange",  "#F0602A" },
    { "nurgle_olive",   "#6A7A2A" },
    { "tzeentch_teal",  "#1A8AA0" },
    { "khorne_brass",   "#B08A3A" },
    { "lilac_frost",    "#C8B0F0" },
}

-- =============================================================================

local TAG = "[MoreColors] "
local MAX_HAIR_GRADIENTS = 32
local NO_GRADIENT = "00000000-0000-0000-0000-000000000000"

local ALWAYS = {
    knowledgeOrQueryId = { value = 0 },
    compareValue = 0,
    compareOperator = "GreaterThan",
    type = "Extern",
    isExplicitPlayerKnowledgeQuery = false,
}

local function hex_rgb(hex)
    local r, g, b = hex:match("^#(%x%x)(%x%x)(%x%x)$")
    assert(r, TAG .. "bad hex color: " .. tostring(hex))
    return tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)
end

local function srgb_to_lin(c8)
    local c = c8 / 255
    if c <= 0.04045 then return c / 12.92 end
    return ((c + 0.055) / 1.055) ^ 2.4
end

local function lin_to_srgb8(x)
    x = math.max(0, math.min(1, x))
    local s = x <= 0.0031308 and x * 12.92 or 1.055 * x ^ (1 / 2.4) - 0.055
    return math.floor(s * 255 + 0.5)
end

local function hdr(r, g, b) return { red = r, green = g, blue = b, intensity = 1 } end

local function ui_color(hex)
    local r, g, b = hex_rgb(hex)
    return hdr(r / 255, g / 255, b / 255)
end

local function gamma_color(hex, gamma)
    local r, g, b = hex_rgb(hex)
    return hdr((r / 255) ^ gamma, (g / 255) ^ gamma, (b / 255) ^ gamma)
end

local function lin_color(hex)
    local r, g, b = hex_rgb(hex)
    return hdr(srgb_to_lin(r), srgb_to_lin(g), srgb_to_lin(b))
end

-- -----------------------------------------------------------------------------

local bundle
for _, r in ipairs(game.assets.get_resources_by_type("keen::FbUiBundle")) do
    local ok, opts = pcall(function() return r.data.characterCustomizationOptions end)
    if ok and opts and #opts.skinColors > 0 then bundle = opts break end
end
local collection = game.assets.get_resources_by_type("keen::CharacterPresetCollection")[1]
if not bundle or not collection then
    print(TAG .. "ERROR: customization data not found (game update?). Nothing changed.")
    return
end
collection = collection.data

-- Every id already in use, so a new one never shadows a vanilla color.
local used = {}
local gradients_in_use = 0
for _, c in ipairs(collection.colors) do
    used[c.colorPresetId.value] = true
    if tostring(c.colorGradient) ~= NO_GRADIENT then gradients_in_use = gradients_in_use + 1 end
end

-- Game arrays can't grow in place; rebuild and assign the whole field.
local function append(owner, field, items)
    local t = {}
    for _, v in ipairs(owner[field]) do t[#t + 1] = v end
    for _, v in ipairs(items) do t[#t + 1] = v end
    owner[field] = t
end

local function new_id(category, name)
    local id = hasher.fnv1a32("aldrich-more-colors/" .. category .. "/" .. name)
    assert(not used[id], TAG .. "id collision for " .. category .. "/" .. name)
    used[id] = true
    return id
end

-- --- Unlock hidden vanilla options -------------------------------------------

local unlocked = {}
local unlocked_by_list = {}
local function unlock(field, id_of)
    local n = 0
    for _, e in ipairs(bundle[field]) do
        if e.knowledgeRequirementQuery.knowledgeOrQueryId.value ~= 0 then
            e.knowledgeRequirementQuery = ALWAYS
            if id_of then unlocked[id_of(e)] = true end
            n = n + 1
        end
    end
    unlocked_by_list[#unlocked_by_list + 1] = field .. " " .. n
end

if UnlockVanillaColors then
    local preset_id = function(e) return e.colorPresetId.value end
    for _, field in ipairs({ "skinColors", "eyeColors", "eyeBrowColors", "hairColors" }) do
        unlock(field, preset_id)
    end
end
if UnlockVanillaStyles then
    for _, field in ipairs({ "hairItems", "beardItems", "voices" }) do unlock(field) end
end
-- Rewrite the lock in place: removing entries from knowledgeUnlocks crashes the game.
-- Styles have no id here to match, so they take every lock that isn't a color's.
local styles_unlocked = 0
for _, k in ipairs(collection.knowledgeUnlocks) do
    local id = k.optionId.value
    if unlocked[id] then
        k.knowledgeQuery = ALWAYS
    elseif UnlockVanillaStyles and not used[id] then
        k.knowledgeQuery = ALWAYS
        styles_unlocked = styles_unlocked + 1
    end
end
print(TAG .. "unlocked per list: " .. table.concat(unlocked_by_list, ", ")
    .. string.format("; %d of %d preset locks are non-color", styles_unlocked, #collection.knowledgeUnlocks))

-- --- Flat colors (skin, eyes, eyebrows) --------------------------------------

local function add_flat(field, category, entries, to_color)
    local ui, palette = {}, {}
    local room = math.max(0, MaxColorsPerList - #bundle[field])
    if room < #entries then
        print(TAG .. string.format("only %d of %d new %s colors fit (MaxColorsPerList %d)", room, #entries, category, MaxColorsPerList))
    end
    for i, e in ipairs(entries) do
        if i > room then break end
        local id = new_id(category, e[1])
        local color = to_color(e[2])
        ui[#ui + 1] = {
            knowledgeRequirementQuery = ALWAYS,
            colorPresetId = { value = id },
            color = color,
            uiDisplayColor = ui_color(e[2]),
        }
        palette[#palette + 1] = { colorPresetId = { value = id }, color = color, colorGradient = NO_GRADIENT }
    end
    append(bundle, field, ui)
    append(collection, "colors", palette)
end

add_flat("skinColors", "skin", NewSkinColors, function(h) return gamma_color(h, SkinGamma) end)
add_flat("eyeColors", "eye", NewEyeColors, function(h) return gamma_color(h, EyeGamma) end)
add_flat("eyeBrowColors", "brow", NewHairColors, lin_color)

-- --- Hair gradients ----------------------------------------------------------
-- Vanilla gradients: 256x1 RGBA8 sRGB texture, full mip chain (9 levels, raw).

local ref_guid
for _, c in ipairs(collection.colors) do
    if c.colorPresetId.value == HairReferencePresetId then ref_guid = c.colorGradient end
end
local ref_tex = ref_guid and game.assets.get_resource(ref_guid, "keen::RenderTextureResource")
if not ref_tex then
    print(TAG .. "ERROR: reference hair gradient not found; skipping new hair colors.")
else
    ref_tex = ref_tex.data
    local W = ref_tex.width
    local data = game.assets.get_content(ref_tex.content.hash):read_data()
    -- Brightness of each pixel relative to the tip: the shading we re-tint.
    local shade = {}
    for x = 1, W do
        local r, g, b = data:read_u8(), data:read_u8(), data:read_u8()
        data:read_u8()
        shade[x] = (srgb_to_lin(r) + srgb_to_lin(g) + srgb_to_lin(b)) / 3
    end
    local tip = shade[W]
    for x = 1, W do shade[x] = shade[x] / tip end

    -- More than 32 colorGradients crashes the game on start ("No allocator set in BaseDynamicArray").
    local room = math.max(0, MAX_HAIR_GRADIENTS - gradients_in_use)
    if room < #NewHairColors then
        print(TAG .. string.format("only %d of %d new hair colors fit (game limit %d gradients)", room, #NewHairColors, MAX_HAIR_GRADIENTS))
    end
    local ui, gradients = {}, {}
    for i, e in ipairs(NewHairColors) do
        if i > room then break end
        local id = new_id("hair", e[1])
        local tr, tg, tb = hex_rgb(e[2])
        tr, tg, tb = srgb_to_lin(tr), srgb_to_lin(tg), srgb_to_lin(tb)

        local level = {}
        for x = 1, W do level[x] = { tr * shade[x], tg * shade[x], tb * shade[x] } end
        local buf = buffer.create(W * 8)  -- >= the full mip chain (W*4 + W*2 + ... bytes)
        for _ = 1, ref_tex.levelCount do
            for x = 1, #level do
                local p = level[x]
                buf:write_u8(lin_to_srgb8(p[1]))
                buf:write_u8(lin_to_srgb8(p[2]))
                buf:write_u8(lin_to_srgb8(p[3]))
                buf:write_u8(255)
            end
            local next_level = {}
            for x = 1, math.max(1, #level // 2) do
                local a, b = level[2 * x - 1], level[2 * x] or level[2 * x - 1]
                next_level[x] = { (a[1] + b[1]) / 2, (a[2] + b[2]) / 2, (a[3] + b[3]) / 2 }
            end
            level = next_level
        end

        local content = game.assets.create_content(buf)
        local tex = game.assets.create_resource({
            width = ref_tex.width, height = ref_tex.height, depth = ref_tex.depth,
            layerCount = ref_tex.layerCount, levelCount = ref_tex.levelCount,
            type = ref_tex.type, format = ref_tex.format, channelMapping = ref_tex.channelMapping,
            content = {
                hash = { size = content.size, hash0 = content.hash0, hash1 = content.hash1, hash2 = content.hash2 },
                category = ref_tex.content.category, bundleId = ref_tex.content.bundleId, sortKey = ref_tex.content.sortKey,
            },
            mipChainContentRanges = {},
            bindless = ref_tex.bindless, isTiled = ref_tex.isTiled,
            debugName = "Color Gradient more-colors " .. e[1],
        }, "keen::RenderTextureResource")

        ui[#ui + 1] = {
            knowledgeRequirementQuery = ALWAYS,
            colorPresetId = { value = id },
            colorGradient = tex.guid,
            uiDisplayColor = ui_color(e[2]),
        }
        gradients[#gradients + 1] = { colorPresetId = { value = id }, color = hdr(0, 0, 0), colorGradient = tex.guid }
    end
    append(bundle, "hairColors", ui)
    append(collection, "colors", gradients)
end

local n = 0
for _ in pairs(unlocked) do n = n + 1 end
print(TAG .. string.format("unlocked %d vanilla colors; now skin %d, eyes %d, eyebrows %d, hair %d",
    n, #bundle.skinColors, #bundle.eyeColors, #bundle.eyeBrowColors, #bundle.hairColors))

-- With "export" enabled, dump the result so it can be checked without the game.
if loader.features.export then
    io.export("more-colors/options.txt", tostring(bundle))
    io.export("more-colors/collection.txt", tostring(collection))
end
