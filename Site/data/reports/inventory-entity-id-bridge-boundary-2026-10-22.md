# Inventory entity-ID bridge boundary

The runtime census established that `InventorySetup.linksEntities` exposes 16 related entity references per setup. The values are reflected `EntityId` userdata, not the numeric entity argument accepted by the current Lua `runtime.ecs.read_fields` API.

The bounded bridge test produced zero successful linked-inventory reads. This does not show that the links are invalid; it shows that the current fork lacks a supported conversion from reflected `EntityId` values to ECS entity handles or numeric entity IDs.

Next fork milestone: add a typed, read-only entity-ID conversion or an ECS read-by-entity-reference operation, with generation/session validation and no write capability. Only then should item-state fields be read through inventory links.
