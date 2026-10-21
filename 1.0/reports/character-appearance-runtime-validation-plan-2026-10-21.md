# Character appearance runtime validation plan

## Read-only gate

Run the exact-schema probe in a private local world and record:

1. Whether `keen::CharacterPresetCollection` is returned by `game.assets.get_resources_by_type`.
2. Which top-level fields are readable: `presets`, `colors`, and `knowledgeUnlocks`.
3. Whether `CharacterCustomizationResource` is present as a standalone resource.
4. Whether `CharacterSetup` and `ScaleComponent` are standalone resources or only embedded in templates.

## Accessor gate

For any returned typed resource, read only known fields and record their runtime types. Do not assign values. A successful read establishes supported access, but not writability.

## Write gate

Only if a live object is identified as the local player’s authoritative appearance state, and the runtime reports guarded write support, consider one reversible private-world test. The test must use an expected-value check, a documented scalar or typed value, readback, and restoration. No process-memory access, bypass, multiplayer session, or save manipulation is permitted.

## Current status

Static schemas and payloads are verified. The exact probe is installed. No live character appearance export has yet been captured, so the write gate is not open.
