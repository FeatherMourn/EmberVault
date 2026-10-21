param(
    [Parameter(Mandatory = $true)] [string]$Catalog,
    [Parameter(Mandatory = $true)] [string]$Output
)

$ErrorActionPreference = 'Stop'
$data = Get-Content -Raw -LiteralPath $Catalog | ConvertFrom-Json
$itemIds = @{}
foreach ($item in $data.items) { $itemIds[[string]$item.item_id] = $true }

$missingInputs = @()
$missingOutputs = @()
$zeroInputs = @()
$zeroOutputs = @()
foreach ($recipe in $data.recipes) {
    foreach ($input in @($recipe.inputs)) {
        if ([int64]$input.item_id -eq 0) { $zeroInputs += [string]$recipe.recipe_id }
        elseif (-not $itemIds.ContainsKey([string]$input.item_id)) { $missingInputs += [ordered]@{ recipe_id = $recipe.recipe_id; debug_name = $recipe.debug_name; item_id = $input.item_id } }
    }
    foreach ($recipeOutput in @($recipe.outputs)) {
        if ([int64]$recipeOutput.item_id -eq 0) { $zeroOutputs += [string]$recipe.recipe_id }
        elseif (-not $itemIds.ContainsKey([string]$recipeOutput.item_id)) { $missingOutputs += [ordered]@{ recipe_id = $recipe.recipe_id; debug_name = $recipe.debug_name; item_id = $recipeOutput.item_id } }
    }
}

$byCooking = @($data.recipes | Group-Object is_cooking_recipe | ForEach-Object { [ordered]@{ value = $_.Name; count = $_.Count } })
$byUpgrade = @($data.recipes | Group-Object is_upgrade | ForEach-Object { [ordered]@{ value = $_.Name; count = $_.Count } })

[ordered]@{
    schema_version = 1
    adapter_id = 'embervault-recipe-relationships'
    game_scope = 'Enshrouded 1.0'
    source = $Catalog
    evidence_state = 'observed'
    promotion_state = 'research-only'
    item_count = $data.item_count
    recipe_count = $data.recipe_count
    missing_input_reference_count = $missingInputs.Count
    missing_output_reference_count = $missingOutputs.Count
    zero_input_reference_count = $zeroInputs.Count
    zero_output_reference_count = $zeroOutputs.Count
    recipes_by_cooking_flag = $byCooking
    recipes_by_upgrade_flag = $byUpgrade
    missing_inputs = @($missingInputs)
    missing_outputs = @($missingOutputs)
    limitations = @('Zero item IDs may represent category-only requirements.', 'Static relationships do not prove live crafting behavior or writability.')
} | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $Output -Encoding UTF8

Write-Output "Wrote $Output"
