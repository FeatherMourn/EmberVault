# ShroudForge Compatibility Adapter Plan

## Current targets

### M182 Client

- Proxy log shows `M182_Panel.dll` is loaded.
- The optional bridge log says the bridge is disabled because its opt-in marker is absent.
- Next action: inspect the bridge's documented marker/configuration requirement and enable only that component, without changing the root loader.
- Current decision: bridge marker disabled after testing; M182 remains parked because the bridge conflicts with the active root `dbghelp.dll`.

### ShroudHud

- ShroudHud does not appear in the current proxy load entries.
- The standalone archive owns `dinput8.dll`; it cannot simply replace ShroudForge's root.
- Next action: locate or verify the ModLoader-edition build and confirm its expected load order and deferred-loading requirement.

### Stat Sliders

- Stat Sliders is also a standalone root loader and was previously removed from the active chain because it did not load as a normal proxy child.
- Its DLL contains its own proxy behavior, signature validation, solo/co-op checks, and settings UI hooks.
- Next action: determine whether the available build supports proxy-child loading. If not, create an isolated client profile using a client-imported root name, without disturbing the working ShroudForge profile.
- Test result: isolated Stat Sliders profile successfully displayed the Stat Sliders section in the game settings. The mod initializes in its own profile; ShroudForge is intentionally not active during this test.

### AutoLootPlus

- AutoLootPlus 1.1.3 expects a root `dinput8.dll` and EML's `dbghelp.dll` according to its bundled README.
- It is not currently active in the ShroudForge profile, so its failure must first be classified as a load-path, dependency, or configuration issue.
- The archive documents F8 for its menu and F9 for its toggle, but those controls will not appear if the native component never initializes.
- Next action: inspect the current proxy log and EML files for an AutoLootPlus load attempt. If the build supports child loading, add it as a validated plugin; otherwise keep it in an isolated profile.

## Rules

- Keep the working ShroudForge profile backed up and unchanged.
- Investigate one target at a time.
- Do not rename or replace root DLLs as an experiment in the active profile.
- Use logs to distinguish “not loaded,” “loaded but disabled,” and “loaded but failed validation.”
- Restore the known-good backup before switching targets if a test affects the game root.
