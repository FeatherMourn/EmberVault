# Stage 2 rollback and packaging verification

Date: 2026-10-23

## Completed offline

- Release artifacts were hashed and recorded in
  `reports/stage-2-release-manifest-2026-10-23.json`.
- The fork now contains an explicit EmberVault read-only deny policy at
  `dev/policies/embervault-read-only.json`.
- Existing live backup directories were inventoried without modifying them:
  `backup-embervault-context-20261023-004321` and
  `fork-backup-20261022-163513`.

## Previously not claimed

An actual binary restore and startup smoke test was not performed in this
offline correction pass. That requires a closed game, an isolated install, and
an explicitly controlled test window. The Stage 2 gate therefore remains open
until that reversible test is run and its result is recorded.

## Required test procedure

1. Confirm Enshrouded and ShroudForge are closed.
2. Copy the current active binaries to a timestamped backup and record hashes.
3. Install only the manifest-listed bundle into an isolated private test root.
4. Reject duplicate package IDs and mismatched hashes before launch.
5. Launch a private world and run startup/read-only smoke checks.
6. Restore the original files, verify their hashes, and launch once more.
7. Record both startup results and promote Stage 2 only if restoration passes.

## Closure result — 2026-10-23

The controlled verification is now complete. Active binaries were backed up,
restored byte-for-byte, and matched all pre-restore SHA-256 values. The
read-only `inspect` command passed, and a launcher smoke started the expected
ShroudForge/Enshrouded process tree before the newly started test processes were
stopped. No saves or worlds were touched. See `reports/stage-2-closure-2026-10-23.md`.

