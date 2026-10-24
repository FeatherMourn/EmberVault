# More Character Colors — `aldrich-more-colors`

## Short summary

This is an EML Lua mod that changes character-creation and barber color data. It unlocks hidden vanilla swatches and adds custom skin, eye, eyebrow, and hair colors. It is data-patching/exporting rather than a native DLL mod.

## Evidence inspected

- `mod.json`
- `extended.mod.json`
- `README.md`
- The installed folder contained no Lua source file; the README refers to `src/mod.lua`, which is not present in the installed copy.

## Loader and manifest

- Launcher: EML, declared in `extended.mod.json`.
- Targets: client and server.
- Declared capabilities: `patch`, `export`.
- Requires EML's `dbghelp.dll` beside the game executable.

## Reported implementation behavior

The README says the mod patches the game's character-color lists during load/export. It keeps the per-list count at 55 because the author reports that 65 causes a startup crash. Hair gradients have a separate limit of 32 total, so only nine additional hair colors are added. Hidden vanilla colors are unlocked without deleting existing entries.

## How it works

At a high level, EML starts the Lua entry point during game initialization. The mod preserves existing color entries, unlocks selected hidden entries, appends bounded custom swatches, and exports the changed data through the loader's patch mechanism. The installed package does not include the entry-point source, so the exact API calls and data types remain unconfirmed.

## Configuration and save implications

The source-level settings reportedly include `UnlockVanillaColors`, `UnlockVanillaStyles`, custom hex colors, `SkinGamma`, and `EyeGamma`. Those settings cannot be edited from the installed copy because the referenced `src/mod.lua` is absent.

Color names are save identifiers. Removing or renaming a color can make characters using it fall back to a default. Multiplayer clients reportedly need the mod to display the added colors.

## Reverse-engineering assessment

The observable design is a bounded data transformation applied by EML at startup. The important safety constraint is preserving the game's list capacities. A complete code-level reconstruction requires the original source archive or a copy that includes `src/mod.lua`; the installed package alone exposes the interface and constraints but not the transformation code.

## Confidence

- Manifest and loader facts: high; directly read from installed JSON.
- Limits, color counts, and save behavior: medium; documented by the mod author in the installed README.
- Exact patch functions and data structures: low until the source file is obtained.

