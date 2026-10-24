# Stage 1 coverage matrix

| Domain | Primary artifact | Evidence state | Main limitation |
|---|---|---|---|
| Reflection/type index | `catalogs/kfc-type-index.json` | observed-static | type names/hashes; field metadata is not universal |
| KFC mappings | `catalogs/kfc-mapping-v1.json` | observed-static | unresolved records remain research-only |
| Inventory/equipment/items | inventory field map and capability catalog | observed-static | live ownership is Stage 5; payload mappings remain incomplete |
| Perks/gems/slots | inventory/equipment catalog | observed-static | readable instance and persistence evidence not established |
| Recipes/workshops/resources | recipe, world-resource, and tuning catalogs | observed-static | localization and runtime service access are separate claims |
| Localization | `catalogs/localization-audit.json` | partial-observed-static | identifiers and hashes exist; plain strings unresolved |
| Appearance | character appearance catalog and reflection reports | observed-static | does not prove live ownership or writability |
| Attributes/buffs/progression | tuning/progression catalog | observed-static | static representation only |
| Loot/pickup | loot/pickup census | observed-static | runtime service/ownership remains unproven |
| Building/voxel | building/voxel static census | observed-static | live voxel/no-build queries remain unproven |
| Save-copy/KSC1 | KSC1 reports and parser notes | observed-static | payload encoding and field correlation incomplete |
| External corroboration | Embervale Toolkit deep dive | corroborating-static | no proof of live item-instance access |

Promotion rule: no row advances beyond static evidence without a reproducible
source, build identity, bounded test, and explicit runtime or save-copy result.

