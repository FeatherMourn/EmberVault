# Hoarder's Helper — `HoardersHelper`

## Short summary

Hoarder's Helper is intended to append recipe-use information to item tooltips. It identifies recipes using an item directly or through a material category, then displays a localized list in the item's description.

## Evidence inspected

- `mod.json`
- `Readme.md`
- No `src/mod.lua` was present in the installed folder, although the manifest declares it as the entry point.

## Loader and manifest

- Declared entry point: `src/mod.lua`.
- Declared capability: `patch`.
- The README describes it as an Enshrouded Mod Loader Lua/asset mod with no external dependency.

## Reported implementation behavior

The documented design likely reads recipe and localization data, builds an item-to-recipe index, and patches the tooltip description before it is shown. It supports both exact item ingredients and broad material categories. The README says it uses the active game language.

The mod reportedly creates cached `.dat` files after launch. The author describes those files as disposable generated localization/data caches that are recreated when needed.

## How it works

At a high level, the intended flow is to load recipe and localization resources, build an index from item or category to recipes, intercept or extend item tooltip text, and append the localized recipe list when the tooltip is rendered. The installed folder does not include the declared Lua entry point, so the exact hook and resource APIs cannot yet be verified.

## Reverse-engineering assessment

The installed package is incomplete for source-level analysis: the declared Lua entry point is missing. The manifest itself is also less descriptive than the current ShroudForge schema, so ShroudForge may reject it even if another loader can recognize it. The behavior and likely data flow can be documented from the README, but the actual tooltip hook, recipe traversal, and localization implementation require the original archive with `src/mod.lua`.

## Confidence

- Intended purpose: high; directly documented.
- Loader entry point and capability: high; directly read from the manifest.
- Exact implementation and runtime compatibility: low; source entry point is absent.

