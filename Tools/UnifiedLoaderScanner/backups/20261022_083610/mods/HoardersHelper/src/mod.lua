-- ============================================================================
-- HoardersHelper Mod
-- Asset Overrider / Dataset Generator at Startup
-- ============================================================================
-------------------------------------------------------------------------------
-- MODULES
-------------------------------------------------------------------------------
local ModConfig = require("HoardersHelperConfig")
-------------------------------------------------------------------------------
-- MODULE
-------------------------------------------------------------------------------
local HoardersHelper = {}
local EnabledLanguages = {}
-------------------------------------------------------------------------------
-- 0. CONFIGURAZIONE
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Costruiamo una lookup table:
--
-- EnabledLanguages["En_Us"] = true
-- EnabledLanguages["It_It"] = true
--
-- Questo è molto più veloce da interrogare rispetto a ipairs().
-------------------------------------------------------------------------------
for _, language in ipairs(ModConfig.enabledLanguages) do
    EnabledLanguages[language] = true
end

-------------------------------------------------------------------------------
-- Assicuriamo che la lingua di default sia sempre abilitata.
-------------------------------------------------------------------------------
if not EnabledLanguages[ModConfig.defaultLanguage] then
    table.insert(ModConfig.enabledLanguages, ModConfig.defaultLanguage)
    EnabledLanguages[ModConfig.defaultLanguage] = true
