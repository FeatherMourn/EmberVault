# EML API Inventory

This inventory is the test plan behind the capability matrix. Each row must be
backed by a small probe result before its status is promoted.

| API area | Representative surface | Current status | Evidence target | Next probe |
|---|---|---|---|---|
| Package loading | `mod.json`, package discovery | Confirmed | Observed | Repeat after build changes |
| Lifecycle | module load, enable, startup | Confirmed | Observed | Record ordered callbacks |
| Logging | runtime log output | Confirmed | Observed | Add structured marker probe |
| Asset reads | resource lookup by type | Confirmed | Verified | Test one additional resource family |
| Asset fields | typed resource field access | Confirmed for tested items | Verified | Compare field types with catalog |
| Export | `io.export` CSV output | Confirmed | Verified | Test bounded export and evidence marker |
| Configuration | package configuration read | Conditional | Observed | Add read-only config probe |
| UI/actions | loader action registration | Conditional | Observed | Add harmless action/status probe |
| Dependencies | required and optional package checks | Staged | Synthetic | Test missing required dependency |
| Schemas/catalogs | EML/KFC normalized metadata | Confirmed offline | Static/Synthetic | Bind catalog provenance to probe |
| Blueprint metadata | preview bounds and resource counts | Confirmed offline | Synthetic | Test imported snapshot preview |
| Snapshot export | export existing verified snapshot | Conditional | Synthetic | Use a recorded snapshot fixture |
| World reads | voxel/entity/prop queries | Unverified | None | Requires current-build provider evidence |
| Placement | blueprint placement or transforms | Unsupported for now | None | Keep disabled until reads and rollback pass |
| Mutation | game/save writes | Unsupported for now | None | No write probe until explicit guarded milestone |
| Multiplayer | authority and replication | Unsupported for now | None | Requires separate authority test plan |

## Probe rules

- One API category per probe.
- Read-only by default.
- Record game build, loader version, package version, result, and limitations.
- A discovered API is not automatically an executable or writable API.
- Failed probes remain in the history so the matrix records known boundaries.
