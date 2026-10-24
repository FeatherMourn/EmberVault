# Recipe Category Source Trace

The 22 category references used by the 125 zero-item recipe inputs were traced
through the local KFC export.

## Result

- All references are present in the recipe registry and item/recipe catalog.
- No separate category-name registry was found in the inspected KFC resource
  folders.
- The category GUIDs did not match the normalized ItemInfo tag arrays.
- Category IDs and GUIDs are therefore retained as unresolved identifiers.

## Interpretation

These references likely represent category or filter definitions consumed by
the recipe system rather than ordinary ItemInfo tags. Their human-readable
names require either a dedicated category registry not present in this export,
or a bounded runtime read through EML.

## Safety boundary

This is static, read-only evidence. No category names are inferred, and no
recipe or game data is modified.
