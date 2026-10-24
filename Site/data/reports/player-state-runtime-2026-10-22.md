# Player-State Runtime Probe

## Result

The EmberVault player-state probe exported successfully in a running client session. The fork returned a validated local-player handle after bounded retry. The probe remained read-only and did not enumerate entities, access saves, or invoke writes.

| Target | Result |
|---|---|
| Local-player handle | Available |
| AttributeComponent | Not readable on player handle |
| BuffContainer | Not readable on player handle |
| BuffComponent | Not readable on player handle |
| Level | Not readable on player handle |
| Durability | Not readable on player handle |
| SpecialAbility | Not readable on player handle |
| DamageModSkillShot | Not readable on player handle |
| ServerProgress / DynamicServerProgress | Not readable on player handle |

## Interpretation

The fork accessor is functioning, but these state components are not owned directly by the returned player entity, or the current runtime bridge does not expose their component reads through that handle. This matches the inventory and equipment result. The next useful probe should use bounded related-entity queries and relationship fields, not additional direct reads on the player handle.

## Retry result

The version 1.2 probe completed its full retry window and produced a fresh export. `keen::ecs::Level.dataStorage`, `keen::ecs::SpecialAbility.dataStorage`, and `keen::ecs::DamageModSkillShot.dataStorage` were readable on the player handle. Attribute, buff, durability, and progression reads remained unavailable. Related queries still reported ECS scanning at finalization, so no ownership conclusion is made for those domains.

## Subsequent packaging/runtime result

The serialized-query version 1.3 completed and exported successfully after the root-entry completion guard was added. In that launch, however, every accessor attempt returned `local-player accessor received invalid arguments`, so no player handle was obtained. This is a runtime-context or fork-bridge discrepancy, not evidence that the state components are absent. The prior version 1.2 player-handle result remains the authoritative successful read.

## Safety

No writes, save access, entity dump, memory hook, or multiplayer operation was used.
