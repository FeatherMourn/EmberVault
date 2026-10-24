$ErrorActionPreference = 'Stop'
$source = 'I:\My Drive\Enshrouded Mods\EmberVault_Research\Embervault_Researcher\1.0'
$repo = 'I:\My Drive\Enshrouded Mods\EmberVault_Research\Embervault_Researcher\GitHub_Release\Site\EmberVault'
$site = Join-Path $repo 'Site'; $data = Join-Path $site 'data'; $codeDir = Join-Path $site 'code'
New-Item -ItemType Directory -Force -Path $codeDir | Out-Null
$records = Get-Content -Raw (Join-Path $data 'phase3-content-records.json') | ConvertFrom-Json
$extensions = @('.lua','.ps1','.py','.ini','.csv','.txt')
function Encode($value) { [System.Net.WebUtility]::HtmlEncode([string]$value) }
$codeRecords = @($records | Where-Object { $_.publication_status -ne 'Exclude' -and $_.record_type -notin @('report','report-data') })
$style = '<style>body{background:#0a1718;color:#cbd2ce}.source-page{max-width:1250px;margin:0 auto;padding:2rem}.source-page h1{color:#e8dcc8}.source-path{color:#aebdb8}.editor{border:1px solid rgba(180,210,205,.25);border-radius:8px;overflow:hidden;background:#071113;box-shadow:0 18px 50px rgba(0,0,0,.25)}.editor-bar{background:#183133;border-bottom:1px solid rgba(180,210,205,.25);padding:.75rem 1rem;display:flex;gap:.55rem;align-items:center;font:12px Consolas,monospace;color:#adc3be}.dot{width:10px;height:10px;border-radius:50%;display:inline-block}.red{background:#d76e68}.yellow{background:#d7ad62}.green{background:#82b58b}.readonly{margin-left:auto;text-transform:uppercase;letter-spacing:.14em;font-size:10px}.code-wrap{overflow:auto;max-height:72vh}.code-lines{min-width:760px;padding:1rem 0;font:14px/1.65 Consolas,''Cascadia Code'',monospace;white-space:pre}.line{display:block}.ln{display:inline-block;width:5.5em;text-align:right;padding-right:1.3em;color:#4e7370;user-select:none}.code{color:#d9e3df}.source-meta{display:flex;gap:1rem;flex-wrap:wrap;margin:1rem 0;color:#aebdb8}.source-meta span{border:1px solid rgba(180,210,205,.2);padding:.5rem .7rem}@media(max-width:700px){.source-page{padding:1rem}.code-lines{font-size:12px}}</style>'
foreach ($r in $codeRecords) {
  $path = Join-Path $source $r.source_path
  if (!(Test-Path -LiteralPath $path)) { continue }
  $lines = (Get-Content -Raw -LiteralPath $path) -split "`r?`n"
  $body = for ($i=0; $i -lt $lines.Count; $i++) { '<span class="line"><span class="ln">' + ($i + 1).ToString().PadLeft(4,'0') + '</span><span class="code">' + (Encode $lines[$i]) + '</span></span>' }
  $id = Encode $r.id
  $html = @"
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>$(Encode $r.title) · Source · EmberVault</title><link rel="stylesheet" href="../styles.css"><link rel="stylesheet" href="../dark.css">$style</head><body><header class="topbar"><a class="brand" href="../index.html">EMBER<span>VAULT</span></a><nav><a href="../index.html">Welcome</a><a href="../library.html">Library</a><a href="../records/$id.html">Record</a><a href="javascript:history.back()">← Back</a></nav></header><main class="source-page"><a class="text-link" href="../records/$id.html">← Record summary</a><p class="eyebrow">Read-only source view · $(Encode $r.record_type)</p><h1>$(Encode $r.title)</h1><p class="source-path">Original source: <code>$(Encode $r.source_path)</code></p><div class="source-meta"><span>Enshrouded $(Encode $r.game_version)</span><span>Build $(Encode $r.source_build)</span><span>Format $(Encode $r.technical_format)</span></div><section class="editor"><div class="editor-bar"><i class="dot red"></i><i class="dot yellow"></i><i class="dot green"></i><span>$(Encode $r.source_path)</span><span class="readonly">Read only</span></div><div class="code-wrap"><div class="code-lines">$($body -join "`n")</div></div></section></main><footer><span>EMBERVAULT / SOURCE VIEW</span><span>Read-only research</span></footer></body></html>
"@
  $html | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $codeDir ($r.id + '.html'))
}
[pscustomobject]@{code_records=$codeRecords.Count;code_pages=(Get-ChildItem $codeDir -Filter *.html -File).Count;extensions=($extensions -join ', ');game_version='1.0.0.3'} | ConvertTo-Json | Set-Content -Encoding UTF8 (Join-Path $data 'phase6-code-page-coverage.json')
Write-Output "Generated $($codeRecords.Count) code pages."
