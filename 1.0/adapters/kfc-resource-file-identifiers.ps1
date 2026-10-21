param(
    [Parameter(Mandatory = $true)] [string]$KfcRoot,
    [Parameter(Mandatory = $true)] [string]$Output
)

$ErrorActionPreference = 'Stop'
if (-not (Test-Path -LiteralPath $KfcRoot -PathType Container)) { throw "KFC root not found: $KfcRoot" }

$records = foreach ($file in Get-ChildItem -LiteralPath $KfcRoot -Recurse -File -Filter '*.json') {
    if ($file.BaseName -match '^([0-9a-fA-F-]{36})_([0-9a-fA-F]{8})_([0-9]+)$') {
        [ordered]@{
            resource_folder = $file.Directory.Name
            guid = $Matches[1].ToLowerInvariant()
            identifier_hex = $Matches[2].ToLowerInvariant()
            part_index = [int]$Matches[3]
            file_name = $file.Name
        }
    }
}

[ordered]@{
    schema_version = 1
    adapter_id = 'embervault-kfc-resource-file-identifiers'
    game_scope = 'Enshrouded 1.0'
    source = $KfcRoot
    record_count = @($records).Count
    distinct_resource_folders = @($records.resource_folder | Sort-Object -Unique).Count
    distinct_identifiers = @($records.identifier_hex | Sort-Object -Unique).Count
    limitation = 'Filename identifiers are cataloged as KFC evidence; their relationship to EML Type identifiers remains unverified.'
    records = @($records)
} | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $Output -Encoding UTF8

Write-Output "Wrote $Output"
