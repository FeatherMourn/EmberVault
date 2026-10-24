# SF Unlimited Flight — `sf-unlimited-flight`

## Short summary

SF Unlimited Flight is a ShroudForge Lua runtime mod that changes the original glider stamina and movement inputs. It exposes unlimited flying plus turn, forward, lift, and descent speed multipliers through a small settings group.

## How it works

The mod queries the authoritative player entity and determines whether that player is actively using a glider. It then resolves the active glider's `ItemInfo` resource and applies reversible changes to the original glider fields. Glider item data is shared by users of the same glider type, so the mod requires an authoritative player before applying the shared resource changes.

Unlimited flight sets the original glider stamina-depletion input to zero. The four speed controls multiply the original `ItemInfo` values for yaw speed, forward acceleration, longitudinal air resistance, and vertical air resistance. The source correctly treats the resistance fields as drag coefficients, so higher values do not necessarily mean faster movement.

The upward-tilt feature is more involved: it reads player input, actor input, transform, and gravity, measures the update interval, and applies a guarded pitch-rate override. The code refuses to act when pitch-speed controls are unavailable or the orientation/gravity data is invalid.

## Safety and restoration

Like SF Survival, it uses runtime override managers, tracks the last owned values, restores disabled settings, resets state when the world session changes, and reports waiting or write-failed conditions instead of forcing uncertain writes.

## Reverse-engineering assessment

This is a useful example of a runtime mod that combines per-player ECS attributes with shared resource data. It demonstrates why a mod must distinguish entity-local state from shared `ItemInfo` state and why active-resource validation is necessary before writing.

## Confidence

- Manifest and source behavior: high; directly inspected.
- Resource paths and control flow: high; directly shown in source.
- Actual flight feel and multiplayer behavior: medium; requires live offline testing with the matching runtime build.

