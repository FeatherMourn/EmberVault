# Scalar read probe

Added and installed `embervault_scalar_read_sf`.

The probe waits for a ready ECS registry, then reads selected live values through documented read APIs:

- `ecs::GameSettings`: factory production speed, enemy health, and player health factors
- `GameSettingsPresetsResource`: selected minimum and maximum health and production fields
- `BalancingTable`: player and item caps, flame and altar caps, and durability loss cap

It reports field values and reflected types only. It does not create overrides, write resources, call native functions, access saves, or change gameplay. A full restart and world load are required before checking its log output.
