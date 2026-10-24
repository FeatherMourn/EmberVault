# Stage 4 Scheduler and Hot Reload Audit

Date: 2026-10-23

## Result

Stage 4 is offline-complete and awaiting one controlled private-world smoke run. The fork has a working scheduler, shared read-only snapshot/cache, bounded scan modes, cancellation/deadline infrastructure, lifecycle states, a ShroudForge runtime reload path, independent contracts for every declared census domain, and explicit reload classification. Lua-only source changes can reload in-world when the module graph is unchanged. Native binaries, ABI/profile changes, manifest identity changes, and module-graph changes remain restart-required.

## Verified

- Independent worker scheduling and bounded budgets exist in the fork and the packaged census worker covers player context, inventory links, inventory reads, and equipment.
- Shared snapshot/cache and world-generation invalidation are implemented for the current worker package.
- Fast, balanced, deep, and offline-replay modes are represented by explicit budgets.
- Reload requests produce a matching result and runtime package replacement has rollback behavior on activation failure.
- Lifecycle tests distinguish live settings from restart-required changes.
- Cancellation, deadlines, stale-data rejection, and no-partial-export behavior are covered by existing runtime tests.

## Gaps

- Live evidence is still required; the package has not yet been validated in a fresh private-world run after the current worker-contract correction.
- Runtime checkpoint and differential behavior is contract-tested offline but still needs one smoke-run observation.

## Required completion work

1. Run the 34-check EmberVault worker-contract suite and the broader workspace tests.
2. Confirm a fresh v1.4.6 export in a private world with independent terminal worker statuses.
3. Confirm the active package emits the reload classification and stale-export markers.

## Safety boundary

This audit changed no live game files, saves, worlds, or runtime binaries. Stage 4 remains read-only; editor and write work stay downstream.
