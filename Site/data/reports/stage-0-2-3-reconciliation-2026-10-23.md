# Stage 0–3 reconciliation

Date: 2026-10-23
Scope: provenance, private-fork release baseline, and provider-runtime readiness.

## Stage 0 — provenance correction

- The current live ShroudForge worker is `embervault_census_workers_sf`, version
  `1.4.6`.
- The package is ShroudForge-only for live use; EML references remain historical
  or static corroboration only.
- Fresh evidence is `shroudforge/exports/embervault/census-workers-v146-run-1.tsv`
  and its `census-workers-latest.tsv` pointer.
- The run proves per-run export identity, terminal worker statuses, and the
  global deadline. It does not prove player ownership: player context timed out,
  snapshot generation remained unknown, and downstream workers timed out or
  were blocked by the deadline.
- The prior package/cache copies were quarantined rather than deleted. This is
  reversible evidence, not proof of a completed restore/startup test.

## Stage 2 — release baseline correction

The release record now includes the stable package identity, probe version,
package hashes, cache-quarantine state, and rollback limitation in
`stage-2-release-manifest-2026-10-23-v146.json`.

Stage 2 remains **partial**. The package replacement was reversible and the
1.4.6 smoke run executed, but a full restore-to-known-good followed by a second
startup verification has not been run in this pass. Do not promote Stage 2 to
complete until that test is recorded.

## Stage 3 — provider-runtime correction

Stage 3 remains **complete for the offline foundation only**. The 1.4.6 result
confirms bounded provider/export behavior and explicit timeout handling. It does
not promote live player-context, inventory ownership, equipment ownership, or
snapshot-generation access. Those remain downstream capability work and must be
reported as unavailable or unresolved rather than inferred from static schemas.

## Current gate

The next logical work is not another broad restart. First close the Stage 2
restore/startup evidence gap if release closure is required; otherwise proceed
to Stage 5 with player context explicitly blocked and the 1.4.6 export retained
as the baseline.
