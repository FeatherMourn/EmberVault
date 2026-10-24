# Stage 4 Corrections

Date: 2026-10-23

## Implemented

- Bumped the ShroudForge census worker package to version 1.4.5.
- Kept the root and `src` Lua entry points byte-identical.
- Added a per-run export token containing the worker graph version, run number, and snapshot generation.
- Added a unique per-run export alongside the latest convenience export, preventing an old stable file from being mistaken for fresh evidence.
- Added explicit stale-export interpretation rules to every export.
- Added independent status workers for appearance, buffs, buildings, voxels, loot, pickup, localization, resources, and saves. These workers report `unsupported` with a reason and do not guess component names, scan broadly, access saves, or write data.

## Validation

- Root and `src` entry points have matching hashes.
- Repository whitespace validation passes.
- The package remains ShroudForge-only and read-only.
- No live install, game launch, save access, or world change was performed.

## Remaining Stage 4 gate

The package still needs a controlled private-world smoke test to verify that the new per-run exports and explicit unsupported statuses are emitted by the active loader. Native or module-graph changes remain restart-required; source-only Lua changes remain candidates for hot reload.
