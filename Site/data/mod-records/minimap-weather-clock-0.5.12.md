# Minimap and Weather Clock 0.5.12

## Short summary

This archive is the Sparkweave community fork of the Enshrouded Minimap. It combines a native `minimap_mod.dll`, Lua configuration, map assets, and Shroudtopia integration. It is not a standalone ShroudForge mod and requires the maintained Shroudtopia/WINMM loader pair.

## How it is built

- `mods/minimap_mod/minimap_mod.dll`: native renderer and integration layer.
- `mods/minimap_mod/src/mod.lua`: Lua-side configuration/runtime setup.
- `mod.json`: keeps the existing `minimap_mod` identifier and declares Shroudtopia settings.
- Map and icon assets: supplied terrain, fog-of-war, POI, player, marker, and weather resources.
- `realmap-provenance.json`: records map source, hashes, conversion, and alignment notes.

The native side supports GPU terrain rendering with a CPU fallback. The Lua/configuration side controls visibility, position, orientation, markers, clock/weather display, zoom, and size.

## Documented controls and defaults

- F10 toggles the minimap.
- The default position is bottom-right and orientation is north-up.
- F9 and F11 decrease/increase size in the included configuration.
- The configuration also includes zoom keys, map markers, waypoints, pings, death markers, fog of war, weather, and clock options.

## Loader compatibility and prior failure

The README explicitly requires the maintained Shroudtopia and WINMM loader pair, which are not bundled. That explains why the mod did not populate when treated as an ordinary ShroudForge/proxy plugin. The previous active installation was removed after it interfered with the working setup; the archive remains available for research and is not active.

## Evidence level

**Verified from archive:** fork provenance, package layout, native DLL, required loader family, settings, hotkeys, GPU/CPU fallback, and map provenance metadata.

**Not verified in this audit:** live rendering on the current game build, compatibility with the current ModLoader Proxy/ShroudForge chain, or whether the Shroudtopia/WINMM pair can be safely reintroduced.
