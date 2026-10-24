# Live inventory probe

Added and installed `embervault_live_inventory_sf`.

The probe performs a bounded read-only runtime inventory of the reflected type list, ECS registry summary, and loaded-resource lookup for `GameSettingsPresetsResource`, `BalancingTable`, `RecipeRegistryResource`, `WorkshopRegistryResource`, and `ItemInfo`.

It does not enumerate entities, access saves, call native functions, write resources, create overrides, or change gameplay. Results are written to the ShroudForge log so they remain usable even when the export service is unavailable.
