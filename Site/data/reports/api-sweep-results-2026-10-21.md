# Broad API sweep results

The read-only ShroudForge API sweep ran successfully in a loaded world.

## API surfaces present

- Runtime root, type registry, ECS registry, and component lookup
- Runtime function metadata and operation listing
- Runtime services and override-scope factory
- Game asset resource lookup and content lookup
- ShroudForge settings and logging
- Export function

## Important distinction

The sweep checked API presence only. It did not call native functions, enumerate world data, read or write resources, create overrides, alter ECS state, or access saves.

The runtime backend remains unavailable for operational work: it reports an unresolved registry/layout, no registered storage types, unavailable game-thread ownership, and an unavailable resource service. Therefore the result is:

- API surface: present
- Runtime initialization: incomplete
- Resource reads: unavailable
- Resource writes: unavailable and not attempted
- Native calls: not attempted
- World data reads: not requested

This is the strongest current evidence that the Lua-facing API exists while the build-specific native backend/profile is not yet matched.
