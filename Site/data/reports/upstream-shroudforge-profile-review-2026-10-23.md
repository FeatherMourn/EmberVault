# Upstream ShroudForge profile review

Date: 2026-10-23

## Result

The current upstream branch `1.7.6` contains the same exact Enshrouded client profile for build `26082781` that exists in the EmberVault fork. The profile identity, executable hash, ECS read layout, owner layout, and resource layout match the private fork’s profile.

This is important because upstream documentation describes the validated ECS read path as independent from the game-thread dispatcher hook. Our current blocker may therefore be an EmberVault readiness-gate or bridge integration problem rather than missing executable profile data.

## Upstream evidence

The upstream runtime documentation states that:

- entity reads require a validated world manager and stable storage snapshot;
- the exact client profile is selected by executable identity;
- the ECS reader can use the validated local-authority scene and entity manager;
- typed ECS reads can operate without a dispatcher hook;
- the game-thread dispatcher is needed for separate execution operations, not automatically for every read;
- profile development tools exist under `dev/profiles` for executable inspection, candidate discovery, component-registry verification, and profile validation.

The upstream tree also contains:

- `dev/profiles/cli/discover_function_candidates.cpp`;
- `dev/profiles/cli/match_function_signatures.cpp`;
- `dev/profiles/cli/validate_runtime_profile.cpp`;
- live component-registry and entity-manager inspection tools;
- inventory transaction and system-descriptor inspection documentation;
- profile references to `inventory_actions`, `equipment_actions`, `default_inventory`, `inventory_setup`, and `network_player_attributes`.

## Implication for EmberVault

Before pursuing new signatures or hooks, compare the EmberVault bridge against the upstream read-only ECS implementation for the exact 26082781 profile. The priority investigation is:

1. Determine whether our `entity_context_ready` gate incorrectly requires the game-thread dispatcher for a read-only ECS snapshot.
2. Compare the upstream local-authority scene/entity-manager selection with EmberVault’s custom context path.
3. Compare the upstream `ClientPlayerInput` and `NetworkPlayerAttributes` read contracts and status handling.
4. Port only read-path logic that is compatible with the existing private fork and preserve the current write gates.
5. Run native/unit tests and an offline profile validator before any live installation.

The likely safe change is to split read readiness from execution readiness: ECS reads may proceed when the profile, owner chain, local-authority scene, entity manager, generation, and stable snapshot are valid; game-thread dispatcher readiness should remain a separate prerequisite for queued execution or writes.

## Boundaries

This review does not authorize copying unverified offsets, signatures, or write operations. The exact profile match is encouraging but not sufficient by itself; live ownership and item-instance access still require readback evidence in the current build. No live files, game data, saves, or runtime binaries were changed during this review.

Sources:

- Upstream ShroudForge repository: `https://github.com/bonsaibauer/shroudforge`
- Upstream runtime/profile guide: `docs/runtime/native-runtime-and-game-profiles.en.md`
- Upstream profile development tools: `dev/profiles/`
