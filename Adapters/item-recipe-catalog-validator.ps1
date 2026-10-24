param(
    [Parameter(Mandatory = $true)] [string]$Catalog,
    [Parameter(Mandatory = $true)] [string]$KfcRoot,
    [Parameter(Mandatory = $true)] [string]$Output
)

$ErrorActionPreference = 'Stop'
$data = Get-Content -Raw -LiteralPath $Catalog | ConvertFrom-Json
$itemFiles = @{}
foreach ($file in Get-ChildItem -LiteralPath (Join-Path $KfcRoot 'ItemInfo') -File -Filter '*.json') { $itemFiles[$file.Name] = $file.FullName }
$recipeFiles = @{}
foreach ($file in Get-ChildItem -LiteralPath (Join-Path $KfcRoot 'RecipeRegistryResource') -File -Filter '*.json') { $recipeFiles[$file.Name] = $file.FullName }

$itemsMissingSource = @($data.items | Where-Object { -not $itemFiles.ContainsKey([string]$_.sourceFile) })
$recipesMissingSource = @($data.recipes | Where-Object { -not $recipeFiles.ContainsKey([string]$_.sourceFile) })
$itemNames = @($data.items | Where-Object { $_.debugName } | Select-Object -ExpandProperty debugName | Sort-Object -Unique)
$recipeNames = @($data.recipes | Where-Object { $_.debugName } | Select-Object -ExpandProperty debugName | Sort-Object -Unique)

[ordered]@{
    schema_version = 1
    adapter_id = 'embervault-item-recipe-catalog-validator'
    game_scope = 'Enshrouded 1.0'
    catalog_source = $Catalog
    kfc_root = $KfcRoot
    item_count = $data.itemCount
    recipe_count = $data.recipeCount
    distinct_item_debug_names = $itemNames.Count
    distinct_recipe_debug_names = $recipeNames.Count
    item_source_files_found = $itemFiles.Count
    recipe_source_files_found = $recipeFiles.Count
    items_missing_source_file = $itemsMissingSource.Count
    recipes_missing_source_file = $recipesMissingSource.Count
    evidence_state = if ($itemsMissingSource.Count -eq 0 -and $recipesMissingSource.Count -eq 0) { 'observed' } else { 'partial' }
    promotion_state = 'research-only'
    limitation = 'Catalog/source validation does not prove live runtime visibility, crafting behavior, or writability.'
    missing_item_sources = @($itemsMissingSource | Select-Object -First 50 debugName,sourceFile)
    missing_recipe_sources = @($recipesMissingSource | Select-Object -First 50 debugName,sourceFile)
} | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $Output -Encoding UTF8

Write-Output "Wrote $Output"
