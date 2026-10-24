# Stage 5 links bridge implementation

Date: 2026-10-23
Fork: `H:\enshroudedresearch\shroudforge\fork\shroudforge-player-accessor`

## Change

The native `InventorySetup` reader was corrected to use the relationship
direction documented by upstream evidence:

- identify the bounded `InventorySetup` candidate by matching its entity
  identity to the validated local-player entity;
- treat `linksEntities` as related inventory entities, not as a reverse list
  containing the player entity;
- require at least one non-zero link in the bounded sixteen-entry array;
- retain double-read byte consistency, generation/sequence checks, and explicit
  stale/unresolved/ambiguous outcomes;
- keep the unsafe direct inventory/equipment operation disabled.

## Validation

- Native CMake Release build: passed.
- Existing warning: disabled unsafe ownership function has unused parameters by
  design.
- No live binaries installed.
- No saves or worlds touched.

## Current boundary

This proves the corrected bridge compiles; it does not yet prove that the
current live build exposes a unique player-side `InventorySetup` relationship.
The next Stage 5 gate is a ShroudForge-only read-only package test using the
rebuilt native runtime, with fresh export identity and no ownership writes.
