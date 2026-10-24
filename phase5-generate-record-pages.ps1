$ErrorActionPreference = 'Stop'
$repo = 'I:\My Drive\Enshrouded Mods\EmberVault_Research\Embervault_Researcher\GitHub_Release\Site\EmberVault'
$site = Join-Path $repo 'Site'
$data = Join-Path $site 'data'
$recordsDir = Join-Path $site 'records'
New-Item -ItemType Directory -Force -Path $recordsDir | Out-Null
$records = Get-Content -Raw -LiteralPath (Join-Path $data 'phase3-content-records.json') | ConvertFrom-Json
$public = @($records | Where-Object { $_.publication_status -ne 'Exclude' })

function Html($value) { [System.Net.WebUtility]::HtmlEncode([string]$value) }
function CategoryUrl($category) {
  switch ($category) {
    'Probe' { 'probe-library.html' }; 'Catalog' { 'catalogs.html' }; 'Method' { 'methods.html' }
    'Mod analysis' { 'mods-tools.html' }; 'Adapter' { 'mods-tools.html' }; 'Loader' { 'mods-tools.html' }
    'Project documentation' { 'methods.html' }; 'Project metadata' { 'glossary.html' }; 'Provenance' { 'glossary.html' }
    default { 'library.html' }
  }
}

$detailRecords = @($public | Where-Object { $_.record_type -notin @('report','report-data') })
foreach ($record in $detailRecords) {
  $filename = $record.id + '.html'
  $sourceLink = ''
  if ($record.record_type -notin @('report','report-data')) { $sourceLink = "<p><a class='primary-action' href='../code/$($record.id).html'>Open read-only source view</a></p>" }
  $signals = if (@($record.evidence_signals).Count) { (@($record.evidence_signals) | ForEach-Object { '<span class="tag">' + (Html $_) + '</span>' }) -join ' ' } else { '<span class="muted">No explicit signal extracted</span>' }
  $headings = if (@($record.headings).Count) { '<ul>' + ((@($record.headings) | ForEach-Object { '<li>' + (Html $_) + '</li>' }) -join '') + '</ul>' } else { '<p class="muted">No Markdown headings were present in the source format.</p>' }
  $html = @"
<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>$(Html $record.title) · EmberVault</title><link rel="stylesheet" href="../styles.css"><link rel="stylesheet" href="../dark.css">
<style>.record-detail{max-width:1100px;margin:0 auto;padding:2rem}.record-meta{display:grid;grid-template-columns:repeat(auto-fit,minmax(210px,1fr));gap:1rem;margin:2rem 0}.record-meta div,.record-panel{border:1px solid rgba(180,210,205,.2);padding:1rem;background:rgba(13,28,29,.72)}.record-panel{margin:1.25rem 0}.tag{display:inline-block;padding:.35rem .55rem;margin:.2rem;border:1px solid rgba(222,166,75,.45);color:#e2c48f}.muted{color:#aab9b5}code{overflow-wrap:anywhere}</style></head>
<body><header class="topbar"><a class="brand" href="../index.html">EMBER<span>VAULT</span></a><nav><a href="../index.html">Welcome</a><a href="../library.html">Library</a><a href="$(CategoryUrl $record.category)">$(Html $record.category)</a><a href="javascript:history.back()">← Back</a></nav></header>
<main class="record-detail"><a class="text-link" href="$(CategoryUrl $record.category)">← Return to $(Html $record.category)</a><p class="eyebrow">$(Html $record.category) · $(Html $record.record_type)</p><h1>$(Html $record.title)</h1><p class="lead">$(Html $record.purpose)</p>
<div class="record-meta"><div><strong>Game</strong><br>$(Html $record.game)</div><div><strong>Version</strong><br>$(Html $record.game_version)</div><div><strong>Source build</strong><br>$(Html $record.source_build)</div><div><strong>Evidence</strong><br>$(Html $record.provisional_evidence_level)</div><div><strong>Format</strong><br>$(Html $record.technical_format)</div></div>
<section class="record-panel"><p class="eyebrow">Source-backed summary</p><p>$(Html $record.extracted_summary)</p></section>
<section class="record-panel"><p class="eyebrow">Evidence signals</p><div>$signals</div></section>
<section class="record-panel"><p class="eyebrow">Source sections</p>$headings</section>
<section class="record-panel"><p class="eyebrow">Provenance</p><p><code>$(Html $record.source_path)</code></p><p class="muted">This record is associated with Enshrouded $(Html $record.game_version) and source build $(Html $record.source_build).</p>$sourceLink</section>
<section class="record-panel"><p class="eyebrow">Limitations</p><ul><li>Automated extraction does not establish scientific validity.</li><li>Confirm conclusions against the original source and runtime context.</li><li>This page is a normalized research record, not a claim that every referenced capability is verified.</li></ul></section>
</main><footer><span>EMBERVAULT / RESEARCH RECORD</span><span>Evidence before assumptions</span></footer></body></html>
"@
  $html | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $recordsDir $filename)
}

$index = foreach ($record in $public) {
  if ($record.record_type -in @('report','report-data')) {
    $reportSlug = [IO.Path]::GetFileName($record.source_path)
    $reportCandidate = Join-Path $site ('report-pages\' + $reportSlug + '.html')
    $url = if (Test-Path -LiteralPath $reportCandidate) { 'report-pages/' + $reportSlug + '.html' } else { 'reports.html' }
  } else { $url = 'records/' + $record.id + '.html' }
  [pscustomobject]@{ id=$record.id; title=$record.title; record_type=$record.record_type; category=$record.category; summary=$record.extracted_summary; purpose=$record.purpose; evidence=$record.provisional_evidence_level; signals=(@($record.evidence_signals) -join ', '); source_path=$record.source_path; game_version=$record.game_version; source_build=$record.source_build; url=$url; technical_format=$record.technical_format; keywords=(($record.keywords + ' ' + $record.title + ' ' + $record.extracted_summary) -replace '\s+',' ').Trim().ToLowerInvariant(); status=$record.content_review_status }
}
$index | Sort-Object title | ConvertTo-Json -Depth 6 | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $data 'site-index.json')
$index | Group-Object category | Sort-Object Name | ForEach-Object { [pscustomobject]@{category=$_.Name;count=$_.Count;records=@($_.Group|Sort-Object title|Select-Object id,title,record_type,evidence,url)} } | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $data 'site-category-index.json')

$audit = [pscustomobject]@{ total_public_records=$index.Count; dedicated_detail_pages=@($detailRecords).Count; report_records=@($index|Where-Object record_type -in @('report','report-data')).Count; records_directory=(Get-ChildItem -LiteralPath $recordsDir -Filter *.html -File).Count; game='Enshrouded'; game_version='1.0.0.3'; source_build='39026384728' }
$audit | ConvertTo-Json -Depth 4 | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $data 'phase5-page-coverage.json')
$md = @"
# Phase 5 Dedicated Record Pages

Phase 5 generated individual detail pages for technical and research records that previously pointed only to category landing pages.

- Public records: $($index.Count)
- Dedicated technical detail pages: $(@($detailRecords).Count)
- Report records: $(@($index|Where-Object record_type -in @('report','report-data')).Count)
- Detail page directory: `records/`
- Version baseline: Enshrouded 1.0.0.3 / build 39026384728

Each detail page includes purpose, summary, evidence signals, source sections, provenance, version/build metadata, limitations, and category/back navigation.

Reports remain in the dedicated report archive because they have their own three-column inspector workflow and preserved full-report pages.
"@
$md | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $data 'phase5-dedicated-pages.md')
Write-Output "Generated $(@($detailRecords).Count) dedicated record pages."
