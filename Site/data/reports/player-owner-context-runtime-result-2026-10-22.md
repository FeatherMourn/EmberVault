# Player owner context runtime result

## Probe

The fresh-package read-only probe queried the documented player-context
components after a bounded retry window:

- `keen::ecs::PlayerInput`: zero entities.
- `keen::ecs::ClientPlayerInput`: zero entities.
- `keen::ecs::ClientPlayerState`: zero entities.
- `keen::ecs::LocalPlayerMask`: unavailable as a live component.

The probe made no entity dump, writes, save access, or native calls.

## Classification

The reflection and fork documentation establish that player-context schemas
and player-entity reference fields are represented statically. The current
ShroudForge runtime query surface did not expose a local player entity in this
private-world session, even after retrying while ECS initialization completed.
Therefore live player ownership remains **represented but not readable through
the current supported query path**. Inventory-instance, live appearance, loot
ownership, and player-targeted write capabilities remain unverified.

This result is stronger than the earlier premature scan because the fresh
package waited for pending ECS queries instead of treating scanning as a final
empty result.
