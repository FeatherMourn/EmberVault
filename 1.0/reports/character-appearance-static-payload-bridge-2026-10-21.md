# Character appearance static payload bridge

The unpacked 1.0 KFC export confirms that the reflected schemas are used in real template payloads.

## CharacterSetup payload

Observed `keen::ecs::CharacterSetup` records contain:

- `gender`
- `voicePackId.value`
- `presetId.value`
- `hair.value`
- `beard.value`
- `hairColorId.value`
- `beardColorId.value`
- `skinColor.value`
- `eyeBrowColor.value`
- `eyeColor.value`
- `useNewProportions`

The hair, beard, preset, and color values are hashed identifiers, not display names.

## Scale payload

Observed `keen::ecs::ScaleComponent` records contain `uniformScale` as a numeric value. A sampled payload had a value of approximately 0.6.

## Boundary

This proves the static template path and field shapes, but not that these components belong to the live player entity or that they are writable through the current runtime session. The exact-schema runtime probe remains the required read-only verification step.
