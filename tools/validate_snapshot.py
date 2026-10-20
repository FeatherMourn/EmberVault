from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SNAPSHOT = ROOT / "1.0"
metadata = json.loads((SNAPSHOT / "metadata.json").read_text(encoding="utf-8"))
registry = json.loads((SNAPSHOT / "registry.json").read_text(encoding="utf-8"))
assert metadata["map_version"] == "1.0"
assert registry["game_build"] == metadata["game_build"]
assert not (ROOT / "1.1").exists(), "Create 1.1 only after the game build changes."
for probe in registry["probes"]:
    package = SNAPSHOT / "probes" / probe["id"]
    assert (package / "mod.json").is_file(), probe["id"]
    assert (package / "extended.mod.json").is_file(), probe["id"]
    assert (package / "src" / "mod.lua").is_file(), probe["id"]
print(f"Validated snapshot 1.0: {len(registry['probes'])} probes and {len(registry['adapters'])} adapters.")
