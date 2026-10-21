# Workshop to ItemInfo reference join

The static workshop registry was joined to the normalized ItemInfo catalog by each workshop's `itemRef` object reference.

- 51 workshop records inspected.
- 44 nonzero workshop item references present.
- All 44 nonzero references matched an ItemInfo record and therefore have a stable debug name.
- 7 records intentionally use the zero object reference and remain unmatched; these are the same non-item or hidden workshop records already marked by the registry metadata.

This provides human-readable static station identifiers without relying on localization strings. The join is same-build research evidence, read-only, and does not modify game or KFC files.
