# Character appearance reflection map

The 1.0 reflection data provides concrete schemas for the requested research area:

| Reflected type | Relevant fields |
|---|---|
| `keen::CharacterCustomizationResource` | `presets`, `hairItems`, `beardItems`, `hairColors`, `eyeColors`, `eyeBrowColors`, `skinColors`, `voices` |
| `keen::CharacterPresetResource` | `presetId`, `gender`, `hairColorPresetId`, `beardColorPresetId`, `head`, `hair`, `beard`, body-part fields, armour fields |
| `keen::CharacterPreset` | `gender`, `hairColor`, `beardColor`, `head`, `hair`, `beard`, body-part fields, armour fields, preview model |
| `keen::ecs::CharacterSetup` | `gender`, `presetId`, `hair`, `beard`, `hairColorId`, `beardColorId`, skin/eye fields, `useNewProportions` |
| `keen::ecs::ScaleComponent` | `uniformScale` |

This is the first authoritative field map for hair, facial hair, body customization, and scale. The installed runtime probe targets these exact types and remains read-only. Resource availability and field access still need live verification.
