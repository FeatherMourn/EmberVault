# Localization bundle decode result

The installed KFC parser was used in read-only filtered mode against the current Enshrouded 1.0 archive, requesting only `LocaTagResource` and `LocaTagCollectionResource` data.

The extraction returned the single localization collection descriptor. It records the English bundle size and hash metadata, but the English string payload is not stored in the descriptor or exposed as a KFC resource record. The available static export likewise contains no plain-text localization table.

## Result

- Filtered extraction completed without modifying the game archive.
- The localization collection descriptor was recovered.
- No English string payload or name-ID-to-text table was recovered.
- Workshop numeric localization IDs and ItemInfo debug-name fallbacks remain valid.

The remaining decode target is the hashed English bundle referenced by the descriptor. It requires a bundle-aware reader or a compatible runtime localization API; the current KFC parser cannot expose that payload through its filtered resource extraction.
