# KFC Data Usefulness Report

Source: current local KFC export and cache type index. This report is read-only research; it does not imply that every field is safe to write at runtime.

## Highest-value integrations

| Domain | KFC families | EmberVault use | ShroudForge use | Confidence |
|---|---|---|---|---|
| Items and recipes | ItemInfo, ItemRegistryResource, RecipeRegistryResource, LootableItemsResource | searchable item/recipe browser, material planning, loot explanations | typed resource lookup and read-only templates | High |
| Tuning and progression | GameSettingsPresetsResource, BalancingTable, AttributeContainerResource, Perk, SkillTreeResource, BuffTypeCollectionResource | plain-language tuning catalog and progression planner | field/type hints and compatibility warnings | High for reading |
| Sequences and AI | SequenceResource, ActorSequenceResource, AnimationSequenceContainer, EnemyArsenalRegistryResource | sequence explorer and behavior research | Lua references for sequence/resource inspection | Medium |
| World and map | MapMarkerRegistryResource, UiMapResource, BiomeMapResource, ZoneVisualizationResource, WeatherSystemResource | map layers, markers, biome/weather reference | world-resource lookup templates | High for reading |
| Building and materials | VoxelBlueprintConfig, VoxelBlueprintItemRegistryResource, VoxelBlueprintMaterialPoolRegistryResource, BuildingMaterialParametersResource, TerraformingEfficiencyRegistryResource | blueprint material lists and building planner | asset/type hints | High for reading |
| Localization and UI | LocaTagCollectionResource, FbUiBundle, UiTextureResource, UiFontResource | readable names and localization-aware catalogs | localization tag references | High for lookup |
| Audio, VFX, and animation | SoundResource, VfxResource, JointAnimation, RootMotionAnimation, RenderModel | asset discovery and preview metadata | safe reference templates, not automatic injection | Medium |
| Version comparison | all structured families plus types.json | diff reports after game updates | mod compatibility reports | High |

## Scale found

- 12,646 current type records with readable names and numeric hashes.
- 91,812 extracted KFC descriptors.
- 4,262 ItemInfo records.
- 2,899 SequenceResource records.
- 2,894 AnimationSequenceContainer records.
- 2,157 ActorSequenceResource records.
- 365 Perk records.
- 30 FishSpawnTableResource records.
- 7 TrashLootTable records.
- 1 each of the central registries for recipes, items, map markers, game settings, localization, skill trees, and enemy arsenals.

## Recommended build order

1. Item and recipe catalog with readable names, tags, stack limits, and ingredient relationships.
2. Tuning and progression catalog using game settings, attributes, perks, buffs, and skills.
3. Version-diff engine comparing type hashes, resource families, and selected fields.
4. ShroudForge lookup service for qualified names, hashes, Lua references, and compatibility notes.
5. Sequence and enemy behavior explorer as a research-only view.
6. Map, building, and localization views using the central registries.

## Safety boundary

KFC describes game data; it does not prove that a field can be safely modified in a live game. EmberVault should remain read-only by default, and ShroudForge integrations should generate references or staged plans until a field has an approved runtime adapter, backup path, and restoration test.
