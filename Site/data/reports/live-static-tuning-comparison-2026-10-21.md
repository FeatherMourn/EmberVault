# Live/static tuning comparison

This report compares the first successful live scalar read with the 1.0 static settings and balancing inventories. It is read-only evidence; no game or save data was changed.

## Confirmed live-backed settings

| Setting | Live value | Known bounds | Status |
|---|---:|---:|---|
| Player health factor | 1.0 | 0.25–4.0 | Runtime-backed configuration candidate |
| Enemy health factor | 1.0 | Not captured in this pass | Runtime-backed; bounds still to capture |
| Factory production speed factor | 1.0 | 0.25–2.0 | Runtime-backed configuration candidate |

## Confirmed live-backed balancing values

| Field | Live value | Classification |
|---|---:|---|
| Player level cap | 50 | Static balancing constant, live-readable |
| Item level cap | 55 | Static balancing constant, live-readable |
| Flame level maximum | 20 | Static balancing constant, live-readable |
| Altar level maximum | 5 | Static balancing constant, live-readable |
| Durability loss cap | 3 | Static balancing constant, live-readable |

## What this establishes

- The runtime resource service can read both game settings and core balancing resources after world initialization.
- The three captured factors currently match their default value of 1.0.
- Player health and factory speed have explicit live bounds in the preset resource.
- Readability does not prove writability. No override or write was attempted.
- The next read-only pass should capture the remaining bounds and compare recipe/item values before any local override experiment.

## Provenance

- Live values: extended-retry scalar probe, successful on attempt 23 of 90.
- Static bounds and setting categories: `GameSettingsPresetsResource` inventory.
- Static caps: `BalancingTable` inventory and live scalar read.
