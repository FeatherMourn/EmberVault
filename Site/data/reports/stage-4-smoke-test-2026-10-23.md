# Stage 4 Smoke-Test Result

Date: 2026-10-23

## Result

Rejected as stale evidence. ShroudForge executed the prior 1.4.4 worker package, while the corrected 1.4.5 package was not the active runtime package for this session.

## Evidence

- The observed export identifies probe version 1.4.4 and worker graph version 1.4.4.
- The observed export has no 1.4.5 run token and no unique per-run 1.4.5 artifact.
- The reload result reports success, but that only proves a runtime reload operation completed; it does not prove the intended package version became active.
- The old export reports player, inventory, equipment, and related workers timing out. Those results are not promoted because the package identity is stale.
- No save or world mutation was observed.

## Interpretation

The test correctly exercised the stale-export rejection rule. Stage 4’s new export and worker corrections remain unverified in the live session. The next run must first confirm the active package version in the ShroudForge package inventory or startup log, then collect a 1.4.5 per-run export. Do not interpret the old timeout results as a failure of the corrected worker.

## Safety

No live files were changed during this read-only evidence check.
