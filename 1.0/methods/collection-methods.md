# EmberVault collection methods

The map is built in layers: loader capabilities, resource types, KFC schemas, records and relationships, localization, runtime observations, build diffs, and verified adapter contracts.

Every result should record its source, game build, loader version, freshness, confidence, limitations, and whether it is read-only, staged, or guarded.

Native injection and undocumented writes are not treated as supported capabilities. A capability becomes supported only after a current-build probe, readback evidence, and rollback evidence pass.
