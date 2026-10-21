param(
    [Parameter(Mandatory = $true)] [string]$Catalog,
    [Parameter(Mandatory = $true)] [string]$Output
)

$ErrorActionPreference = 'Stop'
$data = Get-Content -Raw -LiteralPath $Catalog | ConvertFrom-Json
$refs = foreach ($recipe in $data.recipes) {
    foreach ($input in @($recipe.inputs)) {
        if ([int64]$input.item_id -eq 0) {
            [ordered]@{
                recipe_id = $recipe.recipe_id
                debug_name = $recipe.debug_name
                category_id = $input.category_id
                category_ref = $input.category_ref
                count = $input.count
            }
        }
    }
}
$groups = @($refs | Group-Object { "$($_.category_id)|$($_.category_ref)" } | ForEach-Object {
    $first = $_.Group[0]
    [ordered]@{
        category_id = $first.category_id
        category_ref = $first.category_ref
        usage_count = $_.Count
        recipe_ids = @($_.Group.recipe_id | Sort-Object -Unique)
        debug_names = @($_.Group.debug_name | Sort-Object -Unique)
    }
})

[ordered]@{
    schema_version = 1
    adapter_id = 'embervault-recipe-category-references'
    game_scope = 'Enshrouded 1.0'
    source = $Catalog
    evidence_state = 'observed'
    promotion_state = 'research-only'
    zero_item_input_count = $refs.Count
    distinct_category_reference_count = $groups.Count
    category_references = $groups
    unresolved_category_names = $groups.Count
    limitation = 'Category IDs and GUIDs are preserved as static evidence; names require a verified category registry or runtime lookup.'
} | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $Output -Encoding UTF8

Write-Output "Wrote $Output"
