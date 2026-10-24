# Unified EML Tweaks — `unifiedemltweaks`

## Short summary

Unified EML Tweaks is a large Lua/EML configuration-driven mod. Its extended manifest defines a Modloader UI with grouped controls for progression, player stats, combat, spells, inventory, loot, crafting, exploration, building, fog, weather, glider physics, terraforming, and difficulty settings.

## Evidence inspected

- `mod.json`
- `extended.mod.json`
- `src/mod.lua`
- ShroudForge runtime log entries for `unifiedemltweaks`

## Loader and manifest

- ID: `unifiedemltweaks`.
- Version: `1.4.0`.
- Declared capabilities: `patch`, `runtime`.
- Targets: client and server.
- Launcher configuration is exposed through the extended ShroudForge manifest.

## How it works

The extended manifest is the configuration schema and UI definition. Each setting has a value, label, control type, bounds, and description, and the `groups` section determines how settings are presented in the Modloader UI. The Lua file contains fallback defaults and the runtime logic that reads those settings, resolves compatible game-setting names, and applies patches or runtime changes.

This is a useful model for building a configurable mod: the manifest describes the user-facing contract, while Lua handles compatibility and application. Master toggles gate feature families so individual changes can be enabled without activating every subsystem.

## Feature families observed

- Level caps, item levels, skill points, and attribute scaling.
- Base health, mana, stamina, oxygen, and shroud-time values.
- Damage, tool, spell, regeneration, and gear-stat multipliers.
- Backpack, stack size, chest, magic storage, loot, and gem changes.
- Recipe unlocking, creative/free crafting, factory output, and food costs.
- Fast-travel markers, fog-of-war range, updraft, slope, and building rules.
- Weather/fog appearance and glider physics.
- Terrain breakability and terrain drop rates.
- Expanded difficulty slider arrays.

## Runtime evidence and limitations

ShroudForge logs show the mod initializes successfully and maps many user-facing settings to backend game-setting names. Some names do not map on the current build, such as older body-heat, durability, and enemy-attack-frequency keys. Those warnings are compatibility gaps rather than proof that the whole mod failed.

The current configuration also contains a value mismatch for `aggroPoolAmount`: one runtime warning reported a decimal value where the game expected a named choice such as Few, Normal, Many, or Extreme. This is an example of why the manifest schema and backend value types must stay synchronized.

## Reverse-engineering assessment

This mod is the clearest example so far of a ShroudForge-compatible Lua mod built around a declarative UI manifest plus a runtime patch layer. Its source is present, so the next analysis pass can trace individual feature functions and identify the exact runtime APIs used by each family.

## Confidence

- Manifest structure and setting inventory: high; directly inspected.
- Loader behavior and initialization: high; confirmed by ShroudForge logs.
- Exact hook/API mapping for every feature: medium; requires function-by-function source tracing.
- Compatibility of every setting on the current game build: medium to low; logs already show several backend-name/value mismatches.

