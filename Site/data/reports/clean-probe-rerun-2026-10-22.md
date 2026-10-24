# Clean probe rerun

## Baseline

Unified EML Tweaks was temporarily moved out of the game mod directory before
launch. The startup log for this session contains no Unified EML Tweaks load or
patch entries. XHL Enemy Difficulty Limits was also not loaded. The probe run
therefore provides a clean baseline for the EmberVault census, apart from the
separate missing `creative` manifest warning.

## Activation and exports

- All 18 runtime EmberVault probes initialized and became active.
- All 6 EML export probes were included in startup preparation and resolved to
  `applied`.
- Fresh exports were produced for the current world session.
- The appearance write probe was run only as its explicitly separated no-op
  test after the read-only probes initialized.

## Clean observations

| Domain | Observation | Classification |
|---|---|---|
| Resource types | 146 visible type names exported | represented, readable, exportable |
| Recipe categories | Recipe registry and category membership exported | represented, readable, exportable |
| Category definitions | Zero standalone category resources | represented in schema; not populated as standalone runtime resources |
| Workshops | One workshop registry resource exported | represented, readable, exportable |
| Localization | One collection resource with language bundle metadata; no standalone text resources | metadata readable/exportable; translation unresolved |
| Blueprints | One item registry, seven configs, and one material-pool registry exposed | readable/exportable bounded blueprint fields |
| Loot and pickup | Targeted ECS surfaces returned nil | schema represented; live component match unresolved |
| Building and voxels | Targeted ECS surfaces returned nil | schema represented; live component match unresolved |
| Inventory | Reflected inventory schemas visible, local player owner not resolved | schema readable; live ownership unresolved |
| Player accessor | No player-state, client-player, or tracking candidates found | accessor unavailable through current probe path |
| Appearance preset path | Same-value hair write accepted, read back, and restored | guarded resource write demonstrated for this path only |

## Limits

The no-op appearance result does not establish live-player ownership, item
instance writes, save persistence, or general write support. No saves, entity
enumeration, native calls, or non-test writes were performed. The missing
`creative` manifest remains a loader hygiene issue but did not reintroduce the
previous tuning-mod conflict.
