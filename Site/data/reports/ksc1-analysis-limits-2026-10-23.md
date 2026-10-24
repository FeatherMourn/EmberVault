# KSC1 analysis limits

This document records the limits of the current read-only save analysis before
decompression or payload decoding is added.

## Established

- The inspected character copy begins with the KSC1 container marker.
- The header and bounded blob table parse successfully.
- The active copy contains 34 bounded blob records.
- Repeated `CHAR`, `FOWR`, and `COUT` tags, plus a `KNPL` tag, are present.
- The original save and the working copy remain separate; no bytes were edited.

## Not established

- A blob tag is not yet mapped to an item, inventory, equipment, perk, gem, or
  socket structure.
- A compressed-size field is not proof of a particular compression algorithm.
- A binary payload is not proof of a field layout, checksum, or serializer.
- Reflection names cannot be located by plain-text search in the current copy.
- No item-instance, level, damage, rarity, perk, gem, socket, or slot value has
  been correlated to a save offset.
- No persistence or round-trip behavior has been demonstrated.

## Prohibited conclusions at this stage

- Do not edit bytes based on offsets inferred from repetition or alignment.
- Do not infer decompression format from a successful byte-pattern guess.
- Do not treat a readable header as evidence that the payload is writable.
- Do not copy changes into the real save until a decoder, serializer, checksum
  rule, and copy-only round trip have all been validated.

## Next controlled analysis

The next tool may decompress or inspect payloads only in the working copy. It
must preserve original bytes, record algorithm and bounds evidence, reject
unknown formats, and emit a report without writing a reconstructed save.
