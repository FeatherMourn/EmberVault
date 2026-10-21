# Recipe Category Label Limitation

The Enshrouded 1.0 type registry exposes `RecipeInputCategoryResource` and
`RecipeInputCategoryDefinition` types, but the read-only EML probe returned zero
resources for `RecipeInputCategoryResource`.

The recipe registry does expose all 22 numeric category IDs and their 90
resolved item memberships. Those IDs and memberships are retained as the
reliable runtime evidence. Human-readable category labels remain unresolved;
no label is inferred from a debug name or item membership.

The next mapping slice is workshop/station data from the recipe registry and
`WorkshopRegistryResource`.
