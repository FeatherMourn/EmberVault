# Inventory schema field map

The current 1.0 reflection data identifies these exact fields for the next read-only runtime pass:

- `keen::ecs::Inventory`: `slots`
- `keen::ecs::InventorySetup`: `linksEntities`, `linksCategories`, `inventoryFlags`, `genericSlotCount`, `availableSlotCount`, `isInitialized`
- `keen::ecs::ItemState`: `containedInSlotId`, `itemId`, `baseDamageUi`, `itemState`, `itemRarityUi`, `itemLevelUi`
- `keen::ecs::DefaultInventory`: `defaultInventory`, `keepOnRandomLoot`, `applied`
- `keen::ecs::PerkContainerNew`: `availablePerks`, `unlockedPerks`
- `keen::ecs::WeaponGemSlot`: `weaponGem`
- `keen::ecs::PackedEquipmentSlotEntityIds`: equipment slot entity references including armor, rings, weapons, spells, glider, and backpack.

The prior guessed ownership names were not part of the reflected `Inventory` schema. The next probe will read the exact setup links and inventory slot references, then inspect bounded `ItemState` records reached through those links. No writes are planned.
