# Recipe and item validation status

## Static validation complete

- 4,262 ItemInfo records were found, each with a source file.
- 2,536 recipes were found, including the single recipe registry source.
- All non-zero recipe input and output references resolve to ItemInfo records.
- 125 zero-valued input references remain classified as category-only requirements.
- 68 recipes are marked as cooking recipes and 14 as upgrade recipes.

## Runtime validation status

The live runtime has already proven that the ItemInfo and recipe resource families are available after world initialization, but no live item or recipe payload read has been captured yet. Therefore the static catalog remains research-only for behavior and writability.

## Next read-only check

On the next world session, read a small representative sample rather than exporting the entire catalog: one ordinary item, one stackable item, one cooking recipe, one upgrade recipe, and one category-only recipe input. Compare IDs, quantities, duration, workshop, and flags against this catalog. No writes, crafting actions, or save access are needed.
