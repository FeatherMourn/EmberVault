# More Character Colors 1.1.0

## Short summary

More Character Colors is an EML/Lua pregame data patch. It unlocks hidden vanilla colors and adds skin, eye, eyebrow, and hair swatches without a native DLL or runtime hook.

## How it is built

- `mod.json`: declares patch/export capabilities and version 1.1.0.
- `src/mod.lua`: edits character customization and barber data before the game starts.
- Requires EML's `dbghelp.dll` beside the game executable.
- Uses stable named IDs so saved characters can retain their selected colors.

## Documented limits and safety logic

- Skin and eye lists are capped at 55 entries; the README states that 65 can crash at startup.
- Hair gradients are capped at 32 total entries.
- The Lua file includes gamma settings and a reference hair preset for visual calibration.
- Removing or renaming a color can make characters using it fall back to a default.
- Other players need the mod to see the added colors in multiplayer.

## Version 1.1.0 changes

The archive adds another fantasy-themed set of colors and retains the 1.0 layout and allocator-limit safeguards. It is a newer and more complete package than the earlier documented copy.

## Loader compatibility

This is an EML package rather than a native proxy DLL. It should be installed under the EML/ShroudForge mod directory with the existing EML runtime, not added to the proxy's native DLL list.

## Evidence level

**Verified from archive:** manifest, Lua source, EML requirement, feature list, data limits, save-ID behavior, multiplayer note, and version history.

**Not verified in this audit:** live character-creation behavior on the current installation.
