# Appearance no-op write result

The guarded private-world write probe completed successfully.

- Target: `CharacterPresetCollection.presets[1].hair`.
- Original hair ID: zero.
- Write attempt: accepted.
- Readback: matched the original value.
- Restoration: accepted and returned the original value.
- Entities enumerated: no.
- Saves accessed: no.

This proves that the supported typed-resource accessor can accept a guarded write on a character preset hair field. It does not prove that the live player entity owns this preset object or that changing a nonzero hair, beard, or scale value would update the visible player. Those remain separate field-ownership and effect questions.
