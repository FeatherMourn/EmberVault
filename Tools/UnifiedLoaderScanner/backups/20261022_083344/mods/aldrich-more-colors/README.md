# More Character Colors

EML (Enshrouded Mod Loader) mod for character creation and the barber.

- Unlocks the 25 colors the game hides until unlocked in-game (eye and hair colors).
- Adds 40 new skin tones, 40 eye colors, 40 eyebrow colors and 9 hair colors, including fantasy
  races: drow and moon elves, dryads, orcs and goblins, trolls, vampires, Warhammer-style Chaos
  tones, glowing eyes.

Result, all available from the start: skin 55, eyes 55, eyebrows 48, hair 32.

The game holds a limited number of swatches per list: 55 works, 65 crashes on start.
`MaxColorsPerList` (55) skips any colors added past that.

Only 9 new hair colors: the game holds at most 32 hair color gradients (23 are vanilla) and
crashes on start with more. The other 31 hair shades are still available as eyebrow colors.

## Install

Needs EML (`dbghelp.dll` next to `enshrouded.exe`). Install with Vortex, or copy this folder to
`Enshrouded/mods/aldrich-more-colors/`.

## Config

Edit the top of `src/mod.lua`: turn off `UnlockVanillaColors`, change the hex colors, or tune
`SkinGamma` / `EyeGamma` if a color looks different in-game than on the swatch. Bump `version` in
`mod.json` after editing so EML re-patches.

`UnlockVanillaStyles` also unlocks hidden hairstyles, beards and voices; Enshrouded 1.0 has none.

Do not rename color names: the name is the id stored in your save. If you remove the mod or a
color, characters using it fall back to a default color. In multiplayer, other players need the mod
to see your new colors.

## Changelog

- 1.1.0: 20 more skin, eye and eyebrow colors with a fantasy theme (elves, orcs, Warhammer).
  Colors per list capped at 55 (65 crashes on start).
- 1.0.2: updated for Enshrouded 1.0 and EML 0.2.0 (new character color data layout). One hair
  color less: 1.0 added a vanilla hair color.
- 1.0.1: fixed the crash on start ("No allocator set in BaseDynamicArray"): new hair colors capped
  at the game's limit of 32 gradients, and hidden colors are unlocked without removing entries.
- 1.0.0: first version.
