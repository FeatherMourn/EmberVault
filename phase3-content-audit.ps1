$ErrorActionPreference = 'Stop'
$source = 'I:\My Drive\Enshrouded Mods\EmberVault_Research\Embervault_Researcher\1.0'
$repo = 'I:\My Drive\Enshrouded Mods\EmberVault_Research\Embervault_Researcher\GitHub_Release\Site\EmberVault'
$data = Join-Path $repo 'Site\data'
$normalized = Get-Content -Raw -LiteralPath (Join-Path $data 'phase2-normalized-records.json') | ConvertFrom-Json

function Read-Source($relative) {
  $path = Join-Path $source $relative
  if (-not (Test-Path -LiteralPath $path)) { return '' }
  try {
    $info = Get-Item -LiteralPath $path
    $limit = 1048576
    if ($info.Length -gt $limit) {
      $stream = [IO.StreamReader]::new($path)
      try { $buffer = New-Object char[] $limit; $read = $stream.Read($buffer, 0, $limit); return (-join $buffer[0..($read-1)]) } finally { $stream.Dispose() }
    }
    return Get-Content -Raw -LiteralPath $path
  } catch { return '' }
}
function Clean-Text($text) {
  return (($text -replace '(?s)```.*?```',' ' -replace '<[^>]+>',' ' -replace '\s+',' ').Trim())
}
function First-Sentence($text) {
  $clean = Clean-Text $text
  if (-not $clean) { return 'No readable source summary was extracted.' }
  $match = [regex]::Match($clean, '.{1,280}?[.!?](\s|$)')
  if ($match.Success) { return $match.Value.Trim() }
  return $clean.Substring(0, [Math]::Min(280, $clean.Length)).Trim()
}
function Extract-Headings($text) {
  @([regex]::Matches($text, '(?m)^#{1,4}\s+(.+?)\s*$') | ForEach-Object { $_.Groups[1].Value.Trim() } | Select-Object -First 12)
}
function Get-Signals($text) {
  $lower = $text.ToLowerInvariant()
  $signals = @()
  foreach ($pair in @(
    @('verified','verified'), @('observed','observed'), @('blocked','blocked'), @('failed','failure reported'), @('failure','failure reported'), @('experimental','experimental'), @('hypothesis','hypothesis'), @('unknown','unknown'), @('limitation','limitation'), @('read-only','read-only'), @('runtime','runtime'), @('static','static'), @('build','build metadata'), @('next step','next step')
  )) { if ($lower.Contains($pair[0])) { $signals += $pair[1] } }
  return @($signals | Select-Object -Unique)
}
function Get-Evidence($category, $signals) {
  if ($signals -contains 'verified') { return 'verified' }
  if ($signals -contains 'blocked') { return 'blocked' }
  if ($signals -contains 'observed') { return 'observed' }
  if ($category -in @('Catalog','Project metadata','Provenance')) { return 'static' }
  if ($signals -contains 'experimental') { return 'experimental' }
  return 'unclassified'
}
function Get-Purpose($record, $text) {
  switch ($record.record_type) {
    'report' { return 'Preserved research report documenting a source-backed investigation, observation, or analysis.' }
    'report-data' { return 'Machine-readable report output supporting a corresponding research record.' }
    'probe-source' { return 'Executable or inspectable probe source used to investigate Enshrouded or ShroudForge behavior.' }
    'probe-manifest' { return 'Probe package metadata describing identity, configuration, or execution details.' }
    'probe-documentation' { return 'Documentation describing a probe, its purpose, boundaries, or expected output.' }
    'catalog' { return 'Curated static data catalog used to identify resources, fields, relationships, or candidate capabilities.' }
    'method' { return 'Research method or operating procedure for producing reproducible, bounded evidence.' }
    'mod-analysis' { return 'Analysis of a mod, fork, loader, or related compatibility behavior.' }
    'adapter' { return 'Adapter or transformation record connecting source data to a research workflow.' }
    'loader' { return 'Loader or compatibility record describing how a component is discovered, loaded, or constrained.' }
    'project-documentation' { return 'Project-level documentation explaining scope, plans, evidence, or research organization.' }
    'project-metadata' { return 'Project metadata defining the game, build, loader, source identity, and provenance baseline.' }
    'provenance' { return 'Source provenance record connecting derived material to its originating data or process.' }
    default { return 'Supporting research artifact requiring additional interpretation.' }
  }
}

