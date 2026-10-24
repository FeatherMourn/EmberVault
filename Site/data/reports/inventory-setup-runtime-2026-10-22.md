# Inventory setup runtime result

- `InventorySetup` query completed with 139 entities observed.
- Exact reflected fields `linksEntities`, `linksCategories`, `inventoryFlags`, `genericSlotCount`, `availableSlotCount`, and `isInitialized` were readable on bounded samples.
- The two link arrays are exposed to Lua as opaque read-only collections rather than ordinary tables.
- Direct player-handle reads still do not expose `InventorySetup`.
- The next probe should use supported indexed field paths for the link arrays, then compare the resulting entity references against the validated player context.
- No writes, save access, or unrestricted entity enumeration occurred.
