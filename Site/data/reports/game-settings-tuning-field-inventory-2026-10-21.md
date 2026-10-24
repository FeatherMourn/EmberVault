# GameSettingsPresetsResource field inventory

The static export contains a separate settings layer from the core `BalancingTable`. It defines minimum values, maximum values, and named presets. This is the clearest confirmed source for player-facing balance knobs, although editability still requires a separate local/private-world test.

## Confirmed settings categories

- Player health, mana, stamina, body heat, and diving-time factors
- Durability and starving-debuff toggles
- Food-buff duration and hunger thresholds
- Shroud-time, day, and night durations
- Tombstone mode and glider turbulence toggle
- Weather and fishing difficulty modes
- Mining damage, plant growth, resource-drop stack, and factory-production factors
- Perk recycling and perk-cost factors
- Combat, mining, exploration, and quest experience factors
- Random spawner and aggro-pool modes
- Enemy, boss, perception, and threat factors
- Pacify-all-enemies toggle and taming behavior mode
- Curse modifier and flame-level fog removal

The resource explicitly supplies lower and upper bounds for many numeric factors and named preset records such as Relaxed. This establishes a strong “configuration candidate” classification, distinct from the static core balancing constants.

No setting was changed, and the original game files remain read-only.
