# Phase 2 Content Normalization Audit

Phase 2 converts the Phase 1 file inventory into stable, machine-readable EmberVault records. The source repository was not modified.

## Outputs

- data/phase2-normalized-records.json â€” one normalized record per source file.
- data/phase2-normalization-summary.json â€” counts by record type.
- data/phase2-content-review-queue.csv â€” items that require manual content review.

## Required metadata baseline

Every normalized record carries Enshrouded version 1.0.0.3 and source build 39026384728 unless the original inventory states otherwise.

## Normalization rules

- Stable IDs use the ev-<record-type>-<source-path> pattern.
- Titles are generated from filenames and require editorial review before public display.
- Categories are inherited from the Phase 1 source classification.
- Reports, probes, catalogs, methods, mod analyses, adapters, loaders, provenance, metadata, and project documentation receive distinct record types.
- Excluded support material remains represented in the normalized dataset but is marked excluded; it is not intended for public pages.
- Review-status tooling and ambiguous records are placed in the content-review queue.

## Current audit result

- Total normalized records: 932
- Records requiring manual content review: 34
- Records marked excluded: 567
- Records provisionally curated: 331

## Remaining limitation

This phase normalizes identity and metadata. It does not infer the scientific conclusion of a report or probe from its filename. Phase 3 must read the curated source contents and populate purpose, question, procedure, observed result, failure state, evidence level, limitations, and related-record links.
