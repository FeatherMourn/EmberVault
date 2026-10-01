# EmberVault

Public catalog, knowledge base, and research archive for Enshrouded modding.

## Repository purpose

This repository is the curated content foundation for the Embervault website.
It is intentionally separate from the EnshroudedModHub runtime repository:

- `content/mods/` contains public mod records.
- `content/research/` contains build-specific research summaries.
- `content/knowledge/` contains reusable guides and explanations.
- `content/compatibility/` contains build and compatibility records.
- `schemas/` defines the shape of records before they are published.

The Control Center can publish a sanitized `embervault-catalog.json` snapshot
for this repository. Validate an incoming snapshot before review with:

```text
python tools/verify_catalog.py embervault-catalog.json
```

The public snapshot contract is documented in
`schemas/public-catalog.schema.json`; private profiles, save backups, logs,
and research evidence text must never be included in it.

The website should preserve the distinction between verified, experimental,
research-only, blocked, and unsupported work. A successful offline build or
runtime registration does not automatically prove visible in-game behavior.

## Related repositories

- Runtime and Control Center: https://github.com/FeatherMourn/EnshroudedModHub
- Public content source: https://github.com/FeatherMourn/EmberVault

## License

MIT. See [LICENSE](LICENSE).
