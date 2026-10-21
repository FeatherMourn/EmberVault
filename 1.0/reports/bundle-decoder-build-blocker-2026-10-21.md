# Localization bundle decoder build blocker

The local ShroudForge source includes an `export_kfc_resources` example that could be used as the starting point for a bundle-aware decoder. A read-only offline build was attempted, but the checkout is missing its local `kfc` crate dependency under `kfc-parser/crates/kfc`, so Cargo cannot build the exporter.

The installed KFC parser executable remains usable for filtered descriptor extraction, but it does not expose the separate localization payload referenced by `LocaTagCollectionResource`.

No game or KFC source files were modified. To continue the decoder work, restore the missing KFC crate source or provide a compatible prebuilt resource exporter, then target the English bundle described by the recovered localization manifest.
