# Character appearance field types

Reflection resolves the exact field types for the appearance candidates:

## `keen::ecs::CharacterSetup`

- `hair`: `keen::ItemId`
- `beard`: `keen::ItemId`
- `hairColorId`, `beardColorId`, `skinColor`, `eyeBrowColor`, `eyeColor`: `keen::ColorPresetId`
- `presetId`: `keen::CharacterPresetId`
- `useNewProportions`: `keen::bool`
- `gender`: `keen::Gender`

## `keen::CharacterPresetResource`

- `hair`, `beard`, and body-part fields: `keen::ItemId`
- Color preset fields: `keen::ColorPresetId`
- `presetId`: `keen::CharacterPresetId`

## `keen::ecs::ScaleComponent`

- `uniformScale`: `keen::float32`

These types are suitable for a type-checked accessor if they are exposed through a live resource or component handle. Runtime ownership and write admission remain unverified.
