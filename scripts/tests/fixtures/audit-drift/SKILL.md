---
name: drift
description: A skill whose anchor is STALE relative to _shared (should exit 2 / DRIFT, not FAIL)
---
<SEARCH_DISCIPLINE>
FIXTURE_ANCHOR_PLACEHOLDER
STALE_ANCHOR_VERSION: 1
</SEARCH_DISCIPLINE>

<SEARCH_GATE step="do-thing" triggers="T3">
Search for the latest guidance before doing the thing.
</SEARCH_GATE>

## Body

Body is clean. No banned phrases appear here.
The anchor is built at test time from the *current* `_shared/` plus
one extra trailing line (`STALE_ANCHOR_VERSION: 1`). That extra line
is what makes the anchor hash diverge from `cat _shared/*.md` — the
audit must detect the drift and exit 2 (not 1).

All 4 triggers, 4 source rules, 3 failure rules, and 3 output rules
ARE present (because we substituted the real shared content), so
the only issue is drift. Status: DRIFT (not PASS, not FAIL).
