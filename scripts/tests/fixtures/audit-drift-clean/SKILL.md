---
name: drift-clean
description: A skill with the full shared anchor (drift-clean baseline; should PASS audit)
---
<SEARCH_DISCIPLINE>
FIXTURE_ANCHOR_PLACEHOLDER
</SEARCH_DISCIPLINE>

<SEARCH_GATE step="do-thing" triggers="T3">
Search for the latest guidance before doing the thing.
</SEARCH_GATE>

## Body

Body is clean. No banned phrases appear outside the anchor block.
The anchor (substituted at test time from `_shared/`) intentionally
contains the documented examples of phrases to avoid — the audit
must ignore the anchor and only scan this body section.

Expected: PASS (gates=1, no drift, no banned).