end
print("Lingua default: " .. tostring(ModConfig.defaultLanguage))
print("Lingue abilitate: " .. tostring(#ModConfig.enabledLanguages))
for _, language in ipairs(ModConfig.enabledLanguages) do
    print(" - " .. tostring(language))
end

-------------------------------------------------------------------------------
-- Restituisce l'intestazione localizzata
-------------------------------------------------------------------------------
local HoardersHelperHeaderMap = {
    ["En_Us"] = "\n\nUsed in recipes:",
    ["It_It"] = "\n\nUsato nelle ricette:",
    ["En_Gb"] = "\n\nUsed in recipes:",
    ["De_De"] = "\n\nVerwendet in Rezepten:",
    ["Nl_Nl"] = "\n\nGebruikt in recepten:",
    ["Fr_Fr"] = "\n\nUtilisé dans les recettes:",
    ["Fr_Ca"] = "\n\nUtilisé dans les recettes:",
    ["Es_Es"] = "\n\nUsado en recetas:",
    ["Es_Mx"] = "\n\nUsado en recetas:",
    ["Es_419"] = "\n\nUsado en recetas:",
    ["Ru_Ru"] = "\n\nИспользуется в рецептах:",
    ["Pl_Pl"] = "\n\nUżywane w przepisach:",
    ["Ja_Jp"] = "\n\nレシピで使用:",
    ["Id_Id"] = "\n\nDigunakan dalam resep:",
    ["Ko_Kr"] = "\n\n제작법에서 사용:",
    ["Ms_My"] = "\n\nDigunakan dalam resipi:",
    ["Pt_Pt"] = "\n\nUsado em receitas:",
    ["Pt_Br"] = "\n\nUsado em receitas:",
    ["Th_Th"] = "\n\nใช้ในสูตรคราฟต์:",
    ["Tr_Tr"] = "\n\nTariflerde kullanılır:",
    ["Vi_Vn"] = "\n\nĐược sử dụng trong các công thức:",
    ["Zh_Cn"] = "\n\n用于配方：",
    ["Zh_Tw"] = "\n\n用於配方：",
    ["Bg_Bg"] = "\n\nИзползва се в рецепти:",
    ["Cs_Cz"] = "\n\nPoužívá se v receptech:",
    ["Da_Dk"] = "\n\nBruges i opskrifter:",
    ["Fi_Fi"] = "\n\nKäytetään resepteissä:",
    ["El_Gr"] = "\n\nΧρησιμοποιείται σε συνταγές:",
    ["Hu_Hu"] = "\n\nReceptekben használva:",
    ["No_No"] = "\n\nBrukes i oppskrifter:",
    ["Nb_No"] = "\n\nBrukes i oppskrifter:",
    ["Ro_Ro"] = "\n\nFolosit în rețete:",
    ["Sv_Se"] = "\n\nAnvänds i recept:",
    ["Uk_Ua"] = "\n\nВикористовується в рецептах:"
}

function HoardersHelper.addToSet(map, key, value)
    if not map[key] then
        map[key] = {} -- Crea il set se la chiave non esiste ancora
    end
    map[key][value] = true
end

-- 2. Rimuovere un elemento dal set
function HoardersHelper.removeFromSet(map, key, value)
    if map[key] then
        map[key][value] = nil
    end
end

-- 3. Verificare se un elemento è presente nel set
function HoardersHelper.setContains(map, key, value)
    return map[key] ~= nil and map[key][value] == true
end

function HoardersHelper.get_header_text(language)
    return HoardersHelperHeaderMap[language] or HoardersHelperHeaderMap[ModConfig.defaultLanguage] or
               HoardersHelperHeaderMap["En_Us"]
end

-------------------------------------------------------------------------------
-- Restituisce i nomi degli output in ordine alfabetico nella lingua corrente.
--
-- outputNameSet è una set/map:
-- outputNameSet[outputNameId] = true
--
-- La set viene mantenuta per evitare duplicati; qui viene convertita
-- temporaneamente in un array per poter usare table.sort().
-------------------------------------------------------------------------------
function HoardersHelper.get_sorted_recipe_names(outputNameSet, language, LocaMap)
    local names = {}

    for outputNameId, _ in pairs(outputNameSet) do
        local name = LocaMap[language] and LocaMap[language][outputNameId]

        if name then
            name = HoardersHelper.strip_html(name)
            table.insert(names, name)
        end
    end

    table.sort(names, function(a, b)
        return a:lower() < b:lower()
    end)

    return names
end

function HoardersHelper.get_localization()
    local res_list = game.assets.get_resources_by_type("keen::LocaTagCollectionResource")
    if not res_list or #res_list == 0 then
        print("ERRORE: Nessuna " .. "LocaTagCollectionResource trovata!")
        return
    end
    return res_list[1].data
end

-- Rimuove qualsiasi tag del tipo <...> dalla stringa
function HoardersHelper.strip_html(str)
    if not str then
        return ""
    end
    return (str:gsub("<[^>]+>", ""))
end

-------------------------------------------------------------------------------
-- 1. DATASET DESCRIZIONE INPUT E NOME OUTPUT
-------------------------------------------------------------------------------
function HoardersHelper.buildInvertedRecipeDataSet()
    local itemToRecipesMap = {}
    local allStringsIds = {}
    print("Estrazione e inversione del RecipeRegistry...")

    local registries = game.assets.get_resources_by_type("keen::RecipeRegistryResource")
    if not registries or #registries == 0 then
        print("ERRORE: Nessun RecipeRegistryResource trovato!")
        return itemToRecipesMap, allStringsIds
    end

    local ItemInfoResource = game.assets.get_resources_by_type("keen::ItemInfo")
    local ItemMap = {}
    for _, Item in ipairs(ItemInfoResource) do
        if Item and Item.data then
            ItemMap[Item.data.itemId.value] = Item.data
        end
    end

    for _, registryRef in ipairs(registries) do
        local registry = registryRef.data
        if registry then
            -------------------------------------------------------------------
            -- A. Categorie
            -------------------------------------------------------------------
            local categoryToItems = {}
            if registry.inputCategories then
                for _, cat in ipairs(registry.inputCategories) do
                    if cat.inputCategoryId and cat.items then
                        local catId = cat.inputCategoryId.value
                        categoryToItems[catId] = {}
                        for _, itemHash in ipairs(cat.items) do
                            if itemHash and itemHash.value then
                                table.insert(categoryToItems[catId], itemHash.value)
                            end
                        end
                    end
                end
            end
            print("Estratte le categorie")
            -------------------------------------------------------------------
            -- B. Ricette
            -------------------------------------------------------------------
            if registry.recipes then
                for _, recipe in ipairs(registry.recipes) do
                    if not recipe.isUpgrade then -- Gli upgrade non hanno output
                        local itemOutput = ItemMap[recipe.output[1].item.value]
                        local outputNameId = game.guid.hash(itemOutput.name)

                        if recipe.input then
                            for _, input in ipairs(recipe.input) do
                                local itemInput = ItemMap[input.itemStack.item.value]
                                if itemInput then
                                    local inputDescriptionId = game.guid.hash(itemInput.description)

                                    ---------------------------------------------------
                                    -- Item specifico
                                    ---------------------------------------------------
                                    HoardersHelper.addToSet(itemToRecipesMap, inputDescriptionId, outputNameId)
                                    allStringsIds[inputDescriptionId] = true
                                    allStringsIds[outputNameId] = true

                                end
                                ---------------------------------------------------
                                -- Categoria
                                ---------------------------------------------------
                                if input.inputItemCategory and input.inputItemCategory.category then
                                    local catId = input.inputItemCategory.category.value
                                    local itemsInCat = categoryToItems[catId]
                                    if itemsInCat then
                                        for _, itemId in ipairs(itemsInCat) do
                                            local itemCatInput = ItemMap[itemId]
                                            if itemCatInput then
                                                local inputCatDescriptionId = game.guid.hash(itemCatInput.description)
                                                HoardersHelper.addToSet(itemToRecipesMap, inputCatDescriptionId,
                                                    outputNameId)
                                                allStringsIds[inputCatDescriptionId] = true
                                                allStringsIds[outputNameId] = true
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    print("Estrazione e inversione del RecipeRegistry completata")
    return itemToRecipesMap, allStringsIds
end

-------------------------------------------------------------------------------
-- 2. CREA LA MAPPA [LanguageKey][StringId]=>Text
-------------------------------------------------------------------------------
function HoardersHelper.compile_loca_map(localization, allStringsIds)
    local LocaMap = {}
    for _, loc in ipairs(localization.languages) do
        if EnabledLanguages[loc.language] then
            if LocaMap[loc.language] == nil then
                LocaMap[loc.language] = {}
            end
            local original_guid = game.guid.from_content_hash(loc.data.hash)
            local content = game.assets.get_content(original_guid)
            if content then
                local data = content:read_data():read_resource("keen::LocaTagCollectionResourceData")
                if data then
                    for _, tag in ipairs(data.tags) do
                        if allStringsIds[tag.id.value] then
                            LocaMap[loc.language][tag.id.value] = tag.text
                        end
                    end
                end
            end
        end
    end
    print(" Mappa delle stringhe creata")
    return LocaMap;
end

-------------------------------------------------------------------------------
-- 3. CAMBIA STRINGHE NELLA LOCALIZZAZIONE
-------------------------------------------------------------------------------

function HoardersHelper.write_localized_strings(localization, itemToRecipesMap, LocaMap)
    local descriptionChanged = 0
    for _, loc in ipairs(localization.languages) do
        if EnabledLanguages[loc.language] then
            local original_guid = game.guid.from_content_hash(loc.data.hash)
            local content = game.assets.get_content(original_guid)
            if content then
                local data = content:read_data():read_resource("keen::LocaTagCollectionResourceData")
                if data then
                    local modified = false
                    for _, tag in ipairs(data.tags) do
                        if itemToRecipesMap[tag.id.value] then
                            local outputNameSet = itemToRecipesMap[tag.id.value]
                            tag.text = tag.text .. HoardersHelperHeaderMap[loc.language]
                            local sortedNames = HoardersHelper.get_sorted_recipe_names(
                                outputNameSet,
                                loc.language,
                                LocaMap
                            )

                            for _, name in ipairs(sortedNames) do
                                tag.text = tag.text .. "\n-" .. name
                            end
                            modified = true
                            descriptionChanged = descriptionChanged + 1
                        end
                    end

                    if modified then
                        local new_buffer = buffer.create()
                        new_buffer:write_resource("keen::LocaTagCollectionResourceData", data)
                        local new_content = game.assets.create_content(new_buffer)
                        loc.data.hash = game.guid.to_content_hash(new_content.guid)
                    end
                end
            end
        end
    end
    print("Descrizioni cambiate: " .. tostring(descriptionChanged))
end

-------------------------------------------------------------------------------
-- RUN AT STARTUP
-------------------------------------------------------------------------------

function HoardersHelper.run()
    print("==================================================")
    print("STARTUP MOD INJECTION")
    print("==================================================")

    local itemToRecipesMap, allStringIds = HoardersHelper.buildInvertedRecipeDataSet()
    local localization = HoardersHelper.get_localization()
    local LocaMap = HoardersHelper.compile_loca_map(localization, allStringIds)
    HoardersHelper.write_localized_strings(localization, itemToRecipesMap, LocaMap)
    print("Mod completata con successo!")
    print("==================================================")
end

-------------------------------------------------------------------------------
-- START
-------------------------------------------------------------------------------
HoardersHelper.run()
return HoardersHelper
