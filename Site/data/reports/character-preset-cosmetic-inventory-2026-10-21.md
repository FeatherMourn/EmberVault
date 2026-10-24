# Character preset cosmetic inventory

The static `CharacterPresetCollection` resource provides a concrete cosmetic catalog.

- Total presets: 54.
- Presets marked as player customization options: 25.
- Presets with nonzero hair references: 53.
- Presets with nonzero beard references: 16.
- Preset records also carry head, body-part, armour, hair-color, beard-color, skin-color, eye, and voice references.

The `references` subrecord uses GUID references for the visual parts, while the runtime-facing preset fields use hashed identifiers. This gives us a static bridge for hair and beard assets, but does not establish that changing a preset or `CharacterSetup` value will update a live player. That requires the exact-schema runtime read and a separate guarded-write capability check.
