# Tuning overrideability matrix

This matrix separates where a value lives from whether a mod can override it.

| Source | Read status | Override path indicated by documentation | Current classification |
|---|---|---|---|
| `BalancingTable` | Static KFC export confirmed | No general write proof; would require a supported patch/resource-write path | Static observed; writable status unknown |
| `GameSettingsPresetsResource` | Static KFC export confirmed with min/max and presets | Candidate for configuration or guarded resource override, but requires an active supported profile | Configuration candidate; not tested |
| `ItemInfo` and recipe resources | Static catalog confirmed | Guarded loaded-resource field writes are documented for supported fields | Resource-write candidate; field-specific |
| Runtime ECS attributes | API documentation exists | Requires runtime capability, matching profile, world context, and guarded ownership | Runtime-only candidate |
| Modloader settings | Supported by ShroudForge manifests | Read by the mod through its own settings API | Mod-local settings, not game-data overrides |

## Current blockers

The active ShroudForge session reports the resource service unavailable and the main owner unavailable. Therefore no live write or override test should be attempted yet. Static presence, documented API support, and actual editability remain separate evidence states.

## Safe test order

1. Confirm a supported read-only resource profile.
2. Read one known scalar and record its original value.
3. If authorized for a local/private world, test one reversible field with compare-and-restore behavior.
4. Verify the value in-game and restore it before ending the session.

No multiplayer, anti-cheat bypass, or original-file replacement is part of this workflow.
