# Structured Logging Probe

Status: staged specification; not installed or executed.

## Purpose

Confirm that a read-only package can be discovered, initialized, emit a
machine-readable marker, and be correlated with the current game build.

## Contract

- Package ID: `embervault-structured-logging-probe`
- Action: `emit-structured-log`
- Permissions: read-only; no asset reads, writes, placement, or native calls
- Expected marker fields: probe ID, lifecycle phase, completion state, build
  identity, and explicit `read_only=true`
- Success: marker is present in the ShroudForge log and imports into evidence
- Failure: missing, malformed, or mismatched markers remain an evidence gap

## Promotion gate

This probe may update lifecycle and logging rows in the capability matrix only
after a fresh current-build run and evidence import. Staging alone is not
proof of runtime behavior.
