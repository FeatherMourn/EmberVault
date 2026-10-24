# Static balance adapter

Implemented `adapters/static-balance-catalog.ps1` from the verified ItemInfo and recipe-targeting catalogs.

The adapter joins recipe inputs and outputs to ItemInfo debug names when an item ID resolves, while preserving category-only inputs, workshop identifiers, durations, cooking and upgrade flags, source files, and `observed/static` evidence labels. It also emits the balance-relevant ItemInfo fields: category, rarity, stack size, equipment slot, item class, flags, and source file.

The generated catalog is stored outside the Git repository at `EmberVault_Research/balance-catalogs/static-balance-catalog-v1.json` so raw and generated data do not inflate the repository. The generated result contains 4,262 items and 2,536 recipes.

No game files, saves, runtime memory, or live settings were modified.
