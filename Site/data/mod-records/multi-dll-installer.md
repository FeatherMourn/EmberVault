# Enshrouded Multi DLL Installer 3.3

## Short summary

This archive contains a standalone Windows installer application, not a gameplay DLL. It manages multiple native DLL mods by preserving the default root loader, renaming additional DLLs to numbered `dinput` variants, and maintaining an installer-owned chain configuration and recovery history.

## How it works

Static inspection identifies a Go/Windows GUI application with support for selecting the game folder, inspecting x64 DLLs, choosing a root DLL, renaming DLLs one at a time, and installing or uninstalling selected files. The embedded strings show numbered targets such as `dinput9.dll` through higher available numbers, a managed `DInputChain.mods` file, automatic next-name selection, backups, receipts, migration from legacy folders, and recovery records.

The installer also recognizes EML, M182 Panel Bridge, and an ASI-based numbered chain. It appears to distinguish the default game `dinput8.dll` from managed additional DLLs and protects its own backup, receipt, and support directories from archive overwrite. It validates archive paths, DLL architecture, export structure, file sizes, and destination containment before installation.

## Relationship to the current setup

The tool may solve a different problem than ModLoader Proxy: it manages multiple root-style DLLs through numbered chain targets rather than loading ordinary plugin DLLs from the current proxy `[Load]` list. It should not be run over the working installation without first recording its exact planned changes, because it may replace or rename the root loader and create its own chain-management files.

## Safety assessment

The embedded validation and recovery messages indicate a cautious design: preflight checks, backups, receipts, conflict detection, protected installer files, safe archive-path validation, and partial-install recovery. This is evidence of robust installer engineering, but not proof that every combination of ShroudForge, ModLoader Proxy, EML, Creative, and standalone `dinput8` mods is compatible.

## Reverse-engineering assessment

The installer is best understood as a native-loader orchestration tool. It does not make incompatible DLLs compatible; it gives each loader a managed filename and establishes a chain where the loaders support forwarding. Stat Sliders and ShroudHud would still need compatible forwarding behavior, and ShroudForge would need to remain reachable in the resulting chain.

## Confidence

- It is an installer/manager rather than a gameplay mod: high; archive contains only the executable and static inspection confirms the UI/installer strings.
- Numbered DLL chain and recovery behavior: high; directly supported by embedded strings.
- Exact chain order and compatibility with this installation: not established without running a staged install in a separate game copy.

