# SF Survival — `sf-survival`

## Short summary

SF Survival is a ShroudForge runtime mod built around the public typed ECS, template, and engine-service APIs. It changes survival values such as stamina, mana, oxygen, body heat, regeneration, fall damage, and weapon durability while preserving restoration behavior when settings are disabled.

## How it works

The extended manifest defines eight settings and places them in one Survival group. The Lua entry point creates a shared override manager, waits for an authoritative world, queries player entities, reads original values, and applies typed changes through runtime helper APIs. It runs every 100 milliseconds so it can bind to players, notice changed maxima, retry busy engine gates, and restore settings that were turned off.

The mod does not use hard-coded process addresses or native DLL bindings. Its design relies on ShroudForge admitting typed read/write operations and on the runtime tracking ownership of each changed value.

## Implemented mappings

- Infinite stamina: sets `Stamina_Min` equal to the original `Stamina_Max`.
- Infinite mana: sets `Mana_Min` equal to `Mana_Max`.
- Infinite underwater breath: sets `Oxygen_Min` equal to `Oxygen_Max`.
- Infinite frost timer: sets `BodyHeat_Min` equal to `BodyHeat_Max`.
- Fast health and mana regeneration: multiplies existing recharge by 100, capped at 65536; it does not create regeneration if the original rate is zero.
- No fall damage: raises the player template's fall-damage start distance to at least the lethal distance.
- Infinite weapon durability: changes the hosted world's `ecs::GameSettings.enableDurability` service field.

## Safety and restoration design

The mod records the value it owned before changing it and compares the current value before restoration. An external change is preserved rather than overwritten. If the engine is busy, the mod retries. If the result is uncertain or the world session is invalidated, it stops mutating and reports that a restart may be required.

The storage scopes matter: attributes are per authoritative player entity, fall damage is shared by entities using a template, and durability affects the locally hosted world and carried items.

## Runtime evidence

ShroudForge logs showed SF Survival loading and transitioning between waiting and resolved states as world/runtime access became available. The logs also showed that no live player entity was available during some phases, which is an expected state while at menus or before a world is ready.

## Reverse-engineering assessment

This is a strong reference implementation for safe ShroudForge Lua mods. Its main patterns are: typed target factories, explicit ownership, reversible writes, authoritative-world checks, bounded update loops, and status reporting. Those patterns are directly reusable for future mods such as autorun or a spellbook, provided the required runtime targets exist.

## Confidence

- Manifest and source behavior: high; directly inspected.
- Runtime API strategy: high; directly shown in source and README.
- Actual gameplay result for every setting: medium; requires an offline world test on the matching build.

