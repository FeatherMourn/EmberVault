# Runtime DLL static inventory

## Scope

Read-only filesystem inventory of native DLLs under the active Enshrouded mods directory. No DLL was loaded, injected, executed for inspection, or modified.

## Observed module

One native module was found: `XHL-Enemy-Difficulty-Limits.dll` under the `XHL-Enemy-Difficulty-Limits` mod directory. The file has no embedded Windows version-information fields populated. The current environment does not provide `dumpbin`, so exported-symbol enumeration was not performed.

## Classification

- **Represented:** native module exists on disk.
- **Readable:** file metadata and path are readable; exported API surface is unknown.
- **Exportable:** not established.
- **Writable:** not established and not attempted.
- **Persistent:** not applicable to the DLL itself.
- **Runtime compatibility:** unknown until loader logs or documented module metadata identify its entry contract.

## Boundary

The census may use DLL metadata, source, documentation, and loader logs as evidence. It does not load arbitrary modules into the game, inject code, inspect process memory, or bypass loader or game protections.
