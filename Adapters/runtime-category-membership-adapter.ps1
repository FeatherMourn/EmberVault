param(
    [Parameter(Mandatory = $true)] [string]$ProbeOutput,
    [Parameter(Mandatory = $true)] [string]$ItemCatalog,
    [Parameter(Mandatory = $true)] [string]$Output
)

$ErrorActionPreference = 'Stop'
$dataLine = Get-Content -LiteralPath $ProbeOutput | Where-Object { $_ -match '^data\t' } | Select-Object -First 1
if (-not $dataLine) { throw 'Probe output has no data line.' }
$registry = ($dataLine -split "`t", 2)[1] | ConvertFrom-Json
$catalog = Get-Content -Raw -LiteralPath $ItemCatalog | ConvertFrom-Json
$items = @{}
foreach ($item in $catalog.items) { $items[[string]$item.item_id] = $item }

$categories = foreach ($category in @($registry.inputCategories)) {
    $members = foreach ($member in @($category.items)) {
        $item = $items[[string]$member.itemId.value]
        [ordered]@{
            item_id = $member.itemId.value
            scaling = $member.scaling
            debug_name = if ($item) { $item.debug_name } else { $null }
            object_id = if ($item) { $item.object_id } else { $null }
            resolved = [bool]$item
        }
    }
    [ordered]@{
        category_id = $category.inputCategoryId.value
        member_count = @($members).Count
        resolved_member_count = @($members | Where-Object resolved).Count
        members = @($members)
    }
}

[ordered]@{
    schema_version = 1
    adapter_id = 'embervault-runtime-category-membership'
    game_scope = 'Enshrouded 1.0'
    probe_output = $ProbeOutput
    item_catalog = $ItemCatalog
    evidence_state = 'observed'
    promotion_state = 'research-only'
    category_count = @($categories).Count
    total_membership_rows = @($categories | ForEach-Object members).Count
    unresolved_members = @($categories | ForEach-Object members | Where-Object { -not $_.resolved }).Count
    categories = @($categories)
    limitation = 'Runtime membership identifies category contents; human-readable category labels remain unavailable from this probe.'
} | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $Output -Encoding UTF8

Write-Output "Wrote $Output"
