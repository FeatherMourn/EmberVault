# Resource Type Bridge Adapter

This adapter defines the first join between the read-only EML resource-type probe and the local KFC export.

## Inputs

- resource-types-v1.tsv produced by the EML probe.
- Same-build KFC type/resource indexes supplied locally by the researcher.

## Record states

- **matched** — a documented, same-build bridge identifies one KFC candidate.
- **ambiguous** — more than one candidate remains possible.
- **unmatched** — no verified bridge is available yet.

Unmatched records are useful boundary evidence. They must not be interpreted as missing game types.

## Current observation

The first local comparison found 146 EML runtime identifiers and 146 KFC resource folders, but no direct folder-name matches. The identifiers therefore appear to use different namespaces. The next implementation should use KFC mapping metadata or a runtime-provided bridge, preserving provenance for every match.

## Safety

The adapter is offline and read-only. It does not upload raw KFC exports, modify game files, or infer writability from type metadata.