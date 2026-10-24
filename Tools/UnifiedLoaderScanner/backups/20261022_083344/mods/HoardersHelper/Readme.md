# Hoarder's Helper - Recipe Tooltips

## Description
Hoarder's Helper adds a list of crafting recipes directly into each item's description tooltip, so you instantly know if an item is useful for crafting or safe to discard! No more guessing or hoarding useless loot.

---

## Main Features
* **Dynamic Item Descriptions:** Appends a clean, bulleted list of all recipes an item is used in directly inside its tooltip.
* **Ingredient & Category Support:** Works for both specific item ingredients and general material categories.
* **Multi-language Support:** Automatically displays recipe information in your game's active language.
* **QoL Hoarder Helper:** Helps you quickly clean up your inventory by identifying valuable crafting materials at a glance.

---

## Requirements
* **Enshrouded Mod Loader** (Ensure you have the latest version installed to run Lua/Asset mods).
* No other external mods or dependencies are required.

---

## Installation Instructions
1. Download the mod archive (`.zip` or `.7z`).
2. Extract the contents of the package directly into your **main game directory** (where the game executable is located).
3. Launch the game through the Mod Loader and enjoy!

---

## Uninstallation
To uninstall the mod, simply go to your game's `mods/` directory and delete the mod files.

---

## Known Issues
* **Generated `.dat` Files:** 
  Due to how the game engine handles virtual file allocations when saving localized data, the mod generates additional cached `.dat` files upon launch (typically starting from `enshrouded_032.dat` onwards). 
  * **Is it safe?** Yes, these files are completely safe to ignore or delete at any time.
  * **Note:** If you delete them, they will simply be recreated the next time you launch the game with the mod enabled.

---

## 💬 Shoutout & Collaboration
The game supports HTML formatting inside the UI, but I haven't been able to render icons or create a dedicated custom UI element for it yet. 

If you're a developer or modder interested in taking this concept further, adding visual icons, or improving the UI integration, **feel free to reach out to me!** I'm more than happy to collaborate.