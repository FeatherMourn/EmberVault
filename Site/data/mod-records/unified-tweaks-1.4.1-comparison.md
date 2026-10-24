# Unified Tweaks 1.4.1 comparison

## Short summary

The research archive contains Unified Tweaks 1.4.1, while the active game folder currently contains 1.4.0. The newer archive is a compatibility/feature revision, not just a version-number change. It specifically updates spell cast-time and mana-cost handling for the 1.3.1 data layout and expands related impact/UI processing.

## Observed changes

- Manifest version changes from 1.4.0 to 1.4.1.
- The description explicitly mentions fixed spell cast/mana UI and impact handling.
- The Lua source grows from roughly 3,402 lines to roughly 3,464 lines.
- New logic collects duration-valued impact entries, scales matching normal-valued entries, adjusts UI duration and mana values, and applies matching changes to impact arrays.
- The newer source also contains additional guarded component/interaction insertion paths and warning/reporting behavior.

## Compatibility assessment

The newer archive should be treated as a separate update candidate. It was not installed during this audit. Because the active copy already produces some compatibility warnings on the current build, the update should be backed up and tested as one controlled replacement rather than merged line-by-line.

## Reverse-engineering significance

This update illustrates how a mod author adapts to a changed asset layout: instead of scaling one assumed field, it correlates values by `valueFormat` and matching duration/mana values across UI and impact data. That reduces the chance of fixing one display path while leaving the gameplay path unchanged.

