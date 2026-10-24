$ErrorActionPreference = 'Stop'
$repo = 'I:\My Drive\Enshrouded Mods\EmberVault_Research\Embervault_Researcher\GitHub_Release\Site\EmberVault'
$data = Join-Path $repo 'Site\data'
$inventoryPath = Join-Path $data 'phase1-source-inventory.csv'
$inventory = Import-Csv -LiteralPath $inventoryPath

function Convert-ToSlug($value) {
  $s = $value.ToLowerInvariant() -replace '[^a-z0-9]+','-'
  return $s.Trim('-')
}
function Get-DisplayTitle($fileName) {
  $base = [IO.Path]::GetFileNameWithoutExtension($fileName)
  $base = $base -replace '[-_]',' '
  $base = $base -replace '(?i)\b(v\d+(\.\d+)*)\b',''
  return (($base -split '\s+' | Where-Object { $_ }) | ForEach-Object { $_.Substring(0,1).ToUpperInvariant()+$_.Substring(1) }) -join ' '
}
function Get-RecordType($category, $extension) {
  switch ($category) {
    'Report' { if ($extension -eq '.json') { return 'report-data' }; return 'report' }
    'Probe' { if ($extension -eq '.lua') { return 'probe-source' }; if ($extension -eq '.json') { return 'probe-manifest' }; return 'probe-documentation' }
    'Catalog' { return 'catalog' }
    'Method' { return 'method' }
    'Mod analysis' { return 'mod-analysis' }
    'Adapter' { return 'adapter' }
    'Loader' { return 'loader' }
    'Provenance' { return 'provenance' }
    'Project metadata' { return 'project-metadata' }
    'Project documentation' { return 'project-documentation' }
    'Tooling' { return 'tool' }
    default { return 'unclassified' }
  }
}

$records = foreach ($row in $inventory) {
  $slug = Convert-ToSlug $row.source_path
  $recordType = Get-RecordType $row.category $row.extension
  $title = Get-DisplayTitle $row.file_name
  $keywords = @($row.category, $recordType, ($row.source_path -replace '[\\/_\.-]',' ')) -join ' '
  $related = @()
  if ($row.category -eq 'Report') { $related += 'reports' }
  if ($row.category -eq 'Probe') { $related += 'probes' }
  if ($row.category -in @('Catalog','Adapter','Loader')) { $related += 'capabilities' }
  if ($row.category -in @('Method','Project documentation')) { $related += 'methods' }
  if ($row.category -eq 'Mod analysis') { $related += 'mods-tools' }
  [pscustomobject]@{
    id = "ev-$recordType-$slug"
    title = $title
    record_type = $recordType
    category = $row.category
    publication_status = $row.publication_status
    evidence_role = $row.evidence_role
    source_path = $row.source_path
    source_extension = $row.extension
    source_bytes = [int64]$row.bytes
    game = $row.game
    game_version = $row.game_version
    source_build = $row.source_build
    intended_site_destination = $row.intended_site_destination
    keywords = $keywords.ToLowerInvariant()
    related_sections = $related
    normalization_status = if ($row.publication_status -eq 'Exclude') { 'excluded' } elseif ($row.publication_status -eq 'Review') { 'needs-content-review' } else { 'normalized-from-path' }
    content_review_needed = ($row.publication_status -ne 'Exclude')
  }
}

$records | ConvertTo-Json -Depth 6 | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $data 'phase2-normalized-records.json')

$review = $records | Where-Object { $_.content_review_needed -eq $true -and $_.normalization_status -ne 'normalized-from-path' }
$review | Select-Object id,title,record_type,category,source_path,publication_status,intended_site_destination | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath (Join-Path $data 'phase2-content-review-queue.csv')

$groups = $records | Group-Object record_type | Sort-Object Name | ForEach-Object {
  [pscustomobject]@{ record_type=$_.Name; records=$_.Count; curated=@($_.Group | Where-Object publication_status -eq 'Curate').Count; review=@($_.Group | Where-Object publication_status -eq 'Review').Count; excluded=@($_.Group | Where-Object publication_status -eq 'Exclude').Count }
}
$groups | ConvertTo-Json -Depth 4 | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $data 'phase2-normalization-summary.json')

$unresolved = @($records | Where-Object { $_.normalization_status -eq 'needs-content-review' }).Count
$md = @"
# Phase 2 Content Normalization Audit

Phase 2 converts the Phase 1 file inventory into stable, machine-readable EmberVault records. The source repository was not modified.

## Outputs

- `data/phase2-normalized-records.json` — one normalized record per source file.
- `data/phase2-normalization-summary.json` — counts by record type.
- `data/phase2-content-review-queue.csv` — items that require manual content review.

## Required metadata baseline

Every normalized record carries Enshrouded version `1.0.0.3` and source build `39026384728` unless the original inventory states otherwise.

## Normalization rules

- Stable IDs use the `ev-<record-type>-<source-path>` pattern.
- Titles are generated from filenames and require editorial review before public display.
- Categories are inherited from the Phase 1 source classification.
- Reports, probes, catalogs, methods, mod analyses, adapters, loaders, provenance, metadata, and project documentation receive distinct record types.
- Excluded support material remains represented in the normalized dataset but is marked `excluded`; it is not intended for public pages.
- Review-status tooling and ambiguous records are placed in the content-review queue.

## Current audit result

- Total normalized records: $($records.Count)
- Records requiring manual content review: $unresolved
- Records marked excluded: $(@($records | Where-Object publication_status -eq 'Exclude').Count)
- Records provisionally curated: $(@($records | Where-Object publication_status -eq 'Curate').Count)

## Remaining limitation

This phase normalizes identity and metadata. It does not infer the scientific conclusion of a report or probe from its filename. Phase 3 must read the curated source contents and populate purpose, question, procedure, observed result, failure state, evidence level, limitations, and related-record links.
"@
$md | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $data 'phase2-normalization-audit.md')

Write-Output "Normalized $($records.Count) records; content review queue contains $unresolved records."
