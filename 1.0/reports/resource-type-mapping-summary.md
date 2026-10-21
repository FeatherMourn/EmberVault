# Resource Type Mapping Summary

## Scope

This record covers the Enshrouded 1.0 build used by EmberVault Researcher. It
joins the read-only EML resource-type export, the local KFC 4 export, and the
current game `.cache/types.json` file.

## Identifier sources

1. EML enumerated 146 visible runtime resource-type identifiers.
2. The KFC export contains 146 resource folders and 91,812 resource files.
3. Each KFC resource payload includes `$type`, `$guid`, and `$part` metadata.
4. The current `.cache/types.json` contains the corresponding qualified type
   names and hash metadata for the active 1.0 build.

## Bridge result

The payload-level adapter matched all 146 KFC resource folders to current
`.cache/types.json` definitions:

| Result | Count |
| --- | ---: |
| Matched | 146 |
| Ambiguous | 0 |
| Unmatched | 0 |

The payload `$type` field is therefore the strongest verified static bridge
between the KFC resource folders and current in-game type names.

## Evidence and limits

- This is static same-build evidence, not proof of live EML resource access.
- It does not establish that a type is writable or safe to mutate.
- Runtime capability must still be tested with a separate read-only probe.
- The raw KFC export remains local and is not copied into this repository.

## Reproduction

Run `adapters/kfc-payload-type-bridge.ps1` with the local `.cache/types.json`,
KFC export root, and an output report path. The generated report preserves the
cache version, source paths, candidate hashes, and per-folder evidence.
