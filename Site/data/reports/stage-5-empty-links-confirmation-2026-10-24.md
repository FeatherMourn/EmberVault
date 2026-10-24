# Stage 5 Empty `linksEntities` Confirmation

Date: 2026-10-24

## Result

The current EmberVault/ShroudForge runtime was tested in a live world with the
read-only `InventorySetup` provider port. The reflected schema identifies
`InventorySetup.linksEntities` as an inline `StaticArray<EntityId,16>` at offset
`0x0`.

The bounded reader now reads only the 64-byte field, verifies it with a second
read, and preserves the fail-closed gate. The live result was stable but all 16
entries were zero. The reader now classifies this as:

`component present but empty`

It does not publish an ownership relationship, perform native writes, access
saves, or enable the direct ownership/equipment operation.

## Roadmap impact

- Stage 5 remains active and unresolved.
- The empty negative outcome is confirmed for this target profile.
- Stage 6 inventory/equipment workers remain gated because no unique player to
  inventory relationship was observed.
- Stage 10 remains gated.

## Remaining Stage 5 fixtures

The next validation set must cover absent component, stable empty array,
unstable link words, moved component address, stale player identity or
generation, ambiguous player match, unsupported layout, and one repeatable
unique non-empty relationship across two clean sessions.
