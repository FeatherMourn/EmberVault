# Static Reflection Domain Census

## Scope

This is a keyword-based inventory of the current 1.0 reflection catalog. It identifies candidate schemas for later read-only probes; it does not establish runtime ownership, readability, writability, or persistence.

## Candidate coverage

| Domain | Matching reflected types | Example anchors |
|---|---:|---|
| Player context | 216 | `PlayerFocus`, `ClientPlayerFocus`, `LocalPlayerMask`, player spawn and camera types |
| Attributes | 108 | `AttributeComponent`, float, signed, unsigned, and boolean attribute types |
| Buffs | 100 | `BuffInstance`, buff events, buff definitions and slot types |
| Abilities | 48 | actor ability flags, masks, events, and enemy ability definitions |
| Skills | 136 | skill nodes, modifiers, unlock actions, and skill-tree resources |
| Building | 88 | building range, building actions, loot memory, and player building types |
| Voxel | 249 | voxel model, material, fog, mapping, and resource component types |
| Localization tags | 53 | `LocaTag`, tag references, IDs, and collections |
| Language | 19 | language IDs, masks, UI language, and localization resource language types |
| Equipment | 58 | equipment slots, slot data, packed entity IDs, equipment, and render equipment |
| Inventory | 119 | inventory setup, slot IDs, actions, default inventory, item state, and collections |

## High-value player-state anchors

The reflection catalog gives the next probe exact candidates rather than keyword-only guesses:

- `keen::ecs::AttributeComponent` with root, storage offset, flags, and storage count, plus typed float, unsigned, signed, and boolean attribute forms.
- `keen::ecs::BuffContainer` with food buffs, generic buffs and debuffs, rested state, terrain debuff, hunger timing, and extended food slots.
- `keen::ecs::BuffComponent` and `BuffNetworkData` with buff type, lifetime, level, and damage setup fields.
- `keen::ecs::Level`, `Durability`, `SpecialAbility`, and `DamageModSkillShot`, each exposing a data-storage relationship.
- `keen::ecs::ServerProgressSystem` with progression entity, flame level, altar counts, and player-level aggregates.

These are schema candidates only. The local-player handle is verified, but direct readability and ownership for these components still require bounded runtime probes.

## Evidence boundary

- The counts and names are static reflection evidence for the current catalog.
- The EmberVault fork has a verified read-only local-player handle.
- Inventory and equipment entities are discoverable, but their ownership link to the player remains unresolved.
- A narrow appearance preset read and no-op guarded write are verified; that does not prove live player appearance ownership.
- No broad write, save edit, entity dump, memory hook, or multiplayer operation is part of this census.

## Probe order

1. Resolve inventory relationship arrays and item-stack references.
2. Map player attributes, buffs, abilities, and progression through the validated player handle.
3. Map building ownership and voxel context with bounded reads.
4. Map localization tags to bundle text where the bundle decoder or runtime resolver supports it.
5. Promote only reproducible readback results into adapters or guarded private-world tests.
