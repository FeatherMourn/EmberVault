# ModLoader Proxy 1.1.0 x64

## Short summary

ModLoader Proxy is the active root chainloader used to keep one game-owned DLL entry point while loading multiple native plugins. It forwards the real system DLL exports and loads explicitly listed mod DLLs in a controlled order.

## How it is built

- `modloader-proxy.dll`: renamed to a supported root DLL name, currently `dinput8.dll`.
- `chainloader.ini`: controls forwarding, deferred loading, folder scanning, logging, and explicit load order.
- `supported_dlls.txt`: lists supported proxy names.

The proxy can forward to one other proxy through `ForwardTo`, while ordinary native plugins are loaded from the `[Load]` list. Folder loading is non-recursive and alphabetical; explicit entries load first.

## Compatibility rules

- Only one root owner should be installed in the game directory.
- Standalone loaders such as Shroudtopia, Stat Sliders, ShroudHud Standalone, or AutoLootPlus cannot simply be listed as ordinary plugins unless their proxy behavior is explicitly supported.
- The active setup forwards to the original ShroudForge loader and explicitly loads Creative, XHL plugins, and the M182 panel.
- The archive documentation warns that this is intended for single-player or private server modding and should not be used with anti-cheat or public multiplayer.

## Evidence level

**Verified from archive:** configuration format, supported proxy names, forwarding model, load order, folder behavior, and stated multiplayer limitation.

**Not verified in this audit:** compatibility with every standalone loader in the archive collection.
