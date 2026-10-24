# XHL Enemy Difficulty Limits — `xhl-enemy-difficulty-limits`

## Short summary

XHL Enemy Difficulty Limits extends seven enemy and boss difficulty settings beyond the normal UI range, up to 10000 percent in the world-setting bounds. It uses a Lua asset patch for the setting arrays and a native plugin for runtime enemy-perception scaling.

## How it works

The Lua side locates `keen::FbUiBundle` and `keen::GameSettingsPresetsResource`. It validates all seven expected setting keys and maximum-value fields before changing anything. It appends additional selectable steps from 2.5 through 100 and changes the corresponding world maximum fields to 100, leaving existing values, minimums, and presets intact.

The native companion is enabled by `native-plugin.ini`. Its purpose is described in the manifest as repairing runtime enemy perception scaling, which is separate from merely expanding the visible slider range. The native DLL is loaded through the current proxy and performs build-sensitive runtime work.

## Affected settings

- Enemy damage
- Boss damage
- Enemy health
- Boss health
- Enemy stamina
- Enemy perception range
- Enemy attack frequency/threat bonus

## Safety and limitations

The Lua patch fails before mutation if the expected resource layout is missing. The extended manifest is disabled by default, so the user-facing patch should not activate unless explicitly enabled. The native component has its own compatibility risk because runtime perception scaling depends on the current executable layout.

## Reverse-engineering assessment

This is another hybrid design where Lua changes data tables and a native DLL handles behavior that cannot be safely expressed as a simple asset edit. The validation-first pattern is particularly useful: discover all required fields, then mutate only after the complete layout passes validation.

## Confidence

- Lua resource targets and seven-field mapping: high; directly inspected.
- Slider and world-limit changes: high; directly shown in source.
- Native perception repair details: medium; documented by metadata and embedded strings, but not source-level verified.

