[CmdletBinding()]
param(
    [string]$Profile = "$PSScriptRoot\profiles\shroudforge-preview.json",
    [string]$GameRoot = 'H:\SteamLibrary\steamapps\common\Enshrouded',
    [string]$OutputDirectory = "$PSScriptRoot\reports"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$p = Get-Content -LiteralPath $Profile -Raw | ConvertFrom-Json
New-Item -ItemType Directory -Force -Path $OutputDirectory | Out-Null
$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$out = Join-Path $OutputDirectory "preview_$stamp.md"
$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add('# Dry-run loader preview')
$lines.Add('')
$lines.Add('This preview does not copy, rename, delete, or modify game files.')
$lines.Add('')
$lines.Add("Profile: $($p.name)")
$lines.Add("Root loader: $($p.rootLoader)")
$lines.Add("Forward target: $($p.forwardTo)")
$lines.Add('')
$lines.Add('## Native load order')
$i = 1
foreach ($dll in @($p.nativePlugins)) {
    $exists = Test-Path -LiteralPath (Join-Path $GameRoot $dll)
    $state = if ($exists) { 'present' } else { 'missing' }
    $lines.Add(("{0}. `{1}` — {2}" -f $i, $dll, $state))
    $i++
}
$lines.Add('')
$lines.Add('## Regular mod destinations')
foreach ($mod in @($p.regularMods)) {
    $dest = Join-Path $GameRoot $mod
    $state = if (Test-Path -LiteralPath $dest) { 'present' } else { 'not currently installed' }
    $lines.Add(("- `{0}` — {1}" -f $mod, $state))
}
$lines.Add('')
$lines.Add('## Blocked standalone loaders')
foreach ($loader in @($p.blockedLoaders)) { $lines.Add("- $loader — blocked in this ShroudForge profile") }
$lines.Add('')
$lines.Add('## Decision')
$lines.Add('- Preview only: no deployment authorized by this command.')
$lines.Add('- ShroudForge remains the primary loader.')
$lines.Add('- Standalone loaders require a separate profile.')
$lines | Set-Content -LiteralPath $out -Encoding UTF8
Write-Output "Preview written: $out"
