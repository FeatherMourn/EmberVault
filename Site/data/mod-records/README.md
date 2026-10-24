# Enshrouded Mod Reverse-Engineering Notes

This folder records read-only analysis of the mods installed in the Enshrouded 1.0 test installation.

## Method

- Inspect manifests, documentation, configuration, and Lua source where present.
- Record loader requirements and declared capabilities.
- For native DLLs, record file metadata, imports/exports, embedded strings, and loader-log evidence.
- Separate facts directly observed from reasonable inferences.
- Do not modify installed mods as part of the analysis.

## Initial inventory

The active `mods` directory contains Lua/EML mods, ShroudForge runtime probes, Creative support files, and native-plugin folders. The current proxy load list separately loads Creative, XHL Area Harvest, XHL Enemy Difficulty Limits, and the M182 Panel. AutoLootPlus and the minimap were removed from the active setup before this audit. Stat Sliders was not compatible with the current proxy arrangement and is preserved outside the game installation.

## Reports

- [More Character Colors](more-character-colors.md)
- [Hoarder's Helper](hoarders-helper.md)
- [Unified EML Tweaks](unified-tweaks.md)
- [SF Survival](sf-survival.md)
- [SF Unlimited Flight](sf-unlimited-flight.md)
- [SF Crafting Essentials](sf-crafting-essentials.md)
- [SF Unlock Blueprints](sf-unlock-blueprints.md)
- [XHL Area Harvest](xhl-area-harvest.md)
- [XHL Enemy Difficulty Limits](xhl-enemy-difficulty-limits.md)
- [World Editor](world-editor.md)
- [EmberVault and Localization Probes](embervault-probes.md)
- [Research Mods Archive Inventory](archive-inventory.md)
- [Compatibility Patcher for Windows](compatibility-patcher.md)
- [ShroudHud](shroudhud.md)
- [Enshrouded Multi DLL Installer](multi-dll-installer.md)
- [Unified Tweaks 1.4.1 comparison](unified-tweaks-1.4.1-comparison.md)
- [AutoLootPlus 1.1.3](auto-loot-plus-1.1.3.md)
- [Creative Mode 3.0.0](creative-mode.md)
- [M182 Client 2.0](m182-client-2.0.md)
- [Minimap and Weather Clock 0.5.12](minimap-weather-clock-0.5.12.md)
- [Shroudweave Shroudtopia 0.2.1](shroudtopia-0.2.1.md)
- [Stat Sliders 0.1.2](stat-sliders-0.1.2.md)
- [More Character Colors 1.1.0](more-character-colors-1.1.0.md)
- [ModLoader Proxy 1.1.0](modloader-proxy-1.1.0.md)
- [Unified Proxy and Multi-DLL Loader Blueprint](unified-loader-builder-blueprint.md)
- [ShroudForge Compatibility Adapter Plan](compatibility-adapter-plan.md)

Current user verification: M182 Panel and ShroudHud are not working in the active ShroudForge setup and require compatibility investigation.

