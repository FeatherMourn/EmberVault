# Workshop localization join audit

## Result

The English localization payload is readable and contains workshop text, but the final key-to-text join is not yet proven. A scan found 43 of the 44 non-zero workshop name IDs somewhere in the payload's binary indexes. Those occurrences are not sufficient evidence of localization records: the surrounding bytes do not decode as the `LocaTagResource` key/text pair, and nearby values do not consistently associate with the workshop text.

## Decision

No English names were promoted from this scan. The existing 44 ItemInfo debug-name fallbacks remain the usable mapping, and the seven zero-reference workshops remain intentionally unnamed. This avoids publishing false localization matches.

## Next decoder requirement

The remaining work is to identify the bundle's entry-table layout or obtain a parser implementation for that language-bundle container. Once entries expose both the `HashKey32` key and text field, the 49 workshop IDs can be joined deterministically.

Game files were read only; the extracted payload remains outside the repository.
