[CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='High')]
param(
    [Parameter(Mandatory=$true)][ValidateSet('StatSliders-Client','RestoreShroudForge')][string]$Profile,
    [string]$GameRoot = 'H:\SteamLibrary\steamapps\common\Enshrouded',
    [string]$ProfileRoot = "$PSScriptRoot\profiles",
    [string]$BackupDirectory = "$PSScriptRoot\backups\20261022_083610"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if (Get-Process -Name enshrouded -ErrorAction SilentlyContinue) { throw 'Enshrouded must be closed before switching profiles.' }

if ($Profile -eq 'StatSliders-Client') {
    $source = Join-Path $ProfileRoot 'StatSliders-Client'
    if (-not (Test-Path -LiteralPath (Join-Path $source 'dinput8.dll'))) { throw 'Stat Sliders profile is not staged.' }
    $target = Join-Path $GameRoot 'dinput8.dll'
    if ($PSCmdlet.ShouldProcess($target, 'Activate isolated Stat Sliders root loader')) {
        Copy-Item -LiteralPath (Join-Path $source 'dinput8.dll') -Destination $target -Force
        if (Test-Path -LiteralPath (Join-Path $source 'Alternative_powrprof\powrprof.dll')) {
            New-Item -ItemType Directory -Force -Path (Join-Path $GameRoot 'Alternative_powrprof') | Out-Null
            Copy-Item -LiteralPath (Join-Path $source 'Alternative_powrprof\powrprof.dll') -Destination (Join-Path $GameRoot 'Alternative_powrprof\powrprof.dll') -Force
        }
        Write-Output 'Stat Sliders isolated profile activated. ShroudForge is not active in this profile.'
    }
}
else {
    if (-not (Test-Path -LiteralPath $BackupDirectory)) { throw "Backup directory not found: $BackupDirectory" }
    $source = Join-Path $BackupDirectory 'dinput8.dll'
    if (-not (Test-Path -LiteralPath $source)) { throw 'ShroudForge backup dinput8.dll is missing.' }
    $target = Join-Path $GameRoot 'dinput8.dll'
    if ($PSCmdlet.ShouldProcess($target, 'Restore ShroudForge root loader')) {
        Copy-Item -LiteralPath $source -Destination $target -Force
        Write-Output 'ShroudForge root loader restored from backup.'
    }
}
