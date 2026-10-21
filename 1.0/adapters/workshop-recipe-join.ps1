param(
    [Parameter(Mandatory = $true)] [string]$ProbeOutput,
    [Parameter(Mandatory = $true)] [string]$RecipeCatalog,
    [Parameter(Mandatory = $true)] [string]$Output
)

$ErrorActionPreference = 'Stop'
$line = Get-Content -LiteralPath $ProbeOutput | Where-Object { $_ -match '^data\t' } | Select-Object -First 1
if (-not $line) { throw 'Workshop probe output has no data line.' }
$registry = ($line -split "`t", 2)[1] | ConvertFrom-Json
$recipes = (Get-Content -Raw -LiteralPath $RecipeCatalog | ConvertFrom-Json).recipes
$workshops = @($registry.workshops)
$byId = @{}
foreach ($workshop in $workshops) { $byId[[string]$workshop.workshopId.value] = $workshop }
$usage = @($recipes | Group-Object workshop_id | ForEach-Object {
    $id = [string]$_.Name
    $workshop = $byId[$id]
    [ordered]@{
        workshop_id = if ($id -eq '<null>') { $null } else { [int64]$id }
        recipe_count = $_.Count
        workshop_guid = if ($workshop) { $workshop.workshopGuid } else { $null }
        name_id = if ($workshop) { $workshop.name.value } else { $null }
        resolved = [bool]$workshop
        sample_recipe_names = @($_.Group | Select-Object -First 5 -ExpandProperty debug_name)
    }
})

[ordered]@{
    schema_version = 1
    adapter_id = 'embervault-workshop-recipe'
    game_scope = 'Enshrouded 1.0'
    probe_output = $ProbeOutput
    recipe_catalog = $RecipeCatalog
    evidence_state = 'observed'
    promotion_state = 'research-only'
    workshop_count = $workshops.Count
    recipe_workshop_group_count = $usage.Count
    unresolved_workshop_group_count = @($usage | Where-Object { -not $_.resolved }).Count
    workshop_usage = @($usage)
    limitation = 'Workshop name IDs require localization resolution; this report preserves numeric IDs and GUIDs without inventing labels.'
} | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $Output -Encoding UTF8

Write-Output "Wrote $Output"
