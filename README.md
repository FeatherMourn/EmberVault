# EmberVault

EmberVault is a build-aware research and development project for understanding what Enshrouded modding can do. It brings together curated game-data catalogs, runtime probes, adapter contracts, compatibility evidence, and documented methods in one versioned research map.

The goal is not to claim that every discovered field is writable or that every experiment is safe. The goal is to build a reliable map of the game: what the community can observe, identify, export, configure, test, and eventually support through ShroudForge or another verified runtime boundary.

## What we are building

- **Map the game data:** resource types, schemas, fields, relationships, items, world data, localization, tuning records, and other useful indexes.
- **Understand runtime capabilities:** read-only ShroudForge probes for APIs and services present on a specific game build.
- **Develop adapters:** build-aware contracts declaring capabilities, permissions, evidence requirements, and safe fallbacks.
- **Document the path forward:** methods, limitations, compatibility changes, test results, and open questions.

## What EmberVault is not

EmberVault is not a raw copy of the game, a save-file repository, or automatic permission to modify live game state. Raw KFC exports remain local source material. A catalog entry is not proof that a value can be changed, and a successful read-only probe does not prove that a guarded write is supported.

## Current workflow

```text
Local export → Curated catalog → Read-only ShroudForge probe
→ Build-matched evidence → Adapter contract
→ Guarded test with backup, readback, and rollback
→ Documented capability or recorded limitation
```

New probes should use the ShroudForge package format by default because it provides a visible manifest, Modloader actions, and clearer runtime feedback. EML remains available when its export or data-access behavior is specifically required.

## Evidence levels

- **Static:** documentation, source inspection, manifests, or offline files.
- **Synthetic:** local simulation, generated package, or staged test.
- **Observed:** read-only probe output from a running game.
- **Verified:** reproducible current-build output with matching provenance.
- **Guarded:** a controlled operation that passed backup, permission, readback, and rollback checks.

Evidence may move upward only after the required test is completed. Older-build evidence must not be presented as current-build support.

## Repository structure

Each game snapshot has its own version folder:

```text
1.0/
  catalogs/    Curated resource, schema, item, world, and tuning indexes
  reports/     Audits, usefulness reports, and research findings
  probes/      ShroudForge-format read-only probe packages
  adapters/    Adapter diagnostics, contracts, and capability records
  methods/     Collection methods, roadmaps, and review rules
  metadata.json
```

Future snapshots use sibling folders such as `1.1/` and `1.2/`; earlier snapshots are preserved rather than overwritten.

## Versioning

Create a new snapshot when the game build, KFC export identity, ShroudForge runtime, or meaningful compatibility behavior changes. Each snapshot records the game build, runtime version, export identity, collection date, probe and adapter versions, evidence state, and limitations. Use build-to-build comparisons to identify changed resources, fields, capabilities, and adapter contracts.

## Provenance and safety rules

- Raw KFC files are not committed to this repository.
- Curated data identifies the local export or documented source it came from.
- Catalogs, reports, probes, and adapters record build context, collection date, source, confidence, and limitations.
- Static, synthetic, observed, verified, and guarded evidence remain distinct.
- Probes are read-only by default and should be tested in an isolated or backed-up profile.
- An adapter is not promoted until current-build evidence, readback, and rollback checks pass.
- Do not commit private save data, credentials, unreviewed binaries, or unrelated game files.
- Undocumented native injection or an experimental hook is not treated as supported merely because it exists in research material.

## Working with the repository

1. Export current game data locally using supported tooling.
2. Compare its identity and type inventory with the relevant snapshot metadata.
3. Update curated catalogs and reports without copying the raw export.
4. Build or update a uniquely versioned ShroudForge probe.
5. Run it in a disposable or backed-up test environment.
6. Record results and evidence before proposing an adapter.
7. Run adapter contract and build compatibility checks.
8. Use guarded operations only when backup, permission, readback, and rollback gates pass.
9. Document failures and unsupported capabilities; they are valuable map data.

## Roadmap

1. **Foundation:** metadata, provenance, versioning, catalogs, and ShroudForge packaging.
2. **Game map:** resource, field, relationship, localization, item, world, and tuning coverage.
3. **Evidence and diffs:** probe history, freshness, build fingerprints, comparisons, and diagnostics.
4. **Adapter SDK:** capabilities, permissions, contract tests, dependencies, and review candidates.
5. **Guarded operations:** backup verification, readback, rollback, transaction journals, and limited live tests.
6. **Community capability map:** build-aware findings showing what is observable, exportable, configurable, tested, or unsupported.

The long-term destination is a trustworthy map of Enshrouded modding capabilities that can evolve with the game and its modding ecosystem.
