# Unified Loader Scanner — Prototype

This is Milestone 1 of the unified loader manager. It is intentionally read-only.

## What it checks

- ZIP archives and extracted directories in the research Mods folder.
- DLL presence and likely classification.
- Root-loader names such as `dinput8.dll`, `winmm.dll`, and `dbghelp.dll`.
- Alternate loader names `dsound.dll`, `powrprof.dll`, and `version.dll`.
- Common manifests and loader configuration files.
- Unsafe archive paths such as absolute paths or parent-directory traversal.
- The game installation as a high-level directory record.

## What it does not do

- It does not install, copy, rename, delete, or patch files.
- It does not load DLLs.
- It does not claim that a DLL is compatible merely because it is a valid PE file.
- It does not change ShroudForge or the active proxy chain.

## Run

From PowerShell:

```powershell
Set-Location 'I:\My Drive\Enshrouded Mods\EmberVault_Research\Embervault_Researcher\1.0\tools\UnifiedLoaderScanner'
.\UnifiedLoaderScanner.ps1
```

Reports are written under `reports` as timestamped JSON and CSV files. A later milestone can add PE architecture/export inspection and a human-readable proposed load plan.

## Dry-run preview

The preview script reads a profile and reports the proposed root loader, forwarding target, native load order, regular mod destinations, and blocked standalone loaders. It does not modify the game:

```powershell
.\New-LoaderPreview.ps1
```

## Backup and restore

Create a timestamped backup of the current loader and selected active mod paths:

```powershell
.\New-LoaderBackup.ps1
```

Restore requires an explicit backup directory and confirmation. It is not run automatically by the scanner:

```powershell
.\Restore-LoaderBackup.ps1 -BackupDirectory '.\backups\YYYYMMDD_HHMMSS' -WhatIf
```
