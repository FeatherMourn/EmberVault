# ShroudHud 1.7 — standalone archive

## Short summary

ShroudHud is a native HUD/editor mod distributed here as a standalone root `dinput8.dll`. It adds a HUD editor and preserves existing keys, layouts, and presets. The archive is not directly compatible with the current proxy as packaged because only one root `dinput8.dll` can occupy the game directory.

## How it works

The DLL acts as the game-level proxy and performs native UI/input integration. Embedded strings identify HUD/editor actions such as block, crafting, storage, workstation, chest, take-all, collect, and active-area interactions. F7 opens the HUD editor according to the README.

The author explicitly provides a ModLoader-edition integration path: use ModLoader Proxy as the root, place the ShroudHud mod DLL first in the proxy's `[Load]` list, then load other native DLL mods. The standalone edition and the ModLoader edition are separate deployment modes; they must not both be installed.

## Compatibility and limitations

- Package target: Steam build 26082781, corresponding to Enshrouded 1.0.0.3 in this environment.
- Only one ShroudHud edition should be used.
- The standalone package replaces the root loader and therefore conflicts with the current root ModLoader Proxy unless converted to the proper ModLoader edition.
- The README says offline native audits passed, but live gameplay validation for the stated build was still pending.
- Onslaught and patrol changes are not included in this release.

## Reverse-engineering assessment

This archive illustrates the difference between a standalone native proxy and a chainable native plugin. The DLL can own `dinput8.dll` by itself, but safe coexistence requires a separate build designed for ModLoader Proxy. It should not be renamed and inserted into the current chain without confirming its exports and initialization contract.

## Confidence

- Standalone deployment and conflict rules: high; directly documented.
- HUD/editor feature purpose: medium to high; supported by README and embedded strings.
- Exact native hooks and UI implementation: low without source or symbols.

## Current compatibility status

The user reports that ShroudHud does not currently work in the active ShroudForge setup. Treat the archive's standalone behavior as separate from live compatibility. The next investigation should inspect the proxy log and confirm whether a ModLoader-edition build is required before any adapter is attempted.

