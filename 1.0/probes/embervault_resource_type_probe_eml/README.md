# EmberVault Resource Type Probe — Standard EML

This is the standard EML version of the resource-type probe.

- Uses the minimal EML manifest format accepted by the proven export probe.
- Reads only `game.assets.get_resource_types()`.
- Exports `embervault/resource-types-v1.tsv` through `io.export`.
- Does not use EML 2.0 bridge metadata, ShroudForge extension metadata, native
  bindings, placement, or mutation calls.

This package is staged for validation and is not yet counted as observed in the
capability matrix.
