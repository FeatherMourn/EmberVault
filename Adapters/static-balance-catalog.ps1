[CmdletBinding()]
param(
  [Parameter(Mandatory)] [string] $ItemRecipeCatalog,
  [Parameter(Mandatory)] [string] $RecipeTargetingCatalog,
  [Parameter(Mandatory)] [string] $Output
)

$itemRecipe = Get-Content -LiteralPath $ItemRecipeCatalog -Raw | ConvertFrom-Json
$recipeTargeting = Get-Content -LiteralPath $RecipeTargetingCatalog -Raw | ConvertFrom-Json
$itemsById = @{}
foreach ($item in $itemRecipe.items) { $itemsById[[string]$item.itemId] = $item }

$recipes = foreach ($recipe in $recipeTargeting.recipes) {
  $inputRows = foreach ($input in $recipe.inputs) {
    $item = $itemsById[[string]$input.item_id]
    [ordered]@{ item_id=$input.item_id; debug_name=if ($item) {$item.debugName} else {$null}; count=$input.count; category_id=$input.category_id; evidence='observed/static' }
  }
  $outputRows = foreach ($outputItem in $recipe.outputs) {
    $item = $itemsById[[string]$outputItem.item_id]
    [ordered]@{ item_id=$outputItem.item_id; debug_name=if ($item) {$item.debugName} else {$null}; count=$outputItem.count; evidence='observed/static' }
  }
  [ordered]@{
    recipe_id=$recipe.recipe_id; debug_name=$recipe.debug_name; workshop_id=$recipe.workshop_id
    workshop_name=$recipe.workshop_name; level=$recipe.level; crafting_duration=$recipe.crafting_duration
    is_cooking=$recipe.is_cooking; is_upgrade=$recipe.is_upgrade; inputs=@($inputRows); outputs=@($outputRows)
    source=$recipe.sourceFile; evidence='observed/static'
  }
}

$result = [ordered]@{
  schema_version=1; adapter_id='embervault-static-balance-catalog'; game_scope='Enshrouded 1.0'
  evidence_state='observed/static'; source_catalogs=@($ItemRecipeCatalog,$RecipeTargetingCatalog)
  item_count=$itemRecipe.itemCount; recipe_count=$recipes.Count
  items=@($itemRecipe.items | ForEach-Object {
    [ordered]@{ item_id=$_.itemId; debug_name=$_.debugName; category=$_.category; rarity=$_.rarity
      max_stack_size=$_.maxStackSize; equipment_slot=$_.equipmentSlot; item_class=$_.itemClass
      flags=$_.flags; source=$_.sourceFile; evidence='observed/static' }
  })
  recipes=@($recipes)
}
$result | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $Output -Encoding utf8
