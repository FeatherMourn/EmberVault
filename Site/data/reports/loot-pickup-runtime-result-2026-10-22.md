# Loot and pickup runtime result

## Session result

The read-only `embervault_loot_pickup_census_sf` probe exported successfully after the private world loaded.

Confirmed during this session:

- `runtime.ecs`, registry access, query access, and field-read access were callable.
- The probe did not enumerate entities, read item IDs, access saves, call native code, or attempt writes.
- Queries for `PlayerFocus`, `ClientPlayerFocus`, `PlayerInRange`, `CheckPlayerInRange`, `IsLocalPlayerInRange`, `ItemState`, and `Equipment` returned no result.
- The supported probe surface still did not provide an authoritative local-player or inventory-owner handle.

## Classification

| Capability | Result |
|---|---|
| Loot/pickup schema represented | Verified statically |
| Runtime API surface callable | Verified |
| Player/loot component result readable | Not observed in this session |
| Probe export | Verified |
| Item or loot writes | Not attempted |
| Persistence | Not tested |

## Integration confounder

The ShroudForge log shows `UnifiedEMLTweaks` scanning and changing loot-related resources during the same launch, including ItemInfo random-loot stack ranges, LootableItemsResource entries, and terrain loot exchange rates. Therefore this session is valid evidence that the census probe exported, but it is not a clean baseline for authored loot values or resource writability. No claim is made that those changes came from the census probe.

## Conclusion

The missing capability remains live ownership/context, not static loot schema. A clean follow-up would require a separate launch profile with resource-mutating loot tweaks disabled, if the user chooses to test that configuration. Any such relaunch requires explicit confirmation.

## Reload confirmation

After a normal reload with the same configuration, the probe exported again and produced the same nil result for all seven targeted component surfaces. This makes the missing live player/item context reproducible under the current setup. The same session also logged Unified EML Tweaks startup-setting errors, including an invalid preset conversion and a failed pregame asset-apply phase. Those errors reinforce that the current session is not a clean baseline for broader runtime capability claims.
