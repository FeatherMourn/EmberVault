# Stage 4 Smoke-Test Result — Worker Package 1.4.6

## Result

The corrected ShroudForge package executed and produced a fresh per-run export. The global census deadline worked: the run completed with terminal worker statuses instead of hanging indefinitely.

## Verified

- Probe version and worker graph version are 1.4.6.
- A unique per-run export and latest pointer were written.
- The export contains the run identity and stale-result rule.
- Player, inventory, equipment, item, and unsupported-domain workers all reached explicit terminal statuses.
- The global deadline classified the blocked run as `census deadline exceeded`.
- No saves or world data were accessed or written.

## Current limitation

Player context remained unavailable and the snapshot generation was unknown, so no ownership or inventory capability is promoted. This is a successful Stage 4 scheduler/export-isolation result, not a Stage 5 ownership result.

## Follow-up

Add a bounded readiness preflight so workers that depend on player context are marked `blocked` or `unavailable` before the global deadline, while independent schema and unsupported-domain workers can still complete normally.
