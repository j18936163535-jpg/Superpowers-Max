---
name: body-banned
description: A skill with a clean anchor but a banned phrase in the body (should FAIL with banned-phrase in body only)
---
<SEARCH_DISCIPLINE>
FIXTURE_ANCHOR_PLACEHOLDER
</SEARCH_DISCIPLINE>

<SEARCH_GATE step="do-thing" triggers="T3">
Search for the latest guidance before doing the thing.
</SEARCH_GATE>

## Body

This body intentionally contains the banned phrase in flowing
prose, used to confirm that the banned-phrase check still fires
on the body after the anchor is excluded. The anchor (substituted
from `_shared/`) also contains the same word as a documented
example, but the audit should only flag the BODY — not the
anchor.

The current state of the framework is "目前 in early rollout".

Expected: FAIL with reason "banned-phrase" ONLY (no drift).
