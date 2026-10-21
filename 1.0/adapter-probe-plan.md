# Adapter and Probe Plan

This plan defines how EmberVault will map Enshrouded through standard EML and
Lua under ShroudForge. Probes are read-only by default; adapters translate
verified data into stable, build-aware contracts.

## Adapter types

| Adapter | Purpose | Initial scope |
|---|---|---|
| Manifest adapter | Normalize package identity, capabilities, and dependencies | Standard EML and ShroudForge manifests |
| Resource adapter | Convert runtime resource records into typed EML records | ItemInfo, recipes, materials, tuning |
| Schema adapter | Preserve field types, names, relationships, and provenance | KFC/reflection-derived schemas |
| Export adapter | Convert read results into CSV, JSON, or catalog entries | Bounded, read-only exports |
| Evidence adapter | Bind logs and outputs to build, probe, and package identity | Structured markers and freshness |
| Configuration adapter | Read supported mod configuration without mutation | Defaults, current values, validation state |
| UI/action adapter | Map safe actions and status reporting to ShroudForge UI | Diagnostics and probe triggers |
| Snapshot adapter | Convert recorded world data into previewable metadata | Offline snapshots only initially |
| Compatibility adapter | Compare package/runtime/build requirements | Standard EML baseline and staged bridge |
| Dependency adapter | Resolve required and optional package relationships | Fail-closed validation |

## Probe types

| Probe | What it investigates | Safety level |
|---|---|---|
| Loader probe | Discovery, manifest parsing, enable/disable behavior | Read-only |
| Lifecycle probe | Initialization, startup, shutdown, and failure order | Read-only |
| Logging probe | Structured markers, timestamps, build identity, evidence import | Read-only |
| Asset-type probe | Which resource types can be enumerated | Read-only |
| Asset-field probe | Which fields can be read and their runtime types | Read-only |
| Export probe | Whether bounded results can be written to an export file | Read-only game access |
| Configuration probe | Supported configuration surfaces and validation rules | Read-only |
| UI/action probe | Action registration, status display, and callbacks | Read-only |
| Dependency probe | Required/optional dependency resolution and rejection | Read-only |
| Snapshot probe | Preview, bounds, counts, and provenance for recorded data | Offline/read-only |
| World-context probe | Whether a valid current-build world context exists | Read-only |
| World-read probe | Bounded voxel, entity, prop, or cursor queries | Read-only; current-build evidence required |
| Multiplayer probe | Authority, session role, and replication visibility | Read-only; separate test world |
| Mutation probe | Whether a guarded write path exists | Deferred; explicit approval required |

## Investigation order

1. Loader and lifecycle.
2. Logging and evidence import.
3. Asset types and fields.
4. Export and configuration.
5. UI/actions and dependencies.
6. Offline snapshot and blueprint metadata.
7. Current-build world context and bounded reads.
8. Multiplayer observation.
9. Guarded mutation only after backup, permission, readback, and rollback gates.

## Promotion rules

- A probe result must identify the game build, loader version, package version,
  and evidence level.
- A catalog or reflection entry is not proof of live access or writability.
- Every adapter must declare permissions, dependencies, failure behavior, and
  unsupported operations.
- Failed and skipped probes are recorded as useful boundary evidence.
- No mutation probe is promoted from design to execution without explicit
  approval and a recoverable test environment.
