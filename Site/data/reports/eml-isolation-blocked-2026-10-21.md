# EML Isolation Limitation

## Confirmed result

An EML-only Case B run cannot currently be isolated in the available
ShroudForge installation. The Shroud Forge updater restores the loader stack
before the game reaches the main menu, including `dinput8.dll`, `dbghelp.dll`,
and `winmm.dll`.

## Evidence

- The initial Case B staging disabled the proxy and `winmm.dll` in the test
  copy.
- The updater subsequently restored active copies of the loader DLLs.
- Passive capture after repair observed all three test-copy entry points in the
  same process.

## Interpretation

This is an environment limitation, not evidence that EML cannot run. A clean
EML-only comparison is blocked because the updater enforces the combined
ShroudForge loader state before launch.

## Test-plan change

Future tests will treat the combined Proxy/ShroudForge/EML environment as the
supported target. EML isolation remains explicitly blocked and will not be
forced by bypassing or suppressing the updater.
