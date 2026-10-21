# Component and material key probe

The bounded read-only probe completed successfully.

- `keen::ecs::TemplateResource` reported 12,267 resources.
- `keen::RenderModel` reported 10,470 resources.
- The sampled `components` and `materials` values were opaque userdata, not enumerable Lua tables, so no inner keys were exposed.
- No entities were enumerated, writes attempted, or saves accessed.

This is an API boundary, not evidence that appearance data is absent. Further inspection needs a documented field accessor or static KFC/reflection analysis of the component and material schemas.
