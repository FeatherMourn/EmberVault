[CmdletBinding()]
param(
    [string]$ResearchMods = 'H:\enshroudedresearch\Mods',
    [string]$GameRoot = 'H:\SteamLibrary\steamapps\common\Enshrouded',
    [string]$OutputDirectory = "$PSScriptRoot\reports"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$rootLoaderNames = @('dinput8.dll', 'winmm.dll', 'dbghelp.dll', 'dsound.dll', 'powrprof.dll', 'version.dll')
$knownConfigNames = @('mod.json', 'eml.json', 'shroudtopia.json', 'chainloader.ini', 'native-plugin.ini')

function Get-Classification([string[]]$RelativeFiles) {
    $dlls = @($RelativeFiles | Where-Object { $_ -match '(?i)\.dll$' })
    $rootDlls = @($dlls | Where-Object { $rootLoaderNames -contains ([IO.Path]::GetFileName($_).ToLowerInvariant()) })
    if ($rootDlls.Count -gt 0) { return 'Standalone or mixed loader' }
    if ($dlls.Count -gt 0) { return 'Native plugin candidate' }
    return 'Regular Lua/EML/config/asset mod'
}

function Get-UnsafeArchiveEntries([string]$ArchivePath) {
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $zip = [IO.Compression.ZipFile]::OpenRead($ArchivePath)
    try {
        @($zip.Entries | Where-Object {
            $n = $_.FullName.Replace('\', '/')
            $n.StartsWith('/') -or $n -match '(^|/)\.\.(\/|$)' -or $n -match '^[A-Za-z]:/'
        } | ForEach-Object { $_.FullName })
    } finally { $zip.Dispose() }
}

function Get-PeInfo([string]$Path) {
    try {
        $b = [IO.File]::ReadAllBytes($Path)
        if ($b.Length -lt 64 -or $b[0] -ne 0x4D -or $b[1] -ne 0x5A) { return [pscustomobject]@{ Path=$Path; IsPE=$false; Architecture='Not PE'; ExportCount=0; ExportNames='' } }
        $pe = [BitConverter]::ToInt32($b, 0x3C)
        if ($pe -lt 0 -or $pe + 24 -gt $b.Length -or [BitConverter]::ToUInt32($b, $pe) -ne 0x4550) { return [pscustomobject]@{ Path=$Path; IsPE=$false; Architecture='Invalid PE'; ExportCount=0; ExportNames='' } }
        $machine = [BitConverter]::ToUInt16($b, $pe + 4)
        $sections = [BitConverter]::ToUInt16($b, $pe + 6)
        $optSize = [BitConverter]::ToUInt16($b, $pe + 20)
        $opt = $pe + 24
        $magic = [BitConverter]::ToUInt16($b, $opt)
        $architecture = if ($machine -eq 0x8664 -and $magic -eq 0x20B) { 'x64 PE32+' } elseif ($machine -eq 0x14C -and $magic -eq 0x10B) { 'x86 PE32' } else { ('machine 0x{0:X4}, optional 0x{1:X4}' -f $machine,$magic) }
        $dataDir = $opt + $(if ($magic -eq 0x20B) { 112 } else { 96 })
        $exportRva = [BitConverter]::ToUInt32($b, $dataDir)
        $exportSize = [BitConverter]::ToUInt32($b, $dataDir + 4)
        $sectionBase = $opt + $optSize
        function Convert-Rva([uint32]$rva) {
            for ($i=0; $i -lt $sections; $i++) {
                $s = $sectionBase + (40 * $i)
                $va = [BitConverter]::ToUInt32($b, $s + 12)
                $raw = [BitConverter]::ToUInt32($b, $s + 20)
                $size = [Math]::Max([BitConverter]::ToUInt32($b, $s + 8), [BitConverter]::ToUInt32($b, $s + 16))
                if ($rva -ge $va -and $rva -lt ($va + $size)) { return $raw + ($rva - $va) }
            }
            return -1
        }
        $names = @()
        if ($exportRva -ne 0 -and $exportSize -ne 0) {
            $eo = Convert-Rva $exportRva
            if ($eo -ge 0 -and $eo + 40 -lt $b.Length) {
                $count = [BitConverter]::ToUInt32($b, $eo + 24)
                $nameRva = [BitConverter]::ToUInt32($b, $eo + 32)
                $no = Convert-Rva $nameRva
                if ($no -ge 0) {
                    for ($i=0; $i -lt [Math]::Min($count, 64); $i++) {
                        $nr = [BitConverter]::ToUInt32($b, $no + 4*$i); $o = Convert-Rva $nr
                        if ($o -ge 0) { $names += [Text.Encoding]::ASCII.GetString($b, $o, [Array]::IndexOf($b, [byte]0, $o) - $o) }
                    }
                }
            }
        }
        [pscustomobject]@{ Path=$Path; IsPE=$true; Architecture=$architecture; ExportCount=$names.Count; ExportNames=($names -join '; ') }
    } catch { [pscustomobject]@{ Path=$Path; IsPE=$false; Architecture='Inspection error'; ExportCount=0; ExportNames='' } }
}

function Get-ArchiveRecord([IO.FileInfo]$File) {
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $zip = [IO.Compression.ZipFile]::OpenRead($File.FullName)
    try {
        $files = @($zip.Entries | Where-Object { -not $_.FullName.EndsWith('/') } | ForEach-Object { $_.FullName })
        $dlls = @($files | Where-Object { $_ -match '(?i)\.dll$' })
        $unsafe = @(Get-UnsafeArchiveEntries $File.FullName)
        [pscustomobject]@{
            Name = $File.Name
            Kind = 'Archive'
            Classification = Get-Classification $files
            Path = $File.FullName
            FileCount = $files.Count
            DLLs = ($dlls -join '; ')
            HasManifest = [bool]($files | Where-Object { $knownConfigNames -contains ([IO.Path]::GetFileName($_).ToLowerInvariant()) })
            UnsafeEntries = ($unsafe -join '; ')
            Status = if ($unsafe.Count -gt 0) { 'Blocked: unsafe archive path' } else { 'Reviewable' }
        }
    } finally { $zip.Dispose() }
}

function Get-DirectoryRecord([IO.DirectoryInfo]$Directory, [string]$BasePath) {
    $files = @(Get-ChildItem -LiteralPath $Directory.FullName -Recurse -File | ForEach-Object { $_.FullName.Substring($BasePath.Length).TrimStart('\', '/') })
    $dlls = @($files | Where-Object { $_ -match '(?i)\.dll$' })
    [pscustomobject]@{
        Name = $Directory.Name
        Kind = 'Directory'
        Classification = Get-Classification $files
        Path = $Directory.FullName
        FileCount = $files.Count
        DLLs = ($dlls -join '; ')
        HasManifest = [bool]($files | Where-Object { $knownConfigNames -contains ([IO.Path]::GetFileName($_).ToLowerInvariant()) })
        UnsafeEntries = ''
        Status = 'Reviewable'
    }
}

New-Item -ItemType Directory -Force -Path $OutputDirectory | Out-Null
$records = [System.Collections.Generic.List[object]]::new()
$dllRecords = [System.Collections.Generic.List[object]]::new()

if (Test-Path -LiteralPath $ResearchMods) {
    foreach ($file in @(Get-ChildItem -LiteralPath $ResearchMods -File -Filter '*.zip')) {
        $records.Add((Get-ArchiveRecord $file))
    }
    foreach ($dir in @(Get-ChildItem -LiteralPath $ResearchMods -Directory)) {
        $records.Add((Get-DirectoryRecord $dir $ResearchMods))
        foreach ($dll in @(Get-ChildItem -LiteralPath $dir.FullName -Recurse -File -Filter '*.dll')) { $dllRecords.Add((Get-PeInfo $dll.FullName)) }
    }
}

if (Test-Path -LiteralPath $GameRoot) {
    $records.Add((Get-DirectoryRecord (Get-Item -LiteralPath $GameRoot) $GameRoot))
    foreach ($dll in @(Get-ChildItem -LiteralPath $GameRoot -Recurse -File -Filter '*.dll')) { $dllRecords.Add((Get-PeInfo $dll.FullName)) }
}

$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$jsonPath = Join-Path $OutputDirectory "scan_$stamp.json"
$csvPath = Join-Path $OutputDirectory "scan_$stamp.csv"
$records | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $jsonPath -Encoding UTF8
$records | Export-Csv -LiteralPath $csvPath -NoTypeInformation -Encoding UTF8
$dllPath = Join-Path $OutputDirectory "dlls_$stamp.json"
$dllRecords | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $dllPath -Encoding UTF8

$loadPath = Join-Path $OutputDirectory "proposed-shroudforge-load-order_$stamp.md"
$pluginDlls = @($dllRecords | Where-Object { $_.Architecture -eq 'x64 PE32+' -and $_.Path -match '(?i)\\(mods|creative|M182_Client)\\' -and $_.Path -notmatch '(?i)(dinput8|winmm|dbghelp|shroudtopia|statsliders|shroudhud)' })
$standaloneDlls = @($dllRecords | Where-Object { $_.Path -match '(?i)(dinput8|winmm|dbghelp|shroudtopia|statsliders|shroudhud)' })
@"
# Proposed ShroudForge load order

This is a read-only proposal generated by UnifiedLoaderScanner. It does not change the game installation.

Recognized root-loader names: $($rootLoaderNames -join ', ').

## Root

1. Keep the current ShroudForge-compatible root proxy in place.
2. Keep ShroudForge as the forwarded loader.

## Candidate native plugins

$(if ($pluginDlls.Count -gt 0) { ($pluginDlls | ForEach-Object { '- ' + $_.Path + ' — ' + $_.Architecture + ', exports: ' + $_.ExportCount }) -join "`n" } else { '- No x64 plugin candidates were found in the scanned extracted directories.' })

## Standalone or root-loader candidates

$(if ($standaloneDlls.Count -gt 0) { ($standaloneDlls | ForEach-Object { '- ' + $_.Path + ' — isolate in a separate profile unless separately validated.' }) -join "`n" } else { '- None found.' })

## Recommended activation order

1. ShroudForge root/forwarding path.
2. Creative Mode native plugin, if validated for the current build.
3. XHL Area Harvest.
4. XHL Enemy Difficulty Limits.
5. M182 Panel.
6. EML/Lua mods through the game `mods` folder.

The scanner does not automatically resolve hook conflicts or prove runtime compatibility. Review this proposal before any deployment.
"@ | Set-Content -LiteralPath $loadPath -Encoding UTF8

Write-Output "Read-only scan complete. Records: $($records.Count)"
Write-Output "JSON report: $jsonPath"
Write-Output "CSV report:  $csvPath"
Write-Output "DLL report:  $dllPath"
Write-Output "Load plan:   $loadPath"
