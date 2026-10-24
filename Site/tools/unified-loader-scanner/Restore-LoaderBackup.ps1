[CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='High')]
param(
    [Parameter(Mandatory=$true)][string]$BackupDirectory,
    [string]$GameRoot = 'H:\SteamLibrary\steamapps\common\Enshrouded'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$manifestPath = Join-Path $BackupDirectory 'backup-manifest.json'
if (-not (Test-Path -LiteralPath $manifestPath)) { throw "Backup manifest not found: $manifestPath" }
$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
foreach ($item in @($manifest | Where-Object Status -eq 'Backed up')) {
    $source = Join-Path $BackupDirectory $item.RelativePath
    $target = Join-Path $GameRoot $item.RelativePath
    if ($PSCmdlet.ShouldProcess($target, "Restore from backup")) {
        if (Test-Path -LiteralPath $target) { Remove-Item -LiteralPath $target -Recurse -Force }
        $parent = Split-Path -Parent $target
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
        Copy-Item -LiteralPath $source -Destination $target -Recurse -Force
    }
}
Write-Output "Restore completed from: $BackupDirectory"
