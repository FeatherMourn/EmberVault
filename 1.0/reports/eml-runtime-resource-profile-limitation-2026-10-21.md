# EML runtime resource profile limitation

## Confirmed result

The ShroudForge-native localization diagnostic loads successfully and appears in the active runtime list. This verifies that ShroudForge can load the diagnostic package and that the package structure is valid.

The EML localization probe does not produce an export because the active runtime reports no exact resource-read profile. The runtime is initialized, but its resource service is unavailable and the game profile remains missing or ambiguous. This prevents EML resource enumeration and export during the current Enshrouded 1.0 session.

## Interpretation

This is a runtime/profile limitation, not a localization probe packaging failure. The static KFC and cache evidence remains usable for identifiers, workshop GUIDs, and numeric localization IDs. Human-readable workshop names require either a compatible EML resource-read profile or a decoded localization bundle.

## Evidence state and safety

- ShroudForge diagnostic: observed active runtime load.
- EML localization probe: not executed to completion.
- No game data or KFC source files were modified.
- The numeric workshop localization IDs remain preserved in the workshop join report.
