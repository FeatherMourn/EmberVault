# Building and voxel static census

## Scope

Read-only review of the Enshrouded 1.0 reflection metadata for placement, building limits, no-build zones, voxel materials, blueprints, and building events.

## Confirmed represented surfaces

| Surface | Evidence | Classification |
|---|---|---|
| Voxel rendering | `keen.ecs.VoxelModel`, `VoxelModelVolatile`, `VoxelModelResourceComponent` | Represented; live read not proven |
| No-build zones | `keen.ecs.NoBuildZone`, `ClientNoBuildZone`, `SceneBuildZonesMessage` | Represented; live read not proven |
| Placement checks | `VoxelRequirements`, placement collider/no-build-zone fields, water and topology checks | Represented; editability unproven |
| Placement state | Cursor flags include outside-zone, too-far, and fog-zone conditions; placement volume fields are reflected | Represented; runtime consumer unproven |
| Building events | `BuildingPlaceEvent`, `BuildingPickUpEvent`, `BuildingTearDownEvent` include position, orientation, and entity/owner references | Represented; event subscription not tested |
| Blueprint registry | `VoxelBlueprintItemRegistryResource` maps blueprint item IDs and sizes | Represented; resource availability not tested in this domain |
| Terraforming | `BuildingTerraformingConfig`, `VoxelRequirement`, and voxel material mappings | Represented; runtime access and persistence unproven |

## Capability classification

- **Represented:** high confidence from current 1.0 reflection metadata.
- **Readable:** not yet proven for live building or voxel entities through the current supported runtime path.
- **Exportable:** not yet tested with a bounded building/voxel probe.
- **Writable:** not claimed. Placement and teardown event types do not imply a supported write API.
- **Persistent:** not claimed. Save-container round-trip evidence is still missing for building or voxel changes.

## Research implication

The current schema is sufficient to design a bounded read-only probe for no-build zones, voxel model components, blueprint registry availability, and placement-state metadata. It is not sufficient to claim that a mod can place, pick up, tear down, or alter terrain. Those operations require a supported runtime owner, event/accessor path, and persistence validation.

## Provenance and limits

- Source: Enshrouded 1.0 `.cache` Lua reflection metadata.
- No live entities, save files, or world state were accessed for this report.
- Historical pre-1.0 building research may guide hypotheses but is not current-build proof.
