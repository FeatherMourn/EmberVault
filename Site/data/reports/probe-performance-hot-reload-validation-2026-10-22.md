# Probe Performance and Hot-Reload Validation — 2026-10-22

## Hot reload

The rebuilt EmberVault ShroudForge runtime processed `runtime/mod-reload-request.json` successfully:

- request operation: reload
- target: `embervault_fork_local_player_probe_sf_v15`
- result: `status=reloaded`
- no game restart occurred for the reload

An earlier attempt was correctly refused because `sf-unlimited-flight` and then `sf-survival` had pending cleanup claims. After an isolated restart, the reload completed cleanly. This confirms that active-mod cleanup is a prerequisite for hot reload.

## Consolidated inventory scan

The post-reload probe exported `fork-local-player-accessor-v25.tsv` in the active private world. It completed after 14 readiness attempts and remained read-only.

Observed results:

- local player handle available: `entityId=1`, generation `0`;
- `InventorySetup` registry count: 135;
- linked Entity IDs resolved successfully through the fork accessor;
- `Inventory` registry count: 142;
- bounded scan found 9 populated inventories;
- populated slot counts and item-reference IDs were readable, including IDs `6651`, `6652`, `6644`, `6646`, `6645`, `6647`, `6648`, and `6660`;
- no saves, writes, entity dumps, or native memory hooks were used.

## Performance conclusion

The consolidated worker reduced the process to one world session and one export, but the broad inventory registry still required ECS readiness polling. The next optimization is to split the current worker into player-context, inventory-links, inventory-scan, and item-state workers backed by a shared read scheduler. The scheduler should deduplicate registry scans and let unrelated workers export independently.
