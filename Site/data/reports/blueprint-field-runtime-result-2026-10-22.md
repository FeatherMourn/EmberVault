# Blueprint field runtime result

## Session result

The bounded read-only blueprint-field probe exported successfully after the private world loaded.

Observed:

- One `VoxelBlueprintItemRegistryResource` was readable.
- Seven `VoxelBlueprintConfig` resources were readable.
- Blueprint item collections, item IDs, sizes, data payloads, and compression flags were present as opaque userdata or typed values.
- All seven blueprint configs exposed a string `debugName` and present `snappingConfig` and `snappingConfig.rules` values.
- The tested material-pool registry resource was present, but the candidate `pools` and `elements` paths were not exposed under those names.
- No writes, entity enumeration, native calls, or save access occurred.

## Classification

| Capability | Result |
|---|---|
| Blueprint schema represented | Verified statically |
| Blueprint resources readable | Verified at runtime |
| Named blueprint fields readable | Verified for debug names and field presence |
| Nested payload semantics | Not decoded; userdata only |
| Blueprint or terrain writes | Not attempted |
| Persistence | Not tested |

## Enablement note

The probe was copied into the active mods directory and ShroudForge recorded it in its active runtime state. Its export proves it executed in this session; no separate claim is made that every installed probe is enabled merely because its files exist.

## Conclusion

Blueprint resources are a confirmed readable runtime surface. Their nested payloads remain opaque through the current Lua field interface, so this result does not establish a supported path for editing blueprint data or placing terrain.
