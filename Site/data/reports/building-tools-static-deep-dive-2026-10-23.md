# Enshrouded Building Tools static deep dive

Date: 2026-10-23
Source: `https://github.com/AleksanderWojtal-CC/Enshrouded-BuildingTools`
Evidence: public source and documentation review only; the DLL was not run.

## What the mod is

Building Tools is a native client-side `dinput8.dll` proxy for single-player
Enshrouded. It forwards `DirectInput8Create`, starts an initialization thread,
locates game code by byte signatures, and installs inline hooks with relays and
trampolines. It is not a ShroudForge package and does not use the EmberVault
Lua/provider API.

## Reusable technical findings

The author documents a useful building pipeline:

1. `PlaceShape` / `RemoveShape` perform dry-run pricing and collect material
   costs.
2. Payment/refund uses the game's inventory transaction path.
3. `PlaceCommit` / `RemoveCommit` perform the actual voxel commit.
4. Undo records and cost lists are maintained by the game's own building code.
5. Client prediction worlds and the single-player server world must be treated
   separately; the repository records several differences between them.

The notes identify reflected/system names, cursor and fixed-point transform
layouts, building event types, material-to-item lookup, no-build-zone checks,
undo storage, and signature patterns for the targeted 1.0 executable.

## What this gives EmberVault

- Strong static corroboration for Stage 1 building/voxel schemas.
- A concrete model for separating dry-run, payment, commit, and undo phases.
- A safety warning that client prediction and server-world contexts differ.
- A reproducible signature-validation workflow: scan the executable, require
  exactly one match, verify stolen bytes, and disable the mod on mismatch.
- Candidate building-domain terminology for future read-only adapters.

## What it does not prove

- It does not provide a supported player-ownership accessor.
- It does not expose inventory/equipment ownership to Lua.
- It does not establish current-build compatibility; its README targets an
  Enshrouded 1.0 client dated 2026-10-20.
- It is not safe to transplant its RVAs or hooks into EmberVault without a new
  executable fingerprint and signature validation.
- It is write-capable: replace, remove, payment/refund, undo, and voxel commit
  paths modify game state. It must not be enabled in the read-only census.
- Its single-player-only behavior does not establish dedicated-server support.

## Compatibility decision

Use this repository as static building/voxel corroboration and research
reference only. Do not merge its native proxy or hooks into EmberVault. If a
future building worker is developed, begin with a ShroudForge-only read-only
adapter that validates target build, world context, authority, bounds, and
readback before any guarded write is considered.

## Sources reviewed

- Repository README and install/build/compatibility notes.
- `docs/HOW-IT-WORKS.md`.
- `docs/reverse-engineering-notes.md`.
- `docs/BUILDING.md`.
- `src/main.cpp` and the documented signature/test workflow.
