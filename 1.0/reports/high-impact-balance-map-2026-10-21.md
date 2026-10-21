# High-impact balance map

These are ranked by gameplay impact for local/private balancing. The map does not claim that the fields are writable.

| Field path | Observed bounds | Likely consumer | Evidence |
|---|---:|---|---|
| `GameSettingsPresetsResource.enemyHealthFactor` | 0.25–4.0 | General enemy health scaling | Static settings resource |
| `GameSettingsPresetsResource.enemyDamageFactor` | 0.25–2.5 | General enemy damage scaling | Static settings resource |
| `GameSettingsPresetsResource.bossHealthFactor` | 0.2–4.0 | Boss health scaling | Static settings resource |
| `GameSettingsPresetsResource.bossDamageFactor` | 0.2–5.0 | Boss damage scaling | Static settings resource |
| `GameSettingsPresetsResource.playerHealthFactor` | 0.25–4.0 | Player health scaling | Static settings resource |
| `GameSettingsPresetsResource.playerStaminaFactor` | 0.25–4.0 | Player stamina scaling | Static settings resource |
| `GameSettingsPresetsResource.playerManaFactor` | 0.25–4.0 | Player mana scaling | Static settings resource |
| `GameSettingsPresetsResource.experienceCombatFactor` | 0.25–2.0 | Combat XP | Static settings resource |
| `GameSettingsPresetsResource.experienceMiningFactor` | 0.0–2.0 | Mining XP | Static settings resource |
| `GameSettingsPresetsResource.experienceExplorationQuestsFactor` | 0.25–2.0 | Exploration and quest XP | Static settings resource |
| `GameSettingsPresetsResource.resourceDropStackAmountFactor` | 0.25–2.0 | Resource yield | Static settings resource |
| `GameSettingsPresetsResource.factoryProductionSpeedFactor` | 0.25–2.0 | Production duration or throughput | Static settings resource |
| `GameSettingsPresetsResource.miningDamageFactor` | 0.5–2.0 | Mining speed or damage | Static settings resource |
| `GameSettingsPresetsResource.plantGrowthSpeedFactor` | 0.25–2.0 | Plant growth timing | Static settings resource |
| `GameSettingsPresetsResource.enableDurability` | Boolean | Durability system enablement | Static settings resource |

## Consumer confidence

The field names and ranges are directly observed. The consumer labels are semantic interpretations from the field names and settings grouping, not runtime tracing. A runtime profile or supported settings readback is required before promoting any consumer relationship to confirmed.

## Safety boundary

This is a read-only research map for local/private worlds. It does not provide multiplayer advantages, bypass protections, or modify game data.
