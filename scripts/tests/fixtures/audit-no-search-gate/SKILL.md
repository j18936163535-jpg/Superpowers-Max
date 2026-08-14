---
name: no-search-gate-skill
description: A test skill with full anchor but no search-gate blocks
---
<SEARCH_DISCIPLINE>
FIXTURE_ANCHOR_PLACEHOLDER
</SEARCH_DISCIPLINE>

## Body

This skill has the full discipline anchor block but is missing
the per-step search-gate blocks. The audit (check #6) should fail
it with reason "gates=0".
