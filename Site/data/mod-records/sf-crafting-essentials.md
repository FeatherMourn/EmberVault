# SF Crafting Essentials — `sf-crafting-essentials`

## Short summary

SF Crafting Essentials combines pregame recipe preparation with live runtime changes. It can remove recipe ingredients and water charges before startup, keep supported used items from being consumed, and alter production times while preserving relative recipe durations.

## How it works

The mod has two phases. During the `pregame` phase it scans `keen::RecipeRegistryResource`, edits recipe input counts and water charges when the no-cost option is enabled, and optionally prepares one shared duration for timed recipes. During the `ingame` phase it uses typed resource writes and an override manager to adjust loaded recipe durations and supported action-sequence consume flags.

The source processes resources incrementally with budgets rather than scanning everything in one update. It caches resource identities, reacquires resources by GUID/type/part, validates each target path, and reports pending scans or unavailable write scopes through ShroudForge status reporting.

## Settings

- No Recipe Resource Costs: removes direct ingredients, category inputs, and water charges before startup; it does not change building or upgrade costs.
- No Item Consumption: changes supported item-use actions to retain the item; unsupported actions remain unchanged.
- Recipe Time Mode: keeps original live scaling or uses a fixed shared duration prepared at startup.
- Production Time in Seconds: fixed base duration for timed recipes.
- Production Duration Scale: live percentage scaling of loaded recipe durations, including running production.

## Safety and limitations

Pregame asset edits require the pregame patch capability and a restart. Live changes require an authoritative world and guarded resource-write access. The mod validates positive finite durations, limits setting ranges, and restores values when settings are disabled or the mod unloads.

## Reverse-engineering assessment

This is a strong example of a split-phase mod: immutable or startup-sensitive data is changed before the game consumes it, while live-safe values are handled through guarded runtime resource writes. Its incremental scanning and ownership tracking are reusable patterns for future mods that need to inspect many game resources.

## Confidence

- Manifest, settings, and source flow: high; directly inspected.
- Exact game-side effect of every recipe/action path: medium; depends on the current build's resource layout and runtime write availability.

