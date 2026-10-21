# Workshop localized-name fallback map

The runtime workshop registry contains 51 records and 49 distinct numeric localization IDs. The localization bundles available in the static export are hashed manifests, so they do not provide the English strings directly.

As a usable fallback, each workshop localization ID was paired with the matched station ItemInfo debug name:

- 44 of 51 records have a matched ItemInfo station name.
- 7 records have no station item reference and therefore no static fallback name.
- Duplicate localization IDs are preserved; one label can intentionally serve multiple workshop records.

Examples of verified fallback identifiers include `Craftingstation_Workbench`, `Prop_Production_T3_Oven`, `Prop_Production_T1_HandGrinder`, `Prop_Production_T1_Charcoal_Kiln`, `Prop_Production_T1_Forge`, and `Prop_Production_T2_Smelter`.

These are debug-name fallbacks, not translations. The numeric localization IDs remain the authoritative localized-name keys until a compatible runtime localization lookup or decoded language bundle becomes available.
