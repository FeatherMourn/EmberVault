# XHL Area Harvest — `xhl-area-harvest`

## Short summary

XHL Area Harvest is a hybrid mod: Lua defines and verifies the supported crop contract, while a native DLL hooks the game's harvest interaction path. Harvesting one mature crop can queue nearby supported mature crops within a five-meter square area without a new hotkey.

## How it works

The Lua side declares the supported crop families, GUIDs, interaction verbs, and ECS resource types. It distinguishes one-shot mature crops using `DestroyOnLoot` from refill-style fruit and nut plants using the stock refill path. Seedlings, repot actions, and refill harvesting are deliberately excluded where the contract says they are unsupported.

The native DLL resolves the harvest call chain at runtime and expands the stock interaction into a pending event queue. Its embedded diagnostic strings describe 35 mature destroy templates, a five-meter square, a synthetic queue limit of 512, and exact queue reads rather than per-tick region queries.

## Configuration and loading

`config.txt` currently contains `enabled=true`. The native plugin also has a small configuration contract and logs whether it is disabled, invalid, incompatible, or successfully applied. The active proxy log confirms that the native DLL is loaded through the current native chain.

## Safety and limitations

- It is build-sensitive: the manifest lists validated game builds and uses runtime feature/call-chain resolution.
- The native hook can remain unchanged if feature resolution is ambiguous or incompatible.
- It does not add a new interaction key; it expands the stock harvest action.
- It excludes seedlings, repotting, and refill harvest paths by design.
- Multiplayer behavior requires separate validation because the native hook changes client interaction behavior.

## Reverse-engineering assessment

This is a good example of a hybrid architecture: Lua supplies the semantic data contract and native code performs the timing-sensitive call-chain hook. The separation makes the crop list easier to audit while keeping the actual interaction interception in native code.

## Confidence

- Lua contract and configuration: high; directly inspected.
- Native load and feature strings: high; directly observed from the DLL and proxy log.
- Exact native call sequence and memory operations: medium; requires symbols, source, or controlled debugger tracing.

