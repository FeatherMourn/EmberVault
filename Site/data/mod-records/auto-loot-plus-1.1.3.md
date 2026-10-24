# AutoLootPlus 1.1.3

## Short summary

AutoLootPlus is a native-loader mod with Lua/configuration content that automates pickup and optional ruin/container smashing. The 1.1.3 archive includes its README, configuration, item lists, manifest, and source files. It is not currently active in the ShroudForge setup.

## How it is built

- Root `dinput8.dll`: standalone loader entry point.
- `mods/auto-loot-plus/`: EML mod package with `mod.json`, Lua source, configuration, item lists, and templates.
- `dbghelp.dll`: required by EML according to the bundled README.
- The Lua/configuration layer defines pickup categories, ignored items, stack behavior, and menu settings; the native loader supplies the entry point and runtime integration.

## Behavior documented by the archive

- F8 opens the configuration menu.
- F9 toggles Auto Loot.
- Supports ground loot, resources, collectibles, plants/crops, corpses, chests, and containers.
- Optional auto-smashing of ruins.
- Supports larger stack behavior and configurable item lists.
- The bundled README states that the full version is intended for single-player and is not multiplayer-supported.

## Version comparison

Compared with the older 1.1.1 copy previously used, 1.1.3 documents fixes for over-collection, base-protection distance handling, world-load timing for smashing settings, ignore-item behavior, and false inventory-full indications.

## Loader compatibility

The archive expects to own the root `dinput8.dll`, so it cannot simply be placed beneath the current ShroudForge proxy without a verified compatible chain configuration. Its README describes renaming another dinput8 loader to a secondary DLL and listing it in a chain configuration; that approach must be validated against the currently working ModLoader Proxy/ShroudForge chain before any change.

## Safety and uninstall notes

The README warns that stacks above the normal limit can be truncated when the mod is removed. Before uninstalling, oversized stacks should be split into normal-sized stacks and the game should be saved after the mod is disabled. No files were installed or changed during this audit.

## Evidence level

**Verified from archive:** package layout, version, controls, stated dependencies, feature list, version-history claims, multiplayer warning, and uninstall warning.

**Not yet verified:** whether this build can load safely through the current ShroudForge-compatible proxy chain, whether its menu appears in the present game build, and whether all listed features work with the current Enshrouded version.
