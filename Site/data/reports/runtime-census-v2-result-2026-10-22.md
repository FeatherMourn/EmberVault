# Runtime Census v2 Result — 2026-10-22

## Provenance

- Probe: `embervault_census_workers_sf_v2`
- Probe version: `2.0.0`
- Runtime mode: private-world, read-only
- Export: `census-workers-v2.tsv`
- Player handle: available (`entityId=1`, generation `0`, sequence `1`)
- Snapshot generation: `1:0:180`
- Writes: not attempted
- Saves: not accessed

## Worker result

All six workers completed in one session: player context, player state, inventory links, inventory scan, item state,
and equipment. The shared snapshot recorded one cached query, confirming the scheduler path was active.

Inventory links and inventory containers were readable, with 32 bounded records each. The selected slot paths produced
zero item-ID candidates in this session, so the item-state worker had no entities to resolve. This is a clean absence
of observed linkage, not proof that item instances do not exist.

The player-state worker tested level, special ability, damage modifier, attributes, buffs, durability, and progression.
All seven direct component reads were unavailable on the player handle in this run. Earlier probes observed some of
these fields under different runtime timing and paths; the current result therefore remains versioned evidence rather
than a promotion or removal of those earlier claims.

Equipment completed with zero readable records. No writes, save edits, unrestricted entity enumeration, or memory
access were used.

## Next bounded investigation

Inspect the returned inventory slot field types and alternate item-reference paths, then retry item-state resolution
only for IDs that are actually observed. Do not infer ownership or expose editor write controls from this result.
