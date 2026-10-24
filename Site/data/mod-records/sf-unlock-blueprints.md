# SF Unlock Blueprints — `sf-unlock-blueprints`

## Short summary

SF Unlock Blueprints is a pregame asset-patch mod that changes recipe knowledge requirements so blueprints are unlocked after restart. It is disabled by default because reverting the change may require resetting affected unlock progress.

## How it works

The mod first verifies that the loader exposes the game asset-write patch capability. It resolves the recipe registry type and then discovers the correct knowledge ID from the named engine query `Unlock_Flame_Altar_PK` and action `NPC_Flame_Hint01`. This is safer than assuming a hard-coded numeric ID.

It scans every `RecipeRegistryResource`. For recipes with a knowledge requirement, it rewrites the requirement to the discovered knowledge ID, an equals comparison, a simple boolean type, and a non-explicit player query. Changed resources are written back during the pregame asset pass, and the mod logs counts of changed recipes and registries.

## Safety and limitations

- Requires the pregame asset-write capability.
- Requires the named query and action to exist in the current game build.
- Requires a restart because the edits occur before gameplay resources are finalized.
- The manifest warns that disabling or reverting the change can require resetting unlock progress.
- It only changes recipes that contain a knowledge requirement; it does not invent new blueprint assets.

## Reverse-engineering assessment

This is a compact example of robust data discovery: it resolves a semantic engine relationship at runtime instead of relying on a brittle numeric constant. It also shows a one-shot pregame patch pattern, with explicit failure checks and useful change counts.

## Confidence

- Source behavior: high; directly inspected.
- Persistent unlock consequences: high; stated in the manifest and reflected in the one-shot patch design.
- Compatibility with future builds: medium; depends on the named query/action and resource fields remaining available.

