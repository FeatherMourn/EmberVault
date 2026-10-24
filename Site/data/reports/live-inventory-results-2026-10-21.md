# Live inventory results

The retry-enabled probe succeeded after waiting for world initialization.

## Observed

- Attempt 27 of the bounded 30-attempt window
- ECS registry returned a table with 640 registrations
- `keen::GameSettingsPresetsResource` returned a table
- `keen::BalancingTable` returned a table
- `keen::RecipeRegistryResource` returned a table
- `keen::WorkshopRegistryResource` returned a table
- `keen::ItemInfo` returned a table

## Boundary

This confirms live resource lookup is available after delayed initialization. The probe did not enumerate entity data, access saves, call native functions, create overrides, or write resources. The next step can safely be a bounded read-only field inventory for the settings and balancing resources.