$records = foreach ($record in $normalized | Where-Object { $_.publication_status -ne 'Exclude' }) {
  $text = Read-Source $record.source_path
  $headings = Extract-Headings $text
  $signals = Get-Signals $text
  $summary = First-Sentence $text
  $evidence = Get-Evidence $record.category $signals
  $needsReview = ($record.record_type -in @('report','report-data','probe-documentation')) -and ($summary -eq 'No readable source summary was extracted.')
  [pscustomobject]@{
    id = $record.id
    title = $record.title
    record_type = $record.record_type
    category = $record.category
    game = $record.game
    game_version = $record.game_version
    source_build = $record.source_build
    source_path = $record.source_path
    intended_site_destination = $record.intended_site_destination
    purpose = Get-Purpose $record $text
    extracted_summary = $summary
    headings = $headings
    evidence_signals = $signals
    provisional_evidence_level = $evidence
    technical_format = $record.source_extension
    content_length = $text.Length
    content_review_status = if ($needsReview) { 'needs-manual-review' } else { 'content-audited' }
    limitations = @('Automated extraction does not establish scientific validity.', 'Confirm conclusions against the original source and runtime context.')
    related_sections = $record.related_sections
  }
}

$records | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $data 'phase3-content-records.json')
$queue = $records | Where-Object content_review_status -eq 'needs-manual-review' | Select-Object id,title,record_type,category,source_path,content_length,provisional_evidence_level
$queue | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath (Join-Path $data 'phase3-manual-review-queue.csv')

$summary = $records | Group-Object record_type | Sort-Object Name | ForEach-Object {
  [pscustomobject]@{ record_type=$_.Name; records=$_.Count; audited=@($_.Group | Where-Object content_review_status -eq 'content-audited').Count; manual_review=@($_.Group | Where-Object content_review_status -eq 'needs-manual-review').Count; verified_signals=@($_.Group | Where-Object provisional_evidence_level -eq 'verified').Count; blocked_signals=@($_.Group | Where-Object provisional_evidence_level -eq 'blocked').Count }
}
$summary | ConvertTo-Json -Depth 4 | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $data 'phase3-content-summary.json')

$md = @"
# Phase 3 Content Audit and Record Preparation

Phase 3 inspected the source contents of every non-excluded Phase 2 record and created page-ready content metadata. The original `1.0` repository was not modified.

## Outputs

- `data/phase3-content-records.json` — normalized records with purpose, extracted summary, headings, evidence signals, and version metadata.
- `data/phase3-content-summary.json` — audit counts by record type.
- `data/phase3-manual-review-queue.csv` — records that require human interpretation before publication.

## Audit result

- Content records audited: $($records.Count)
- Records needing manual review: $(@($queue).Count)
- Records with no extractable headings or summary: $(@($records | Where-Object content_review_status -eq 'needs-manual-review').Count)
- Version baseline: Enshrouded 1.0.0.3 / build 39026384728

## Important evidence rule

Evidence levels in this phase are provisional signals extracted from source language. A word such as `verified`, `observed`, or `blocked` is not treated as proof by itself. The eventual public record must preserve the original wording, runtime/build context, method, limitations, and source path.

## Page template now available

Each public record can be rendered with:

1. Title and record type
2. Purpose
3. Source-backed summary
4. Game version and build
5. Source path and format
6. Evidence signals
7. Headings or source sections
8. Related records
9. Limitations
10. Link to the preserved source or full report

Phase 4 should use these records to repair the website indexes and generate consistent individual pages.
"@
$md | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $data 'phase3-content-audit.md')

Write-Output "Audited $($records.Count) records; manual review queue contains $(@($queue).Count) records."
