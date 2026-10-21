# Evidence History

## 2026-10-21 — Standard EML export baseline

- **Probe:** `eml-export-item-list`
- **Result:** Loaded under ShroudForge and generated `eml-item-list.csv`.
- **Established:** Standard EML discovery, Lua execution, item resource reads,
  and export behavior.
- **Evidence level:** Verified for the tested environment.
- **Not established:** Full EML 2.0 bridge runtime, live world reads,
  placement, save mutation, or multiplayer authority.

## 2026-10-20 — Bridge schema compatibility check

- **Probe:** EML 2.0 bridge probe
- **Result:** EmberVault tooling validated the staged package, but the live
  ShroudForge schema rejected optional compatibility metadata and a custom
  capability label.
- **Established:** The current loader requires its accepted manifest schema.
- **Evidence level:** Observed/static.
- **Decision:** Keep EML 2.0 metadata staged until a real runtime bridge exists;
  use native-compatible manifests for live probes.

## 2026-10-21 — EML 2.0 bridge removed from live scope

- **Decision:** Keep the EML 2.0 bridge staged only and use standard EML
  packages for live compatibility tests.
- **Reason:** The current ShroudForge parser rejects the bridge's extra
  compatibility metadata and custom capability declaration.
- **Impact:** The bridge is not counted as live support. Its source and staged
  package remain available for a future loader/runtime integration.

## 2026-10-21 — Tracked probe manifest validation

- **Scope:** All 11 tracked ShroudForge probe packages in `1.0/probes/`.
- **Result:** All manifests parsed successfully; all use the accepted runtime
  capability; none contains the rejected compatibility field.
- **Evidence level:** Static.
- **Limit:** This validates package shape only; it does not prove runtime
  execution or API behavior.

## Snapshot policy

Add an entry for each meaningful probe or build change. Do not overwrite prior
conclusions; record corrections and regressions as new entries.
