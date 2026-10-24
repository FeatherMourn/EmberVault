# Player inventory ownership runtime result

## Evidence

- Session: private-world runtime test after rebuilding and installing the EmberVault ShroudForge fork.
- Probe: `fork-local-player-accessor`, read-only, bounded component queries.
- Player accessor: available.
- Inventory component: readable.
- Inventory query: 145 entities observed.
- Player-handle match: true for the `Inventory` query.
- `InventorySetup`: readable.
- Candidate reflected component types: 44 matching inventory, equipment, item, perk, socket, or gem terms.

## Current boundary

The probe confirmed the player-owned inventory relationship, but the first pass still spent its query budget on ECS scans. It did not yet establish which inventory fields contain item-instance IDs, slots, quantities, levels, durability, perks, gems, or sockets. Those fields are the next targeted read-only pass.

## Safety and provenance

- No writes attempted.
- No save files accessed.
- No unrestricted entity dump performed.
- Evidence source: live ShroudForge export and runtime log, with the raw export kept outside the repository.
- The repository records the sanitized result; the raw export remains available for audit if needed.
