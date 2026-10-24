param(
    [Parameter(Mandatory = $true)] [string]$EmlReport,
    [Parameter(Mandatory = $true)] [string]$KfcRoot,
    [Parameter(Mandatory = $true)] [string]$Output
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $EmlReport -PathType Leaf)) { throw "EML report not found: $EmlReport" }
if (-not (Test-Path -LiteralPath $KfcRoot -PathType Container)) { throw "KFC root not found: $KfcRoot" }

$runtimeTypes = Get-Content -LiteralPath $EmlReport |
    Where-Object { $_ -match '^resource_type\t' } |
    ForEach-Object { ($_ -split "`t", 2)[1] }
$kfcFolders = @(Get-ChildItem -LiteralPath $KfcRoot -Directory | Select-Object -ExpandProperty Name)

$records = foreach ($runtimeType in $runtimeTypes) {
    $normalized = $runtimeType -replace '^Type:\s*', ''
    $candidates = @($kfcFolders | Where-Object { $_ -eq $normalized })
    [ordered]@{
        runtime_type = $runtimeType
        normalized_runtime_id = $normalized
        status = if ($candidates.Count -eq 1) { 'matched' } elseif ($candidates.Count -gt 1) { 'ambiguous' } else { 'unmatched' }
        kfc_candidates = $candidates
        evidence = 'EML runtime enumeration joined to same-build local KFC folder inventory'
    }
}

[ordered]@{
    schema_version = 1
    adapter_id = 'embervault-resource-type'
    game_scope = 'Enshrouded 1.0'
    runtime_report = $EmlReport
    kfc_root = $KfcRoot
    runtime_type_count = $runtimeTypes.Count
    kfc_folder_count = $kfcFolders.Count
    matched_count = @($records | Where-Object status -eq 'matched').Count
    ambiguous_count = @($records | Where-Object status -eq 'ambiguous').Count
    unmatched_count = @($records | Where-Object status -eq 'unmatched').Count
    promotion_state = 'research-only'
    limitation = 'Direct folder-name matching does not establish a bridge between EML Type identifiers and KFC resource names. Unmatched records require verified same-build mapping metadata.'
    records = @($records)
} | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $Output -Encoding UTF8

Write-Output "Wrote $Output"
