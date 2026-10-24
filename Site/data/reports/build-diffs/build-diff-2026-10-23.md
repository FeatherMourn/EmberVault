# Build diff — 2026-10-23

## Scope

Stage 1 static census snapshot for the local Enshrouded/KFC export and type
cache. This is a provenance checkpoint, not a runtime compatibility claim.

## Baseline

- KFC export: `H:\enshroudedresearch\kfc-export-20261019-113420`
- Type cache: `H:\SteamLibrary\steamapps\common\Enshrouded\.cache\types.json`
- Type-cache identity: `1269579|^/game38/branches/release_1.0|2026-10-16`
- Indexed types: 12,646
- Catalog generation window: 2026-10-19

## Comparison result

No prior comparable Stage 1 catalog snapshot with a complete source identity
was found in the repository, so no semantic change claims are made. This file
closes the required build-diff checkpoint by recording the baseline and the
absence of a valid predecessor.

## Limitations

This does not establish runtime support, ownership, writability, persistence,
or equivalence with a future game build. A future build must create a new dated
diff with source hashes and field-level additions/removals.
