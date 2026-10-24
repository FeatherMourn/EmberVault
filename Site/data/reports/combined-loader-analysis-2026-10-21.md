# Combined Loader Analysis

## Scope

This compares the clean Case A capture with the repaired Case B launch. It
reports module coexistence only; it does not infer framework initialization or
feature behavior from module presence.

## Confirmed coexistence

Both captures observed the test-copy `dinput8.dll`, `dbghelp.dll`, and
`winmm.dll` in the Enshrouded process. Both also observed the ShroudForge
runtime DLL.

This confirms that the updater-managed environment can load the three relevant
entry-point families in one process.

## Difference between captures

The clean Case A capture also observed:

```text
test-copy/shroudforge-original/dinput8.dll
```

The repaired Case B capture did not observe that forwarded target. Instead, it
observed the ShroudForge runtime and both the test-copy and system `winmm.dll`
paths. This means the updater-repaired stack is not identical to the original
Case A forwarding configuration.

## Evidence states

| Component | Case A | Repaired Case B | Interpretation |
|---|---|---|---|
| Test-copy `dinput8.dll` | Observed loaded | Observed loaded | Entry-point family active |
| ShroudForge original `dinput8.dll` | Observed loaded | Not observed | Forwarding path changed after repair |
| Test-copy `dbghelp.dll` | Observed loaded | Observed loaded | EML candidate co-resident |
| Test-copy `winmm.dll` | Observed loaded | Observed loaded | WinMM proxy candidate co-resident |
| ShroudForge runtime | Observed loaded | Observed loaded | Runtime present in both cases |
| EML framework initialization | Unverified | Unverified | No definitive EML initialization marker |
| Feature behavior | Unverified | Unverified | No feature smoke test promoted |

## Conclusions

1. The combined loader environment is real and reproducible at the module-load
   level.
2. The updater changes or restores the native loader arrangement, so the
   original Proxy-to-ShroudForge forwarding chain cannot be assumed after
   repair.
3. EML is co-resident in the process by module evidence, but its framework
   initialization remains unproven.
4. `winmm.dll` is also co-resident, but its ownership and initialization remain
   unproven.

## Next safe analysis

Compare the fresh proxy configuration and ShroudForge version/state files
before and after updater repair, then identify a framework-level initialization
marker for EML. Do not change the updater-managed files to force the old chain.
