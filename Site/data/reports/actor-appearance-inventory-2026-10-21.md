# Actor appearance inventory

The read-only actor appearance probe loaded successfully in a world session and exported its inventory.

## Available surfaces

- `runtime.ecs` and `runtime.ecs.get_registry` are available.
- `game.assets.get_resources_by_type` is available.
- `keen::ItemInfo`: 4,262 resources.
- `keen::RenderModel`: 10,470 resources.
- `keen::ecs::TemplateResource`: 12,267 resources.

## Not found

The guessed dedicated resource types `keen::CharacterAppearanceResource`, `keen::PlayerAppearanceResource`, and `keen::ActorAppearanceResource` are not registered. This does not prove appearance data is absent; it suggests the data is likely held in ECS components, templates, or model/attachment references.

## Safety result

No entities were enumerated, no writes or overrides were attempted, and no saves were accessed.

## Next read-only step

Search the reflected ECS type registry and relevant template/model payloads for appearance, body-scale, hair, facial-hair, material, and attachment fields. Only after a concrete field and supported ownership path are identified should editability be assessed.
