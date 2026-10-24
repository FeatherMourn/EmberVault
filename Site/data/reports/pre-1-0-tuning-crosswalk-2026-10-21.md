# Pre-1.0 tuning crosswalk appendix

Older research is used here as a lead source only. Every current mapping must be revalidated against Enshrouded 1.0.

| Historical area | Current 1.0 correspondence | Reuse value | Current status |
|---|---|---|---|
| Reflected `GameSettings` model and presets | `GameSettingsPresetsResource` with min/max values and named presets | Field-family and authority clues | 1.0 static correspondence confirmed; runtime mutation unresolved |
| Settings/admin action research | Current settings fields and ShroudForge runtime settings APIs | Helps distinguish configuration from native mutation | Historical boundary retained; no 1.0 write claim |
| KFC/reference extraction workflows | Current KFC export, cache metadata, and normalized catalogs | Provenance, unresolved-reference, and version-gating patterns | Reused for 1.0 adapters |
| Runtime probing and hook-safety records | Current ShroudForge capability and resource-service checks | Failure-closed probe design and evidence vocabulary | Reused; current resource service remains unavailable |
| Building and placement research | Current workshop, building, recipe, and ItemInfo resources | Candidate field names and relationship patterns | Requires direct 1.0 validation |
| Entity and inventory research | Current ItemInfo, attribute, and registry resources | Helps locate stat and ownership families | No current runtime claim yet |

## Reuse rule

Historical results may suggest a type, field family, adapter shape, or failed approach. They do not promote a current field to `observed`, `configurable`, or `writable` status. Current 1.0 evidence must come from the local KFC/cache export, a current runtime observation, or a documented current-build API contract.

## Current priority

The strongest cross-version correspondence is the settings layer: older research identified a reflected settings model and the current export contains explicit settings presets and bounds. The remaining question is the current runtime authority and safe readback path, not whether the settings data exists.
