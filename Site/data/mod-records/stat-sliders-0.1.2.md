# Stat Sliders 0.1.2

## Short summary

Stat Sliders is a standalone native `dinput8.dll` plugin. It pattern-scans the game, hooks internal systems, and adds configurable sliders for player, combat, movement, resource, experience, and stack-related values. It is not an EML or ordinary ShroudForge Lua mod.

## How it is built

- Root `dinput8.dll`: loader and native plugin in one file.
- `Alternative_powrprof/powrprof.dll`: alternate proxy component included by the package.
- Embedded strings show internal hook names, validation checks, settings labels, and configuration parsing.
- It uses signature matching and call-site validation; failed validation disables affected functionality rather than blindly patching.

## Documented or embedded behavior

- Adds a Stat Sliders section to the game's Game settings when its UI hooks succeed.
- Supports solo-only operation by default, with a co-op mode option.
- Detects other players and can disable itself while they are present.
- Applies values when entering a world and re-applies them after session changes or respawns.
- Exposes values such as health, stamina, mana, regeneration, damage, resistances, critical stats, movement, experience, resource stacks, and mining damage.
- Dedicated-server mode uses an INI configuration and applies values to every player without a local menu.

## Why it did not load in the current setup

The archive's `dinput8.dll` is itself a root loader and expects to control the game's entry point. Placing it as a normal proxy-listed plugin does not satisfy that design, which explains why no settings section appeared. It also cannot safely replace the current working ModLoader Proxy/ShroudForge root without a separate loader profile.

## Risks and limitations

- Native signatures are version-sensitive and can disable the core or UI when the game changes.
- The mod changes gameplay and player attributes; it is not read-only.
- Co-op behavior is intentionally restricted or disabled unless explicitly enabled.
- Running more than one copy is detected and causes one copy to remain inactive.

## Evidence level

**Verified from archive:** standalone loader layout, alternate proxy component, embedded hook names, validation behavior, settings labels, solo/co-op handling, and dedicated-server behavior.

**Not verified in this audit:** successful loading through the current proxy chain or menu availability on the current installation.
