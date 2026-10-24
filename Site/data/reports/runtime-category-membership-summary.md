# Runtime Recipe Category Membership Summary

The read-only EML recipe-category probe ran successfully against Enshrouded
1.0 and exposed the recipe registry's `inputCategories` table.

## Result

- 22 category IDs were observed.
- 90 category-to-item membership rows were exported.
- Every membership item ID resolved to the normalized ItemInfo catalog.
- No game files or recipe data were modified.

The runtime evidence strengthens the static recipe analysis: category-only
inputs are real registry categories with concrete item memberships, not missing
ItemInfo records.

## Remaining limitation

The probe exposed numeric category IDs and their item memberships but no
human-readable category labels. Labels remain unverified and are not inferred.
