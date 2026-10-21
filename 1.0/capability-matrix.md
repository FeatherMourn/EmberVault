# Capability Matrix

Snapshot: `1.0`  
Scope: EML, ShroudForge, EmberVault tooling, and content-generation workflows  
Status: living record

## Guiding scope

The project maps Enshrouded through standard EML and Lua running under
ShroudForge. Adapters, read-only probes, offline catalogs, structured logs,
exports, and build-matched evidence are the primary methods. Every capability
claim is recorded here with its evidence level and limitations before its
status changes. The EML 2.0 bridge and mutation paths remain outside the live
supported scope until independently verified.

## Evidence levels

| Level | Meaning |
|---|---|
| Static | Source, schema, documentation, or offline catalog evidence |
| Synthetic | Staged fixture or local simulation |
| Observed | Behavior seen in a running game session |
| Verified | Reproducible current-build result with matching provenance |
| Guarded | Controlled operation with permission, backup, readback, and rollback |

## Current matrix

| Area | Capability | Status | Evidence | Limits and next test |
|---|---|---|---|---|
| Loading | Standard EML package discovery | Confirmed | Observed | Recheck after loader/game updates |
| Lua | Standard EML Lua execution | Confirmed | Observed | Only exercised APIs are claimed |
| Assets | Read resource records by type | Confirmed | Verified | Current probe covered item resources |
| Export | Export generated data to CSV | Confirmed | Verified | `eml-item-list.csv` was produced live |
| Logging | ShroudForge log output | Confirmed | Observed | Marker format may vary by runtime |
| Lifecycle | Package startup and enable status | Confirmed | Observed | Full EML 2.0 lifecycle remains separate |
| EML 2.0 | Bridge metadata in a package | Staged only | Synthetic | Removed from live testing; older schemas reject extra compatibility fields |
| EML 2.0 | Full runner inside ShroudForge | Unverified | None | Requires real loader/runtime integration |
| Catalogs | KFC/resource normalization | Confirmed offline | Static/Synthetic | Catalog identity must match the build |
| Schemas | Typed fields, dependencies, provenance | Confirmed offline | Static/Synthetic | Not proof of live writability |
| UI | Native actions and mod status | Confirmed | Observed | Custom fields must use accepted schema |
| Blueprint metadata | Offline preview and generation | Confirmed offline | Synthetic | Live-world capture is not established |
| Blueprint export | Export an existing verified snapshot | Conditional | Synthetic | Requires a valid snapshot source |
| World reads | Live voxel/entity/prop reads | Unverified | Failed/blocked provider attempts | Needs current-build provider evidence |
| Placement | Live blueprint placement | Unsupported for now | None | Keep disabled until safety gates pass |
| Writes | Game or save mutation | Unsupported for now | None | No write path is promoted |
| Multiplayer | Authority-aware edits | Unsupported for now | None | Requires authority and rollback evidence |
| Content generation | Manifests, Lua modules, catalogs, exports | Supported | Static/Observed/Verified by area | Generated packages need loader validation |
| Content generation | New native game assets | Unverified | None | Needs an exposed asset pipeline |
| Guarded operations | Backup/readback/rollback workflow | Designed | Static/Synthetic | No live write capability is enabled |

## Current live-scope decision

The EML 2.0 bridge package is not part of the live mod set. Standard EML
packages remain the supported compatibility baseline. The bridge source,
metadata, and staged probe remain available for future loader integration, but
they are not treated as live support until a real runtime bridge passes a
current-build test.

## Rules

1. A catalog record is not proof that a value is writable.
2. Package discovery is not proof that the package executed.
3. Older-build evidence cannot establish current-build support.
4. Unsupported and unverified capabilities remain visible.
5. Every promotion adds a history entry naming the probe, build context,
   result, and remaining limitations.
