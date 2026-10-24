# Localization bundle table decode

## Status

The matching KFC parser revision now builds and reads the English localization content through the KFC content table. The game files were read only; no game file was modified or repacked.

## Evidence

- The English payload was extracted at its declared size of 1,732,416 bytes.
- The payload contains readable localization text rather than only a manifest.
- Workshop-related strings were found, including `Workbench`, `Hand Grinder`, `Charcoal Kiln`, `Forge`, `Smelter`, `Alchemy`, and `Tanning`.
- The parser source defines the expected `LocaTagResource` shape: hash-key ID, text, arguments, and generic argument count.

## Remaining work

The payload is a table-backed binary bundle, so raw string occurrence is not enough to prove a localization-key mapping. The next decoder step is to parse each table entry into its hash-key ID and text, then join those IDs to the 49 workshop localization IDs already cataloged.

## Provenance and limits

The extracted bundle remains outside the Git repository in the Researcher workspace because it is generated game data. Only compact reports and derived mappings belong in the repository. Any workshop name will be marked verified only after its key-to-text table record is decoded; string proximity alone is not treated as proof.
