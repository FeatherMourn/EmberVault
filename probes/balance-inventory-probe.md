# Balance inventory probe

This probe is restricted to local or private-world research. It is read-only and does not alter saves, resources, recipes, progression, or network state.

## Inventory scope

- ItemInfo IDs, GUIDs, debug names, stack limits, durability and displayed-stat references.
- Recipe inputs and outputs, quantities, workshop IDs, category references, cooking flags, and upgrade flags.
- Workshop and station identifiers, including verified ItemInfo fallback names.
- Progression and unlock references where exposed by the static catalogs.
- Provenance for every value: static KFC evidence, cache evidence, runtime observation, or inference.

## Output rules

The adapter should emit a compact TSV or JSON catalog suitable for balance review. It must preserve unresolved and inferred values, never guess missing IDs, and keep raw game files outside the repository.

## Explicit boundary

This inventory does not patch files, alter live memory, bypass protections, automate multiplayer actions, or provide an advantage in online play. Any later balance change should be a separate, user-reviewed local mod with backups and an explicit target list.
