# Broad API sweep probe

Added and installed `embervault_api_sweep_sf` as a ShroudForge runtime mod.

The probe checks the presence of documented runtime surfaces for types, ECS, native-function metadata, services, overrides, assets, settings, logging, and export. It only checks function availability and logs results. It does not enumerate world data, call native functions, read or write resources, modify ECS state, access saves, or attempt patches.

The probe is installed in the live mods folder but requires a full game launch before its log lines can be checked. A missing function is evidence about the active runtime surface, not proof that the underlying game feature is impossible.
