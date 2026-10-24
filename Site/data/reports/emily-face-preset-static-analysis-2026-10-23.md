# Emily's Face (New Preset) — Static Analysis

## Scope

The supplied archive was extracted and inspected without executing it or installing it. The analysis covers the manifest, Lua source, binary asset payloads, and the declared ShroudForge patch behavior.

## What it actually adds

This mod does not create a new save-level character slot. It adds a new appearance preset to the client-side character creator and barber-compatible appearance data.

The implementation:

1. Uses the first female player face as a compatible template for the player neck and headgear seam.
2. Reads Emily's NPC render model and material resources by known resource identifiers.
3. Clones the player-facing render model and creates new render-material and texture-content resources.
4. Replaces selected material/image references with bundled binary payloads and adds skin tint-mask references.
5. Creates a new `ItemInfo` head item with a new object identifier and points its visual model at the cloned render model.
6. Clones a character preset, assigns a new preset identifier and the new head item, and preserves selected hair, hair-color, and skin-color defaults.
7. Copies the preview texture and appends a new entry to the character creator's `FbUiBundle.characterCustomizationOptions.presets` list.
8. Validates each expected change and aborts with an error if the target resource, field, or prior value does not match.

## Why it appears as a new slot

The visible extra choice comes from appending an additional preset entry to the character creator UI bundle and the preset collection. It is a new preset row in the selection list, not evidence that the game supports arbitrary player-slot creation.

## Useful research findings

- `keen::CharacterPresetCollection` is a concrete writable resource path for appearance presets.
- `keen::FbUiBundle.characterCustomizationOptions.presets` is the corresponding creator-list path.
- `keen::ItemInfo` can represent a custom head item when its object identifier and visual model references are internally consistent.
- `keen::RenderModel`, `keen::RenderMaterialResource`, and `keen::UiTextureResource` can be cloned and registered through the ShroudForge asset API.
- The mod uses explicit GUID/object-ID relationships and validates hashes, debug names, array lengths, model references, and preset fields before completing.
- The mod supports a preset mode and a separate replacement mode through `variant.lua`; this archive selects preset mode.

## Limits and risks

- The mod declares the `patch` capability and performs live resource writes through `game.assets.create_resource`, resource-data replacement, and array insertion. It is not read-only.
- It does not prove that arbitrary new character slots, extra save containers, or multiplayer player ownership are supported.
- The new preset depends on the mod's resources and identifiers remaining available. Removing or disabling the mod can leave a character referencing missing appearance data; the manifest explicitly warns that the body may become invisible until the mod is restored or the appearance is changed.
- The implementation is version-sensitive: it checks known debug names, resource types, array shapes, material image slots, and preset fields, then fails closed when they differ.

## EmberVault relevance

The strongest reusable lesson is the resource-level appearance pipeline: clone a known-compatible player asset, create a new item and preset identity, append the preset to both the resource collection and UI bundle, and verify every relationship. This is useful for static schema mapping and future guarded appearance research, but it must remain separate from the read-only census and must not be ported into live testing without explicit write gates, backups, readback, and rollback.
