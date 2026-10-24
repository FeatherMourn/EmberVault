$ErrorActionPreference = 'Stop'
$source = 'I:\My Drive\Enshrouded Mods\EmberVault_Research\Embervault_Researcher\1.0'
$output = 'I:\My Drive\Enshrouded Mods\EmberVault_Research\Embervault_Researcher\GitHub_Release\Site\EmberVault\Site\data'

New-Item -ItemType Directory -Force -Path $output | Out-Null

function Get-Classification($relative, $extension, $name) {
  $lower = $relative.ToLowerInvariant()
  $ext = $extension.ToLowerInvariant()
  $top = $relative.Split('\')[0].ToLowerInvariant()
  if ($lower -match '\\backups?\\|\\cache\\|\\logs?\\|\\bin\\|\\obj\\|\\temp\\|\\tmp\\' -or $ext -in '.dll','.pyc','.log') {
    return @{ Category='Generated or internal support'; Publication='Exclude'; Evidence='Supporting artifact'; Destination='archive/internal' }
  }
  if ($top -eq 'catalogs') { return @{ Category='Catalog'; Publication='Curate'; Evidence='Static evidence'; Destination='catalogs.html' } }
  if ($top -eq 'probes') { return @{ Category='Probe'; Publication='Curate'; Evidence='Instrument/source'; Destination='probe-library.html' } }
  if ($top -eq 'reports') { return @{ Category='Report'; Publication='Curate'; Evidence='Research record'; Destination='reports.html and report-pages/' } }
  if ($top -eq 'mods') { return @{ Category='Mod analysis'; Publication='Curate'; Evidence='Research record'; Destination='mods-tools.html' } }
  if ($top -eq 'methods') { return @{ Category='Method'; Publication='Curate'; Evidence='Procedure'; Destination='methods.html' } }
  if ($top -eq 'adapters') { return @{ Category='Adapter'; Publication='Curate'; Evidence='Technical record'; Destination='mods-tools.html' } }
  if ($top -eq 'loaders') { return @{ Category='Loader'; Publication='Curate'; Evidence='Compatibility record'; Destination='mods-tools.html' } }
  if ($top -eq 'provenance') { return @{ Category='Provenance'; Publication='Curate'; Evidence='Source metadata'; Destination='glossary.html' } }
  if ($top -eq 'tools') { return @{ Category='Tooling'; Publication='Review'; Evidence='Supporting artifact'; Destination='mods-tools.html or archive/internal' } }
  if ($ext -eq '.md') { return @{ Category='Project documentation'; Publication='Curate'; Evidence='Research context'; Destination='methods.html or glossary.html' } }
  if ($name -in 'metadata.json','registry.json') { return @{ Category='Project metadata'; Publication='Curate'; Evidence='Provenance metadata'; Destination='glossary.html' } }
  return @{ Category='Unclassified'; Publication='Review'; Evidence='Unknown'; Destination='Needs mapping' }
}

$records = foreach ($file in Get-ChildItem -LiteralPath $source -Recurse -File) {
  $relative = $file.FullName.Substring($source.Length + 1)
  $c = Get-Classification $relative $file.Extension $file.Name
  [pscustomobject]@{
    source_path = $relative
    file_name = $file.Name
    extension = $file.Extension.ToLowerInvariant()
    bytes = $file.Length
    category = $c.Category
    publication_status = $c.Publication
    evidence_role = $c.Evidence
    game = 'Enshrouded'
    game_version = '1.0.0.3'
    source_build = '39026384728'
    intended_site_destination = $c.Destination
    notes = if ($c.Publication -eq 'Exclude') { 'Retain locally; do not publish by default.' } else { 'Provisional classification; confirm during content review.' }
  }
}

$records | Sort-Object category, source_path | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath (Join-Path $output 'phase1-source-inventory.csv')

$summary = $records | Group-Object category | Sort-Object Name | ForEach-Object {
  [pscustomobject]@{ category=$_.Name; files=$_.Count; bytes=(($_.Group | Measure-Object bytes -Sum).Sum); curated=@($_.Group | Where-Object publication_status -eq 'Curate').Count; review=@($_.Group | Where-Object publication_status -eq 'Review').Count; excluded=@($_.Group | Where-Object publication_status -eq 'Exclude').Count }
}
$summary | ConvertTo-Json -Depth 4 | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $output 'phase1-inventory-summary.json')

$md = @"
# Phase 1 Source Classification and Wiki Mapping

This inventory maps every file in the original `1.0` research repository to a provisional EmberVault wiki destination. It was generated without modifying the source repository.

## Baseline

- Game: Enshrouded
- Game version: 1.0.0.3
- Source build: 39026384728
- Source repository: `I:\My Drive\Enshrouded Mods\EmberVault_Research\Embervault_Researcher\1.0`
- Detailed inventory: `data/phase1-source-inventory.csv`
- Summary: `data/phase1-inventory-summary.json`

## Classification rules

- **Curate**: suitable for a public research/wiki record after content review.
- **Review**: requires manual examination before publication or categorization.
- **Exclude**: local support material such as backups, logs, binaries, caches, and temporary output.

## Record mapping

| Source area | Wiki destination |
|---|---|
| Catalogs | Catalogs |
| Probes | Probe Library and individual probe pages |
| Reports | Reports A–Z and individual report pages |
| Mods | Mods and Tools |
| Methods | Methods |
| Adapters and loaders | Mods and Tools / compatibility records |
| Provenance and metadata | Glossary, record inspectors, and source panels |
| Tools | Mods and Tools or internal archive |
| Root documentation | Welcome, Methods, Glossary, and project documentation |

## Important limitation

This is a provisional classification based on path, filename, extension, and repository role. It is not yet a claim that every curated file is ready for public presentation. Phase 2 should review the content of each curated and review-status record, normalize titles and identifiers, and connect related reports, probes, catalogs, and methods.
"@
$md | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $output 'phase1-source-classification.md')

Write-Output "Generated $($records.Count) inventory records in $output"
