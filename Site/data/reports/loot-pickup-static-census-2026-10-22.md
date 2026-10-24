# Loot and pickup static census

## Scope

Read-only reconciliation of the Enshrouded 1.0 reflection metadata and existing Researcher evidence. No game files, saves, or runtime state were modified.

## Confirmed represented types and fields

| Area | Evidence | Current classification |
|---|---|---|
| Loot-all interaction | `keen.actor.LootInteractionActionEvent.lootAll` | Represented; runtime/readability not yet proven |
| Loot transformation | `keen.actor.TransformToLootEvent.defaultInventory`, `keepDefaultInventory`, `lootHealth` | Represented; runtime/readability not yet proven |
| Loot sequence state | `keen.actor.SequenceFlags.IsLootingSequence`, `IsLootAllSequence`, `IsTransformedToLootWithHealth` | Represented; runtime/readability not yet proven |
| Item instance identity | `keen.ItemInstanceInfo.slotId`, `itemId`, `pide`, `stateMask` | Represented; player ownership unresolved at runtime |
| Inventory slot identity | `keen.InventorySlotId.entityId`, `slotIndex` | Represented; live owner unresolved |
| Item state | `keen.ecs.ItemState.containedInSlotId`, `itemId`, `baseDamageUi`, `itemState`, `itemRarityUi`, `itemLevelUi` | Represented; direct live read unresolved |
| Equipment | `keen.ecs.EquipmentSlotData` with armor, rings, weapons, shield, spell, bait, hookshot, glider, and backpack slots | Represented; live owner unresolved |
| Pickup event | `keen.ecs.PickedUpItemEvent` fields include item count, source and picker entity IDs, and target slot | Represented; event delivery not tested |
| Player proximity/context | `keen.ecs.PlayerFocus`, `ClientPlayerFocus`, `PlayerInRange`, `CheckPlayerInRange`, `IsLocalPlayerInRange` | Represented; no supported local-player accessor found |

## Capability classification

- **Represented:** confirmed by current 1.0 reflection metadata.
- **Readable:** partially proven for general resources and some live settings; loot and inventory instances are not yet proven readable.
- **Exportable:** not proven for this domain; the existing runtime export path has been intermittent and depends on initialization timing.
- **Writable:** not tested for loot or item instances. No write attempt is authorized by this census step.
- **Persistent:** not proven. Save-copy research identifies KSC1 containers, but no loot or item-instance round trip has been decoded.

## Main finding

The schema needed for a pickup and item editor exists. The blocking bridge is not the item schema; it is obtaining the authoritative local-player or inventory-owner entity through a supported runtime accessor. Existing probes found ECS registry access but no local-player handle and no safe entity enumeration path.

## Next bounded runtime probe

Prepare a read-only probe that checks only confirmed context surfaces and reports availability/errors:

1. `PlayerFocus`, `ClientPlayerFocus`, and player-range components.
2. `ItemState` and `EquipmentSlotData` component availability, without enumerating entities.
3. Supported local-player, authority-context, or player-event accessors, if present.
4. A bounded status export with no entity IDs, item edits, save access, native calls, or writes.

The probe must stop at preparation and wait for explicit user confirmation before any game launch or in-world test.

## Provenance

- Primary schema source: Enshrouded 1.0 `.cache` Lua reflection metadata.
- Cross-check: existing EmberVault Researcher probes and reports.
- Confidence: represented schema is high; runtime ownership and editability remain unverified.
