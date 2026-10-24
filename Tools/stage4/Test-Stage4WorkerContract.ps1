param(
  [string]$PackageRoot = (Join-Path $PSScriptRoot '..\..\probes\embervault_census_workers_sf')
)

$ErrorActionPreference = 'Stop'
$checks = [System.Collections.Generic.List[string]]::new()
function Assert-Stage4([bool]$Condition, [string]$Message) {
  if (-not $Condition) { throw "Stage 4 contract failure: $Message" }
  $script:checks.Add($Message)
}

$manifest = Get-Content -Raw (Join-Path $PackageRoot 'mod.json') | ConvertFrom-Json
$extended = Get-Content -Raw (Join-Path $PackageRoot 'extended.mod.json') | ConvertFrom-Json
Assert-Stage4 ($manifest.id -eq 'embervault_census_workers_sf') 'stable ShroudForge package ID'
Assert-Stage4 ($manifest.version -eq '1.4.6') 'current package version'
Assert-Stage4 ($extended.launcher -eq 'SF' -and $extended.targets -contains 'client' -and $extended.enabled) 'ShroudForge client activation'

$root = Get-FileHash (Join-Path $PackageRoot 'mod.lua') -Algorithm SHA256
$src = Get-FileHash (Join-Path $PackageRoot 'src\mod.lua') -Algorithm SHA256
Assert-Stage4 ($root.Hash -eq $src.Hash) 'root and src entry points are identical'

$runtime = Get-Content -Raw (Join-Path $PackageRoot 'src\census_runtime_v144.lua')
$requiredWorkers = @(
  'player-context','player-state','slot-schema','inventory-links','inventory-scan',
  'linked-inventory-scan','item-state','equipment','default-inventory',
  'perk-container','weapon-gem-slot','equipment-links','appearance','attributes',
  'buffs','buildings','voxels','loot','pickup','localization','resources','saves'
)
foreach ($worker in $requiredWorkers) {
  Assert-Stage4 ($runtime -match ('scheduler:add\("' + [regex]::Escape($worker) + '"')) "worker contract: $worker"
}
Assert-Stage4 ($runtime -match 'status="unsupported"') 'explicit unsupported worker status'

$scheduler = Get-Content -Raw (Join-Path $PackageRoot 'src\ecs_read_scheduler.lua')
Assert-Stage4 ($scheduler -match 'result_status') 'worker result status is preserved in summary'
Assert-Stage4 ($scheduler -match 'max_total_seconds') 'global bounded deadline'
Assert-Stage4 ($scheduler -match 'function Scheduler:checkpoint') 'resumable scheduler checkpoint'

$entry = Get-Content -Raw (Join-Path $PackageRoot 'mod.lua')
foreach ($marker in @('export_identity=', 'stale_export_rule=', 'worker_graph_version=', 'reload_mode=', 'export_run_token=')) {
  Assert-Stage4 ($entry.Contains($marker)) "export marker: $marker"
}
Assert-Stage4 ($entry.Contains('checkpoint_model=')) 'checkpoint export marker'
Assert-Stage4 ($entry.Contains('differential_report=')) 'differential export marker'
Assert-Stage4 ($entry.Contains('worker_delta=')) 'differential worker records'

Write-Output ("PASS: {0} Stage 4 offline contract checks" -f $checks.Count)
$checks | ForEach-Object { Write-Output (" - " + $_) }
