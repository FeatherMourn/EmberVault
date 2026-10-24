param(
    [Parameter(Mandatory = $true)] [string]$CacheTypes,
    [Parameter(Mandatory = $true)] [string]$KfcRoot,
    [Parameter(Mandatory = $true)] [string]$Output
)

$ErrorActionPreference = 'Stop'
$cache = Get-Content -Raw -LiteralPath $CacheTypes | ConvertFrom-Json
$kfcFolders = @(Get-ChildItem -LiteralPath $KfcRoot -Directory | Select-Object -ExpandProperty Name)

$records = foreach ($folder in $kfcFolders) {
    $matches = @($cache.types | Where-Object { $_.name -eq $folder -or $_.qualifiedName -eq "keen::$folder" })
    [ordered]@{
        kfc_resource_folder = $folder
        status = if ($matches.Count -eq 1) { 'matched' } elseif ($matches.Count -gt 1) { 'ambiguous' } else { 'unmatched' }
        cache_candidates = @($matches | ForEach-Object {
            [ordered]@{
                index = $_.index
                name = $_.name
                qualified_name = $_.qualifiedName
                name_hash = $_.nameHash
                qualified_hash = $_.qualifiedHash
                internal_hash = $_.internalHash
                field_count = $_.fieldCount
                primitive_type = $_.primitiveType
            }
        })
        evidence = 'current game .cache/types.json joined to local KFC resource folder name'
    }
}

[ordered]@{
    schema_version = 1
    adapter_id = 'embervault-cache-type-name-bridge'
    game_scope = 'Enshrouded 1.0'
    cache_version = $cache.version
    cache_types = $CacheTypes
    kfc_root = $KfcRoot
    kfc_folder_count = $kfcFolders.Count
    matched_count = @($records | Where-Object status -eq 'matched').Count
    ambiguous_count = @($records | Where-Object status -eq 'ambiguous').Count
    unmatched_count = @($records | Where-Object status -eq 'unmatched').Count
    promotion_state = 'research-only'
    limitation = 'This bridges KFC folder names to current cache type metadata; it does not by itself prove live EML resource access or writability.'
    records = @($records)
} | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $Output -Encoding UTF8

Write-Output "Wrote $Output"
