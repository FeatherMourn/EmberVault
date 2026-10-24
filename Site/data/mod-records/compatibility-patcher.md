# Compatibility Patcher for Windows 2.0

## Short summary

This archive is a guarded installer kit for a ShroudForge-plus-Creative chainloader. It does not contain a gameplay mod. It verifies a candidate ShroudForge `dinput8.dll`, backs up existing loader files, stores the candidate as the original ShroudForge DLL, and installs `creative_chainloader.dll` as the root `dinput8.dll`.

## How it works

`INSTALL_OR_UPDATE.cmd` requires the kit to be beside `enshrouded.exe`, refuses to run while the game is active, checks that the chainloader and verifier exist, and optionally accepts a new DLL as its first argument. `Verify-ShroudForge.ps1` parses the PE headers and requires a 64-bit DLL with a specific eight-export layout and expected ordinals. If any check fails, the installer refuses to overwrite the loader.

When validation passes, the installer backs up the current original and root DLL, copies the candidate to `shroudforge_original.dll`, and installs the kit's chainloader as `dinput8.dll`. `RESTORE_SHROUDFORGE.cmd` reverses that arrangement only when the current root DLL matches the kit's known chainloader, avoiding overwrite of an unknown loader.

## Safety assessment

The scripts are operationally cautious: they require the game to be closed, verify paths, create timestamped backups, validate the PE architecture and exports, and check copied files. They still modify the game's root loader when run, so they must not be used alongside the current ModLoader Proxy without understanding which loader owns `dinput8.dll`.

## Reverse-engineering assessment

This is a loader-management tool, not a mod framework. Its central compatibility contract is the exact export table of the ShroudForge DLL. It is useful for understanding how Creative was previously chained, but installing it over the current proxy would replace the root loader and could disrupt the present native-mod chain.

## Confidence

- Script behavior: high; directly inspected.
- Intended loader layout: high; directly shown by the scripts.
- Compatibility with the current ModLoader Proxy chain: not established; do not combine blindly.

