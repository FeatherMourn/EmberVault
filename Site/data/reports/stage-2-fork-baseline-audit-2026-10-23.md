# Stage 2 ShroudForge baseline and private-fork audit

Date: 2026-10-23
Fork: `H:\enshroudedresearch\shroudforge\fork\shroudforge-player-accessor`
Upstream base: ShroudForge `1.7.5`, commit `2f86315`
Fork head: `9f8d3a5`

## Result

At audit time, Stage 2 was **partially complete**. The fork foundation and
compatibility tooling were present, but operational rollback, write isolation,
and clean-worktree/reproducibility checks still needed evidence.

## Verified

- The fork has an MIT license and retains upstream history.
- The fork is 47 commits ahead of the local `1.7.5` upstream ref and has no
  local commits behind that ref.
- Client and dedicated-server profiles are stored separately.
- The current client profile for build `26082781` exactly matches the installed
  `enshrouded.exe` SHA-256 and records KFC format, layout, provenance, and
  limitations.
- Native, Rust, loader, ABI, profile, and package tooling exists.
- Package creation emits SHA-256 checksums and validates required profile and
  manifest content.
- Read-only ECS access, compatibility selection, unsupported states, and crash
  containment are represented in code and tests.
- The latest fork commits explicitly fail closed on the unsupported ownership
  layout; the unsafe ownership/equipment call is not an acceptable fallback.

## Gaps requiring closure

1. The fork worktree is dirty in world-context, ECS, and game-thread files.
   Those changes must be committed or explicitly recorded as the active patch
   set before a reproducible release can be claimed.
2. No independent restore report proves that the previous live runtime,
   loader, and executable were restored and passed a startup smoke check.
3. The current game profile contains enabled ECS/resource write layouts. That
   is upstream capability data, not permission to use it, but EmberVault needs
   an explicit fork-level deny policy or profile overlay that keeps writes
   disabled by default.
4. The fork has no clearly recorded EmberVault release manifest tying together
   fork commit, upstream base, native ABI, loader executable, runtime DLL,
   profile fingerprint, probe package, and hashes.
5. A clean package-install test must prove duplicate/stale packages are
   rejected and that the active ShroudForge package is the one whose hash was
   validated.

## Stage 2 closure checklist

- [ ] Commit or document the complete EmberVault patch set.
- [ ] Add an explicit read-only deny overlay for experimental native writes.
- [ ] Generate a release manifest with all artifact hashes and identities.
- [ ] Run offline ABI, profile, manifest, package, and crash-safety checks.
- [ ] Perform a reversible install in an isolated test root.
- [ ] Restore the previous binaries and record a successful startup smoke test.
- [ ] Update the capability matrix and promote Stage 2 only after the above
  evidence is committed.

## Boundary

This audit does not authorize another live install or restart. The next work
is offline packaging and rollback evidence; live validation remains gated until
the matching bundle and recovery path are proven.

## Closure addendum — 2026-10-23

All listed gaps are now closed. The active patch set is fingerprinted, the
deny policy and release manifest are present, the workspace suite passes, the
active binaries were restored with matching hashes, and the ShroudForge launch
smoke succeeded. See `reports/stage-2-closure-2026-10-23.md`.

