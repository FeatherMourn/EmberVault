# Supported resource accessor evidence

The KFC parser/EML implementation documentation establishes the supported accessor model:

- `game.assets.get_resources_by_type(type)` returns typed resource objects.
- A resource's `data` value is typed Lua userdata with field access semantics.
- Nested typed fields are intended to be read like regular Lua fields.
- Resource field assignments are validated by the runtime; invalid values raise an error.
- Reference assignments create validated deep copies.

For the appearance goal, the exact reflected schemas are now known: `CharacterCustomizationResource`, `CharacterPresetResource`, `CharacterPreset`, `ecs::CharacterSetup`, and `ecs::ScaleComponent`. The character schema probe targets these types and their hair, beard, color, proportion, preset, and scale fields.

## Current proof boundary

The documentation proves that a supported accessor model exists for typed resource data. It does not yet prove that actor appearance data is exposed as a loaded writable resource in this Enshrouded 1.0 session, nor that `ecs::CharacterSetup` or `ecs::ScaleComponent` can be written safely. The next evidence is the live read-only probe export, followed by any explicitly authorized local/private write test only if the runtime reports a guarded path.
