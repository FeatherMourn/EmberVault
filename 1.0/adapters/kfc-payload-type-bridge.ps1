param(
    [Parameter(Mandatory = $true)] [string]$CacheTypes,
    [Parameter(Mandatory = $true)] [string]$KfcRoot,
    [Parameter(Mandatory = $true)] [string]$Output
)

$ErrorActionPreference = 'Stop'
$cache = Get-Content -Raw -LiteralPath $CacheTypes | ConvertFrom-Json
$records = foreach ($folder in Get-ChildItem -LiteralPath $KfcRoot -Directory) {
    $types = @()
    $examples = @()
    foreach ($file in @(Get-ChildItem -LiteralPath $folder.FullName -File -Filter '*.json' | Select-Object -First 1)) {
        try {
            $payload = Get-Content -Raw -LiteralPath $file.FullName | ConvertFrom-Json
            if ($payload.'$type') {
                $types += [string]$payload.'$type'
                if ($examples.Count -lt 3) {
                    $examples += [ordered]@{ file = $file.Name; guid = $payload.'$guid'; part = $payload.'$part'; type = $payload.'$type' }
                }
            }
        } catch { }
    }
    $types = @($types | Sort-Object -Unique)
    $candidates = @($types | ForEach-Object { $typeName = $_; @($cache.types | Where-Object { $_.qualifiedName -eq $typeName }) })
    [ordered]@{
        kfc_resource_folder = $folder.Name
        payload_types = $types
        status = if ($candidates.Count -eq 1) { 'matched' } elseif ($candidates.Count -gt 1) { 'ambiguous' } elseif ($types.Count -eq 0) { 'no-payload-type' } else { 'unmatched' }
        cache_candidates = @($candidates | Select-Object index,name,qualifiedName,nameHash,qualifiedHash,internalHash,fieldCount,primitiveType)
        examples = $examples
        evidence = 'KFC payload $type joined to current game .cache/types.json qualifiedName'
    }
}

[ordered]@{
    schema_version = 1
    adapter_id = 'embervault-kfc-payload-type-bridge'
    game_scope = 'Enshrouded 1.0'
    cache_version = $cache.version
    kfc_root = $KfcRoot
    folder_count = @($records).Count
    matched_count = @($records | Where-Object status -eq 'matched').Count
    ambiguous_count = @($records | Where-Object status -eq 'ambiguous').Count
    unmatched_count = @($records | Where-Object status -eq 'unmatched').Count
    no_payload_type_count = @($records | Where-Object status -eq 'no-payload-type').Count
    promotion_state = 'research-only'
    limitation = 'Payload type identity is strong static evidence, but does not prove live EML access or writability.'
    records = @($records)
} | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $Output -Encoding UTF8

Write-Output "Wrote $Output"
