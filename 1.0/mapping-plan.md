# Layered Mapping Plan

## Goal

Build a build-aware catalog of what Enshrouded exposes through standard EML
and Lua under ShroudForge. Every adapter and probe produces provenance,
permissions, evidence level, and known limitations.

## Layer 1 — Baseline and provenance

- Record game, ShroudForge, EML, and KFC identities.
- Fingerprint the executable and record the active runtime.
- Normalize existing KFC/reflection data into catalogs.
- Preserve source, build, collection date, and confidence.

**Output:** snapshot metadata, type/resource catalogs, and provenance report.

## Layer 2 — Loader and lifecycle

- Test standard EML discovery and manifest parsing.
- Test initialization, enable, disable, and shutdown behavior.
- Add structured lifecycle and failure markers.

**Output:** lifecycle evidence and package compatibility records.

## Layer 3 — Read-only API inventory

- Enumerate asset types and resource records.
- Read representative fields and compare them with KFC schemas.
- Test configuration reads, dependency resolution, and supported Lua APIs.
- Test logging and bounded export behavior.

**Output:** typed resource catalog entries, API availability records, and CSV/JSON exports.

## Layer 4 — UI and workflow surfaces

- Register harmless UI actions.
- Test status messages, diagnostics, and action callbacks.
- Map user-facing configuration and error states.

**Output:** UI/action adapter contracts and reproducible workflow notes.

## Layer 5 — Offline content and snapshot mapping

- Generate manifests, Lua fixtures, schemas, and catalog entries.
- Import recorded snapshots and calculate bounds, counts, and dependencies.
- Generate blueprint metadata and preview data without live placement.

**Output:** content-generation fixtures, snapshot catalogs, and blueprint metadata.

## Layer 6 — Experimental runtime reads

- Test world-context availability in the tester world.
- Attempt bounded voxel, entity, prop, cursor, and resource reads.
- Record timing, result counts, build identity, and failure reasons.

**Output:** observed world-capability records; no capability is promoted from a failed or ambiguous result.

## Layer 7 — Multiplayer and performance

- Identify local authority, client, and server roles.
- Measure probe cost, memory use, timing, and failure recovery.
- Test stale-session and build-mismatch behavior.

**Output:** authority, performance, and compatibility evidence.

## Layer 8 — Experimental mutation, later

- Only after read paths are understood, test one narrow mutation in the tester world.
- Record original value, requested value, readback, rollback, and journal entry.
- Keep placement, save mutation, and multiplayer writes separately classified.

**Output:** guarded-operation evidence or a documented limitation.

## Promotion rules

- One probe tests one capability category.
- Standard EML and Lua remain the live baseline.
- Adapters never infer writability from catalog data.
- Every result updates the capability matrix and evidence history.
- Failed probes are cataloged as boundaries, not discarded.
- Raw exports, saves, binaries, and private logs remain outside the repository.
