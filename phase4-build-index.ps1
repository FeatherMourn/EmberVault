$ErrorActionPreference = 'Stop'
$repo = 'I:\My Drive\Enshrouded Mods\EmberVault_Research\Embervault_Researcher\GitHub_Release\Site\EmberVault'
$site = Join-Path $repo 'Site'
$data = Join-Path $site 'data'
$records = Get-Content -Raw -LiteralPath (Join-Path $data 'phase3-content-records.json') | ConvertFrom-Json

function Get-PublicUrl($record) {
  if ($record.record_type -in @('report','report-data')) {
    $slug = [IO.Path]::GetFileName($record.source_path)
    $candidate = Join-Path $site ('report-pages\' + $slug + '.html')
    if (Test-Path -LiteralPath $candidate) { return 'report-pages/' + $slug + '.html' }
    return 'reports.html'
  }
  switch ($record.category) {
    'Probe' { return 'probe-library.html' }
    'Catalog' { return 'catalogs.html' }
    'Method' { return 'methods.html' }
    'Mod analysis' { return 'mods-tools.html' }
    'Adapter' { return 'mods-tools.html' }
    'Loader' { return 'mods-tools.html' }
    'Project documentation' { return 'methods.html' }
    'Project metadata' { return 'glossary.html' }
    'Provenance' { return 'glossary.html' }
    default { return 'glossary.html' }
  }
}

$public = foreach ($r in $records | Where-Object { $_.publication_status -ne 'Exclude' }) {
  [pscustomobject]@{
    id=$r.id; title=$r.title; record_type=$r.record_type; category=$r.category
    summary=$r.extracted_summary; purpose=$r.purpose; evidence=$r.provisional_evidence_level
    signals=($r.evidence_signals -join ', '); source_path=$r.source_path
    game_version=$r.game_version; source_build=$r.source_build
    url=(Get-PublicUrl $r); technical_format=$r.technical_format
    keywords=(($r.keywords + ' ' + $r.title + ' ' + $r.extracted_summary) -replace '\s+',' ').Trim().ToLowerInvariant()
    status=$r.content_review_status
  }
}
$public | Sort-Object title | ConvertTo-Json -Depth 6 | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $data 'site-index.json')

$byCategory = $public | Group-Object category | Sort-Object Name | ForEach-Object {
  [pscustomobject]@{ category=$_.Name; count=$_.Count; records=@($_.Group | Sort-Object title | Select-Object id,title,record_type,evidence,url) }
}
$byCategory | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $data 'site-category-index.json')

$reportPages = @(Get-ChildItem -LiteralPath (Join-Path $site 'report-pages') -Filter *.html -File -ErrorAction SilentlyContinue).Count
$reportRecords = @($public | Where-Object record_type -in @('report','report-data')).Count
$coverage = [pscustomobject]@{
  normalized_records=$records.Count
  public_index_records=$public.Count
  excluded_records=@($records | Where-Object publication_status -eq 'Exclude').Count
  report_records=$reportRecords
  report_pages=$reportPages
  records_with_dedicated_report_page=@($public | Where-Object { $_.url -like 'report-pages/*' }).Count
  records_using_category_page=@($public | Where-Object { $_.url -notlike 'report-pages/*' }).Count
  game='Enshrouded'
  game_version='1.0.0.3'
  source_build='39026384728'
}
$coverage | ConvertTo-Json -Depth 4 | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $data 'phase4-site-coverage.json')

$md = @"
# Phase 4 Site Integration Audit

Phase 4 generated the canonical public index from the Phase 3 content records and connected each non-excluded record to a public destination.

## Generated indexes

- `data/site-index.json` — searchable public record index.
- `data/site-category-index.json` — category-grouped index for library pages.
- `data/phase4-site-coverage.json` — page coverage and version audit.

## Canonical destinations

- Reports and report data → `reports.html` or individual `report-pages/` pages.
- Probes → `probe-library.html`.
- Catalogs → `catalogs.html`.
- Methods and project documentation → `methods.html`.
- Mods, adapters, and loaders → `mods-tools.html`.
- Provenance and metadata → `glossary.html`.

## Version boundary

All indexed public records are labeled Enshrouded `1.0.0.3`, source build `39026384728`.

## Remaining limitation

The index is now canonical, but some categories still point several source records to a category landing page rather than dedicated detail pages. Phase 5 should generate individual pages for probes, catalogs, methods, adapters, loaders, and mod analyses where the source material warrants it.
"@
$md | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $data 'phase4-site-integration.md')

Write-Output "Indexed $($public.Count) public records and generated category and coverage indexes."
