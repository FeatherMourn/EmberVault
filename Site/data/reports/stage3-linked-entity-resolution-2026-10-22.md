# Stage 3 linked-entity resolution checkpoint

Date: 2026-10-22

## Current evidence

- The private fork returns a validated local-player handle.
- The live `InventorySetup` read exposes 32 linked container IDs.
- The eight-slot inventory schema is resolved from reflection data.
- The current export reports zero populated item slots and zero item-state candidates.
- The equipment-link worker is independently bounded and no longer controls the rest of the worker graph.

## Diagnostic change

The linked-inventory worker now records resolution separately from component readability:

- `resolved=true` means the linked entity handle was returned.
- `status=readable` means the expected inventory fields were read.
- `status=unavailable` means the entity was reached but the component or fields were not readable.
- `resolved=false` and `status=resolve_error` means entity resolution itself failed.

This prevents an unresolved ownership chain from being collapsed into a single ambiguous “unavailable” result.

## Gate status

Inventory ownership is still partial. No item-instance write, save edit, or persistence claim is authorized. The next
runtime export must collect the new resolution fields before Stage 3 can be promoted.
