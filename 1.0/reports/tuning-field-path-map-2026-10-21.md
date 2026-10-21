# Tuning field-path map

## Game settings paths

| Field path | System | Storage | Editability status |
|---|---|---|---|
| `GameSettingsPresetsResource.minValues.playerHealthFactor` / `maxValues.playerHealthFactor` | Player health | Settings preset resource | Configuration candidate |
| `...playerManaFactor` | Player mana | Settings preset resource | Configuration candidate |
| `...playerStaminaFactor` | Player stamina | Settings preset resource | Configuration candidate |
| `...enableDurability` | Durability toggle | Settings preset resource | Configuration candidate |
| `...enableStarvingDebuff` | Hunger toggle | Settings preset resource | Configuration candidate |
| `...foodBuffDurationFactor` | Food buffs | Settings preset resource | Configuration candidate |
| `...shroudTimeFactor` | Shroud timing | Settings preset resource | Configuration candidate |
| `...miningDamageFactor` | Mining | Settings preset resource | Configuration candidate |
| `...plantGrowthSpeedFactor` | Farming | Settings preset resource | Configuration candidate |
| `...resourceDropStackAmountFactor` | Resource yield | Settings preset resource | Configuration candidate |
| `...factoryProductionSpeedFactor` | Production | Settings preset resource | Configuration candidate |
| `...experienceCombatFactor`, `...experienceMiningFactor`, `...experienceExplorationQuestsFactor` | Experience | Settings preset resource | Configuration candidate |
| `...enemyDamageFactor`, `...enemyHealthFactor`, `...bossDamageFactor`, `...bossHealthFactor` | Enemy and boss balance | Settings preset resource | Configuration candidate |
| `...enemyPerceptionRangeFactor`, `...aggroPoolAmount` | Detection and aggro | Settings preset resource | Configuration candidate |
| `...pacifyAllEnemies` | Enemy behavior toggle | Settings preset resource | Configuration candidate |
| `...dayTimeDuration`, `...nightTimeDuration` | World time | Settings preset resource | Configuration candidate |
| `...tombstoneMode`, `...weatherFrequency`, `...fishingDifficulty`, `...curseModifier` | World rules | Settings preset resource | Configuration candidate |

## Core balancing paths

| Field path | System | Storage | Editability status |
|---|---|---|---|
| `BalancingTable.playerLevelCap`, `itemLevelCap` | Progression caps | Static balancing resource | Static observed; writable unknown |
| `BalancingTable.flameLevelMax`, `altarLevelMax` | Flame and altar progression | Static balancing resource | Static observed; writable unknown |
| `BalancingTable.buildzoneSizesPerAltarLevel` | Building area | Static balancing resource | Static observed; writable unknown |
| `BalancingTable.damageBoostFlame`, `damageMod2Handed` | Damage formulas | Static balancing resource | Static observed; writable unknown |
| `BalancingTable.playerBaseHealth`, `playerBaseMana` | Base attributes | Static balancing resource | Static observed; writable unknown |
| `BalancingTable.perkUpgradeCostSeed`, `perkCostCreep` | Perk costs | Static balancing resource | Static observed; writable unknown |
| `BalancingTable.freezeDurationFactor`, `suffocationDuration` | Status timing | Static balancing resource | Static observed; writable unknown |
| `BalancingTable.durabilityLossCap` | Durability | Static balancing resource | Static observed; writable unknown |

## Consumer tracing status

The settings resource supplies explicit ranges and presets, so it is the strongest configuration candidate. The BalancingTable fields are authoritative static constants, but their consumers and supported override path remain unverified while the current runtime resource service is unavailable.

No values were changed. This map is for local/private-world research only.
