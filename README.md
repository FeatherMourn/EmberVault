# EmberVault

EmberVault is a curated, build-aware research map for Enshrouded modding. It tracks what can be observed, exported, tested, and supported through ShroudForge and related tools without storing the game's raw KFC files.

## Versioning

Each game snapshot lives in its own root folder:

```text
1.0/
1.1/
1.2/
```

Create a new version folder when the game build or the compatible runtime changes. Do not overwrite an earlier snapshot. Keep the folder name tied to the map/research version, and record the exact game build and loader information in that snapshot's `metadata.json`.

## Setup

1. Export the game's KFC data locally using the supported tooling.
2. Compare the export identity and type inventory with the snapshot metadata.
3. Use the curated catalogs and indexes for research; treat raw exports as local source material.
4. Install probes only in an isolated or backed-up test profile.
5. Record fresh probe results with the matching game build and ShroudForge version.
6. Add new catalogs, reports, adapter contracts, and methods under the current version folder.

## Provenance rules

- Raw KFC files are not committed to this repository.
- Every catalog, report, probe, and adapter record must identify its source, build, loader version, collection date, and limitations.
- Static, synthetic, and live runtime evidence must remain clearly separated.
- A probe result does not prove that a write or in-game capability is supported.
- An adapter is promoted only after current-build evidence, readback, and rollback checks pass.
- Do not include private save data, credentials, or unreviewed game binaries.

## Structure

```text
1.0/
  catalogs/    Curated resource and schema indexes
  reports/     Audits, usefulness reports, and findings
  probes/      ShroudForge-format read-only probe packages
  adapters/    Adapter diagnostics and capability records
  methods/     Collection methods, roadmaps, and review rules
  metadata.json
```

Future versions should preserve this structure where possible so build-to-build diffs remain easy to review.
Repo of Enshrouded Game Files to Assist With Modding
