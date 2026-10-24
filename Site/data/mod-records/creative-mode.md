# Creative Mode 3.0.0

## Short summary

Creative Mode is a native ShroudForge/Flame plugin with a large version-specific symbol and signature database. It adds creative building and gameplay utilities by locating internal game functions and data structures at runtime. The archive is more invasive and version-sensitive than a normal Lua or EML mod.

## How it is built

- Root `dinput8.dll`: bundled standalone loader entry point.
- `mods/creative/creative.dll`: native plugin.
- `mod.json`: declares the Flame plugin as Creative Mode version 3.0.0.
- `items.json`: defines custom or restored creative items and placement metadata.
- `sigs/`: version-specific signature and offset databases.
- `symbols/`: JSON descriptions of internal game systems, including input, player mode, crafting, inventory, map, movement, and server functions.

The symbol files show that the plugin uses pattern scanning and documented offsets rather than relying only on fixed addresses. It still depends on the target game build matching the supplied signatures.

## Observed capabilities

The archive contains symbols for creative-related systems including item and recipe access, player mode changes, menu detection, movement/input data, crafting requests, server player permissions, map functions, and UI messages. `items.json` contains custom item definitions such as production-place entries and placement metadata.

## Loader compatibility

This archive includes its own root `dinput8.dll`, so it is a loader package, not just a DLL that can safely be dropped into the current proxy chain. The working ShroudForge setup uses the extracted Creative plugin and its native DLL under the existing proxy arrangement rather than replacing the root loader. The bundled Flame manifest should not be assumed to load correctly through ShroudForge without the compatibility arrangement already documented in the installation notes.

## Risks and limitations

- Native signature scanning can fail after a game update.
- The archive contains client and server-oriented symbols, so multiplayer behavior requires separate validation.
- Creative features may write gameplay, inventory, or world state; this is not a read-only diagnostic mod.
- The root loader must not be swapped while the current ShroudForge chain is working.

## Evidence level

**Verified from archive:** package layout, version, native DLL, Flame manifest, item definitions, signature files, and symbol coverage.

**Not verified in this audit:** every menu or feature in the current game build, multiplayer behavior, and whether the bundled standalone loader can coexist directly with the current ModLoader Proxy chain.
