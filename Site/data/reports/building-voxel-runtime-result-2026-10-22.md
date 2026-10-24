# Building and voxel runtime result

## Session result

The read-only `embervault_building_voxel_census_sf` probe exported successfully after the private world loaded.

Confirmed:

- ECS query and field-read functions were callable.
- Asset resource lookup was callable.
- `VoxelBlueprintItemRegistryResource` returned one resource.
- `VoxelBlueprintConfig` returned seven resources.
- Queries for `VoxelModel`, `VoxelModelVolatile`, `VoxelModelResourceComponent`, `NoBuildZone`, `ClientNoBuildZone`, and `BuildingLootMemory` returned no results.
- No entities were enumerated, no IDs were exported, no saves were accessed, and no writes were attempted.

## Classification

| Capability | Result |
|---|---|
| Building/voxel schemas represented | Verified statically |
| Blueprint registry resources readable | Observed in runtime: one registry and seven configs |
| Live voxel/no-build-zone components readable | Not observed in this session |
| Probe export | Verified |
| Placement/building writes | Not attempted |
| Persistence | Not tested |

## Runtime boundary

The ShroudForge log reached a guarded local-authority ECS state and reported voxel context ready, but the resource service remained unavailable because its item-registry pointer was unavailable. The runtime’s generic writable capability flag is not evidence that building or voxel writes are supported; no write claim is made.

## Conclusion

Blueprint resources are the first confirmed runtime-readable building surface. Live voxel and no-build-zone ownership remains unresolved. A later probe could read bounded fields from the seven blueprint resources, but any world placement, pickup, teardown, or terrain modification remains untested and out of scope for this read-only census step.
