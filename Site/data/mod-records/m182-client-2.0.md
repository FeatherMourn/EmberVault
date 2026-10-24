# M182 Client 2.0

## Short summary

M182 Client is an EML/native administrator panel for creature spawning, item/stat editing, zones, bases, teams, PvP, and player utilities. It combines `M182_Panel.dll`, EML configuration, two Lua patch mods, and a separate `dbghelp.dll` dependency.

## How it is built

- `M182_Panel.dll`: native panel and client/server communication layer.
- `dbghelp.dll`: EML/native support dependency.
- `eml.json`: EML runtime options.
- `m182_native.json`: native feature and hotkey configuration.
- `m182_panel.json`: panel limits.
- `mods/m182_spawn_variants`: Lua patch/export package for stronger creature variants and enemy-list export.
- `mods/zz_m182_item_stats`: Lua patch package applying item and balance values selected in the panel.

The panel writes or updates the Lua data used by the item-stat mod, and it can communicate with a server through hidden chat commands described in the README.

## Documented features

- Insert opens the panel.
- F8 opens the creature spawner; F7/F6/F5 are diagnostic or watch functions.
- Creature spawns can respawn near players and remain idle when nobody is nearby.
- Items can be granted with level, rarity, amount, and custom stats.
- Includes admin powers, PvP controls, zones, protected bases, teams, and server settings.
- Local play applies changes directly; dedicated-server use requires the separate server package.
- Borderless window mode is required for the overlay panel to appear reliably.

## Loader compatibility

The package README expects its files to be copied into the game root, which means it is not a simple Lua-only mod. Its native DLL and `dbghelp.dll` must be considered part of the loader chain. The current setup already loads `M182_Panel.dll` through the proxy chain, but the archive's standalone installation instructions should not be applied over the working ShroudForge files without a backup and compatibility check.

## Risks and limitations

- It can change persistent item, player, world, and server state; it is not a read-only tool.
- Server chat transport can expose administrative actions to server logs or other players if the server-side package is not configured correctly.
- Spawn counts and server requests can create load, especially with many active spawns.
- The archive includes `m182_spawn_variants`, but that folder was previously removed from the active setup and preserved separately.

## Evidence level

**Verified from archive:** package contents, manifests, configuration keys, hotkeys, feature descriptions, local/server distinction, overlay requirement, and uninstall list.

**Not verified in this audit:** current server-package compatibility, every panel feature on the present game build, and whether the standalone archive loader can coexist directly with the current proxy chain.

## Current compatibility status

The user reports that M182 does not currently work in the active ShroudForge setup. It is therefore a failed integration at present, not a confirmed working proxy plugin. The next investigation should inspect the M182 log and proxy load result separately to distinguish DLL loading, EML dependency, overlay-window, and panel-configuration failures.
