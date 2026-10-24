# Shroudweave Shroudtopia 0.2.1

## Short summary

Shroudtopia is a standalone Windows x64 compatibility loader used by the minimap and related native mods. This community build includes both `winmm.dll` and `shroudtopia.dll`, keeps an existing JSON configuration, and adds a compatibility change for Creative Mode 3.0.0.

## How it is built

- `winmm.dll`: root WinMM proxy.
- `shroudtopia.dll`: native loader and mod-discovery layer.
- `shroudtopia.json`: user configuration, intentionally omitted from this archive so an existing configuration is not overwritten.
- Example JSON: defaults to an empty mod list.
- Build metadata and SHA-256 manifest: identify the build and packaged DLLs.

The loader discovers supported native manifests and skips Flame-owned or malformed manifests before attempting to load them. This is the compatibility mechanism that lets Creative Mode use its separate Flame/proxy path.

## Compatibility notes

- Requires both root DLLs and therefore competes directly with other root loader systems.
- The release notes specifically claim compatibility with Creative Mode 3.0.0 and in-game validation of the minimap's visibility and controls.
- The Minimap archive is installed separately under `mods/minimap_mod`.
- The package does not include Creative Mode or the minimap itself.

## Why it is not active

The current installation uses ModLoader Proxy as the root owner and forwards to ShroudForge. Installing Shroudtopia would replace or compete for the root `winmm.dll`/loader path, so it was rolled back previously. The archive should be treated as an alternative loader stack, not layered on top of the working ShroudForge chain without a dedicated backup and test profile.

## Evidence level

**Verified from archive:** required DLLs, configuration policy, manifest filtering behavior, Creative compatibility claim, minimap relationship, validation scope, and backup instructions.

**Not verified in this audit:** coexistence with the current ModLoader Proxy chain or compatibility with all active native plugins.
