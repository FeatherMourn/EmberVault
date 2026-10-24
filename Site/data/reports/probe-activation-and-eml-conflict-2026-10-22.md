# Probe activation and EML conflict record

## Scope

This record separates ShroudForge activation state from failures inside the
shared EML startup environment. It covers the current retry of the loot,
building/voxel, blueprint, category-definition, resource-type, recipe-category,
and workshop probes.

## Activation rule

An installed probe is not treated as enabled unless its ID appears in
ShroudForge's active runtime list and its output or startup log confirms
execution. The probe folders and manifests may exist while the corresponding
mods remain disabled.

## Observed state

- The loot and building/voxel probes were installed but were not in the active
  runtime list during the latest state check.
- The blueprint probe was previously active and produced a valid export.
- The latest log contains successful enable events for the blueprint and
  category-definition probes, and for the loot/pickup probe.
- The recipe-category, resource-types, and workshop probes failed during the
  pregame phase before their research output could be treated as fresh
  evidence.

## Confounding failure

The failed probes share a startup error attributed to the unrelated
`xhl-enemy-difficulty-limits` mod: it attempted to insert a numeric value into
a typed `keen::BlobArray<keen::float>`. This is a loader/mod interaction, not
evidence that the target resource types or registries are absent.

The same session also logged a missing `creative` mod manifest and existing
Unified EML Tweaks startup/configuration errors. These are additional reasons
not to promote the failed probe runs to capability evidence.

## Census classification

| Probe area | Installed | Active evidence | Fresh result | Current classification |
|---|---:|---:|---:|---|
| Blueprint fields | yes | yes | exported | readable/exportable, bounded fields observed |
| Loot and pickup | yes | inconsistent | prior export only | unresolved under a clean baseline |
| Building and voxel | yes | inconsistent | prior export only | unresolved under a clean baseline |
| Recipe categories | yes | failed pregame | none | blocked by startup conflict |
| Resource types | yes | failed pregame | none | blocked by startup conflict |
| Workshops | yes | failed pregame | none | blocked by startup conflict |
| Category definitions | yes | failed pregame | none | blocked by startup conflict |

No write or persistence capability is established by these runs.

## Required clean retest

Enable the intended probes in ShroudForge, then isolate or disable the
conflicting startup mods for a private-world test. Verify active state before
launch, stop for explicit world-load confirmation, and only then inspect fresh
exports. Do not edit ShroudForge's state file manually to force activation.
