# Full probe rerun

## Session result

The current EmberVault probe set was rerun after the user confirmed the game
was loaded in a private world. ShroudForge reported the runtime probes active;
the six EML export probes were resolved and applied during startup. Fresh
exports were present for the current session.

## Read-only evidence collected

- Resource-type probe completed with 146 visible type names.
- Recipe-category probe completed and exported the recipe registry and input
  category membership data.
- Category-definition probe completed, but exposed zero standalone category
  resources.
- Workshop probe completed with one workshop registry resource.
- Localization and localization-inventory probes completed with one
  `LocaTagCollectionResource`; the text bundles remain referenced by hashes,
  not returned as translated strings.
- Blueprint probe exposed one blueprint item registry and seven blueprint
  configuration records. Blueprint fields included IDs, sizes, compressed
  payload flags, debug names, and snapping data.
- Building/voxel and loot/pickup probes executed. Their targeted ECS component
  queries remained empty; no entities, saves, native calls, or writes were
  attempted by those probes.
- Inventory and player-accessor probes executed. Reflected schemas were
  visible, but no local player owner or live item instances were resolved.
- Appearance, template, component, and item-instance probes refreshed their
  current exports.

## Separate guarded write check

The appearance write probe was included as a separately labeled test. It
targeted the existing first character-preset hair value, wrote the same value
back, read it successfully, and restored it. Result: accepted no-op with a
matching readback. This proves only that the preset resource path accepted a
same-value write; it does not prove live-player ownership, item-instance
writes, save persistence, or general write support.

## Confounding state

The session log still shows Unified EML Tweaks executing resource patches,
including ItemInfo, lootable-items, inventory, and balancing changes, despite
the attempted disable. It also records a missing `creative` mod manifest.
Therefore the probe outputs are valid observations of this session, but the
session is not a clean baseline for attributing tuning or write behavior to
the EmberVault probes alone.

## Capability classification

| Area | Represented | Readable/exported | Writable evidence | Persistent evidence |
|---|---|---|---|---|
| Resource types | yes | yes | none | none |
| Recipes/categories | yes | yes | none | none |
| Workshops | yes | yes | none | none |
| Localization metadata | yes | yes | none | none |
| Blueprints | yes | yes | none | none |
| Loot/pickup ECS surfaces | yes | no live matches | none | none |
| Player inventory ownership | yes in schema | not resolved | none | none |
| Character preset hair path | yes | yes | same-value no-op accepted | not tested |

No save files were accessed or changed by this rerun.
