# EmberVault and Localization Probes

## Short summary

These folders are research instruments rather than gameplay mods. They inventory ShroudForge and EML APIs, resource types, schemas, fields, localization data, recipes, workshops, inventory candidates, and appearance surfaces. Their common purpose is to replace assumptions with exported evidence.

## Common construction pattern

Each probe has a small JSON manifest and a Lua entry point. The manifests request only `runtime` or `export` capabilities. Lua uses `pcall` around discovery calls, records an evidence state and collection status, bounds result counts or sample sizes, and exports TSV files under an `embervault` namespace or writes a one-time diagnostic to the ShroudForge log.

The probes explicitly record what they did not do: no writes, no native calls, no save access, no unbounded entity dumps, or no semantic/writable-field claim. This makes them safe reconnaissance tools and provides a clear boundary between observed structure and interpretation.

## Probe families

### API and runtime surface

- `embervault_api_capability_probe_sf`: checks whether core `game`, asset, export, and protected Lua facilities exist.
- `embervault_api_sweep_sf`: inventories runtime types, ECS, native-function listings, services, overrides, asset access, settings, logging, and export functions.
- `sf-localization-diagnostic`: confirms that a ShroudForge localization diagnostic loaded and performed no writes.

### Resource and content inventories

- `embervault-resource-types`: exports visible resource type names through EML.
- `embervault-category-definitions`: inspects recipe input category resources.
- `embervault-recipe-categories`: inventories recipe registry resources and category-related data.
- `embervault-workshops`: inventories workshop and station registry resources.
- `embervault-localization`: samples localization collection/tag resources.
- `embervault-localization-inventory`: inventories localization types, languages, and references.

### Appearance and character research

- `embervault_actor_appearance_probe_sf`: checks appearance-related resource families and candidate fields.
- `embervault_appearance_type_search_sf`: searches reflected type names for appearance-related candidates.
- `embervault_character_schema_probe_sf`: checks character preset and ECS schema fields.
- `embervault_ecs_appearance_component_probe_sf`: searches reflected ECS/template metadata for appearance terms.
- `embervault_template_field_probe_sf`: samples template and render-model fields such as hair, body, mesh, materials, and attachments.
- `embervault_component_key_probe_sf`: inventories bounded component and render-material keys.
- `embervault_appearance_write_probe_sf`: performs a guarded no-op write/readback/restore test against a preset hair field; it is not a live-player ownership test.

### Inventory and balance research

- `embervault_player_inventory_accessor_probe_sf`: performs bounded candidate ECS queries and reads selected player, equipment, and character fields.
- `embervault_inventory_ecs_probe_sf` and related inventory probes: inspect candidate inventory components and relationships without writing.
- `embervault_scalar_read_sf`: reads selected balance and settings scalars, including player health, enemy health, production speed, level caps, and durability-related fields.

## Reverse-engineering assessment

The probe suite is built as a staged evidence pipeline: discover APIs, list types, inspect schemas, test bounded reads, and only then consider a guarded no-op write. This is a sound way to map a game/mod boundary. The strongest design choices are explicit evidence labels, bounded scans, `pcall` isolation, one-time reporting, and clear declarations that no saves or writes were touched.

## Confidence

- Probe intent and safety boundaries: high; directly stated in manifests and source comments.
- Observed resource availability: dependent on the runtime log/export produced by each probe.
- Semantic meaning of candidate fields: intentionally unproven until a later controlled test.

