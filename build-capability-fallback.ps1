$site = 'I:\My Drive\Enshrouded Mods\EmberVault_Research\Embervault_Researcher\GitHub_Release\Site\EmberVault\Site'
$records = Get-Content -Raw -LiteralPath (Join-Path $site 'data\site-index.json')
"window.EMBERVAULT_SITE_INDEX = $records;" | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $site 'data\capability-index.js')
Write-Output 'Generated data/capability-index.js'
