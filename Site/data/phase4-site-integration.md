# Phase 4 Site Integration Audit

Phase 4 generated the canonical public index from the Phase 3 content records and connected each non-excluded record to a public destination.

## Generated indexes

- data/site-index.json â€” searchable public record index.
- data/site-category-index.json â€” category-grouped index for library pages.
- data/phase4-site-coverage.json â€” page coverage and version audit.

## Canonical destinations

- Reports and report data â†’ eports.html or individual eport-pages/ pages.
- Probes â†’ probe-library.html.
- Catalogs â†’ catalogs.html.
- Methods and project documentation â†’ methods.html.
- Mods, adapters, and loaders â†’ mods-tools.html.
- Provenance and metadata â†’ glossary.html.

## Version boundary

All indexed public records are labeled Enshrouded 1.0.0.3, source build 39026384728.

## Remaining limitation

The index is now canonical, but some categories still point several source records to a category landing page rather than dedicated detail pages. Phase 5 should generate individual pages for probes, catalogs, methods, adapters, loaders, and mod analyses where the source material warrants it.
