param(
    [Parameter(Mandatory = $true)] [string]$Catalog,
    [Parameter(Mandatory = $true)] [string]$Output
)

$ErrorActionPreference = 'Stop'
$data = Get-Content -Raw -LiteralPath $Catalog | ConvertFrom-Json

$items = @($data.items | ForEach-Object {
    [ordered]@{
        item_id = $_.itemId
        object_id = $_.objectId
        debug_name = $_.debugName
        display_name = $_.displayName
        name_tag = $_.nameTag
        description_tag = $_.descriptionTag
        category = $_.category
        rarity = $_.rarity
        equipment_slot = $_.equipmentSlot
        item_class = $_.itemClass
        max_stack_size = $_.maxStackSize
        flags = @($_.flags)
        tags = @($_.tags)
        source_file = $_.sourceFile
        evidence = 'KFC ItemInfo catalog; same-build static record'
    }
})

$recipes = @($data.recipes | ForEach-Object {
    [ordered]@{
        recipe_id = $_.recipeId
        recipe_guid = $_.recipeGuid
        debug_name = $_.debugName
        recipe_name = $_.recipeName
        inputs = @($_.input | ForEach-Object { [ordered]@{ item_id = $_.itemId; item_ref = $_.itemRef; count = $_.count; category_id = $_.categoryId; category_ref = $_.categoryRef } })
        outputs = @($_.output | ForEach-Object { [ordered]@{ item_id = $_.itemId; item_ref = $_.itemRef; count = $_.count } })
        crafting_duration = $_.craftingDuration
        level = $_.level
        comfort_level = $_.comfortLevel
        is_cooking_recipe = $_.isCookingRecipe
        is_upgrade = $_.isUpgrade
        source_file = $_.sourceFile
        evidence = 'KFC recipe catalog; same-build static record'
    }
})

[ordered]@{
    schema_version = 1
    adapter_id = 'embervault-item-recipe'
    game_scope = 'Enshrouded 1.0'
    source = $Catalog
    evidence_state = 'observed'
    promotion_state = 'research-only'
    limitations = @('Static catalog evidence does not prove live runtime visibility.', 'Recipe records do not prove crafting behavior or writability.')
    item_count = $items.Count
    recipe_count = $recipes.Count
    items = $items
    recipes = $recipes
} | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $Output -Encoding UTF8

Write-Output "Wrote $Output"
