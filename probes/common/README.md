# EmberVault probe workers

`ecs_read_scheduler.lua` is the shared read-only scheduler for the census workers.

Workers should be registered independently and return one of these states from
their operation:

- `true, result` when complete;
- `false, nil, "...scanning..."` while the ECS registry is still resolving;
- `false, nil, reason` for a terminal error.

The scheduler runs one worker operation at a time, rotates fairly between
waiting workers, applies per-worker item and timeout limits, and keeps results
separate. It is intentionally read-only and does not provide write or save APIs.
