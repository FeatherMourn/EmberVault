[CmdletBinding()]
param(
    [string]$GameRoot = 'H:\SteamLibrary\steamapps\common\Enshrouded',
    [string]$BackupRoot = "$PSScriptRoot\backups",
    [string[]]$RelativePaths = @('dinput8.dll','winmm.dll','dbghelp.dll','chainloader.ini','creative','mods','M182_Client','shroudforge-original')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$destination = Join-Path $BackupRoot $stamp
New-Item -ItemType Directory -Force -Path $destination | Out-Null
$manifest = [System.Collections.Generic.List[object]]::new()

foreach ($relative in $RelativePaths) {
    $source = Join-Path $GameRoot $relative
    if (-not (Test-Path -LiteralPath $source)) {
        $manifest.Add([pscustomobject]@{ RelativePath=$relative; Status='Missing'; Source=$source; BackupPath='' })
        continue
    }
    $target = Join-Path $destination $relative
    $parent = Split-Path -Parent $target
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
    Copy-Item -LiteralPath $source -Destination $target -Recurse -Force
    $manifest.Add([pscustomobject]@{ RelativePath=$relative; Status='Backed up'; Source=$source; BackupPath=$target })
}

$manifestPath = Join-Path $destination 'backup-manifest.json'
$manifest | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $manifestPath -Encoding UTF8
Write-Output "Backup created: $destination"
Write-Output "Manifest: $manifestPath"
