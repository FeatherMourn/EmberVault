# Live character schema read

The exact-schema probe completed in a private world.

## Verified live access

- `keen::CharacterPresetCollection` is available as one live resource.
- Its `presets`, `colors`, and `knowledgeUnlocks` fields are typed userdata.
- Nested access through `presets[1]` succeeded for `presetId`, `gender`, `hair`, `beard`, `hairColorPresetId`, `beardColorPresetId`, and `head`.
- The nested identifiers are returned as typed values with an underlying numeric value.

## Not standalone resources

`CharacterCustomizationResource`, `CharacterPresetResource`, `keen::ecs::CharacterSetup`, and `keen::ecs::ScaleComponent` returned zero standalone resources in this probe. The static export shows the latter two embedded in templates.

## Write status

The runtime reported ECS guarded-read-write, but the resource write gate was unavailable because the authoritative resource-service owner was not resolved. No override or write was attempted. The appearance write gate therefore remains closed.
