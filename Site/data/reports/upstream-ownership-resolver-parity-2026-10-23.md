# Upstream Ownership Resolver Parity — 2026-10-23

## Result

The current EmberVault resolver is not behaviorally upstream-parity. It queries
`keen::ecs::DefaultInventory` and `keen::ecs::Equipment`, then accepts only
entities whose own entity ID equals the validated local-player ID. The live
probe produces no owned handles under that rule.

Upstream evidence uses a relationship chain instead:

1. Resolve the validated local player through the client ECS owner.
2. Read the player's `keen::ecs::InventorySetup` component.
3. Follow its `linksEntities` array to related inventory entities.
4. Resolve item entities from inventory slot references (`Inventory.slots[n].data.pide`).
5. Use `ItemState.containedInSlotId` as the item-to-slot reverse relationship.

The upstream evidence does not establish that `Equipment` is directly owned by
the player ID, so equipment should be resolved through its reflected relationship
fields or a separately validated link, not by guessing entity identity.

## Evidence

- Upstream `1.7.6` has the same Enshrouded client profile and executable
  fingerprint as the EmberVault fork; no newer profile is needed for this issue.
- Upstream reflection data defines `keen::ecs::InventorySetup.linksEntities`
  at native offset `0x0`.
- Upstream runtime evidence documents inventory entities reached through
  `InventorySetup.linksEntities` and item resolution through inventory slot
  references.
- Upstream runtime evidence identifies `ItemState.containedInSlotId` as the
  reverse item-slot relationship.
- The private fork's current `KfcRuntimeWorldLocalInventoryEquipment` performs
  direct entity-ID equality against the local player and does not read
  `InventorySetup.linksEntities`.

## Consequence

The readiness split and ECS read gate are working. The remaining failure is in
relationship resolution, not the missing game-thread dispatcher hook, profile,
or ShroudForge package.

## Next safe implementation slice

Add a bounded, read-only resolver that:

- reads `InventorySetup.linksEntities` from the validated player-side entity;
- validates every linked entity against the same ECS owner, session, and
  generation checks;
- reports the linked entity count and relationship status without exposing
  unbounded entity dumps;
- resolves item slot references only after the link chain is validated;
- keeps equipment resolution separate until its relationship field is proven;
- returns explicit `unsupported`, `scanning`, `stale`, `ambiguous`, and
  `ready` states.

No writes, save edits, signature guesses, or live installation are justified by
this parity pass.
