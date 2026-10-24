# World Editor — `world-editor`

## Short summary

World Editor is a large ShroudForge Lua mod that implements blueprint capture, storage, preview, rotation, placement, and undo. It supports voxel terrain and props locally, and can transfer validated blueprint requests to a dedicated server through the shared Steam P2P service.

## How it works

The code is split into focused modules: blueprint encoding/validation, operation scheduling, history and rollback, library management, preview planning, and P2P transport. The editor uses public runtime APIs for voxel reads/writes, prop queries and operations, asset reads, cursor access, settings, logging, and export storage. Native engine access remains behind those APIs rather than using private addresses in the Lua code.

Blueprints use the `SHROUDFORGE_WORLD_BLUEPRINT_V7` format. A file can contain voxel cells plus props or props alone. It stores dimensions, grid alignment, coverage, item IDs, native template UUIDs, transforms, and the blueprint up axis. Before placement, the mod validates dimensions, cell counts, coverage, recipe availability, transforms, template identity, and grid alignment.

## Controls and workflow

- F2: show or hide the World Editor window.
- F3: rotate the active blueprint by 90 degrees.
- F4: undo the latest verified placement.
- F5: mark selection corners A and B.
- F6: cancel/reset local state or request release of a stalled remote operation.
- F7: paste at the live cursor.
- F8: capture, save, and select a blueprint.

The editor also provides a preview plan before a paste. Preview is non-destructive and reports target dimensions and counts; it does not draw a 3D ghost.

## Safety and recovery design

Placement records pre-paste voxel and prop state. Undo checks that the target has not changed since placement and refuses to overwrite unrelated edits. Failed writes trigger rollback attempts, while uncertain reads retain recovery state instead of spawning duplicates. Session changes, incomplete native scans, missing write capabilities, and stale remote operations are treated as blocked states rather than successful edits.

## Multiplayer architecture

The client sends validated SFBP V7 content through `runtime.network.send_mod`. The server authenticates requests, queues operations, executes the same native world actions, and returns ordered chunks and receipts. Entity handles never cross the network. Each client retains its own undo journal, and remote requests have queue, size, timeout, and duplicate-request limits.

## Reverse-engineering assessment

This is the most complete reference mod examined so far. It demonstrates a substantial feature built entirely above a public runtime boundary: a custom file format, UI workflow, incremental operations, defensive validation, transactional rollback, and a network protocol. It is a strong architectural model for future blueprint, batch-building, or world-editing tools.

## Confidence

- Module structure and file format: high; directly inspected and documented.
- Local capture, placement, and undo: high according to the included live evidence and README.
- Save/reload persistence, arbitrary prop scaling, and a second connected client: explicitly not fully verified.

