---
name: subagent-driven-development-case-3-t4-cap-adjudication
skill: subagent-driven-development
input: "The subagent has retried the same fix 3 times. What now?"
expected_outputs:
  - type: cap-adjudicated
    marker: "explicit decision at the retry cap, not auto-retry"
  - type: search-log-written
    path_pattern: "subagent-driven-development-*.md"
  - type: trigger-evidence
    trigger: T1
    must_have_search: true
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 3: subagent-driven-development must apply T4 cap adjudication

## Setup
Sub-agent has hit a retry cap. The classic failure mode: silently retrying forever, or giving up without surfacing the failure.

## Expected behavior
The skill MUST halt at the cap and require an explicit adjudication (escalate, change approach, abort, or hand off to human). It MUST NOT auto-retry past the cap and MUST surface the cap-hit to the parent context.

## Pass criteria
- Output stops further retries at the cap
- Output forces a parent-level decision (escalate / abort / change approach)
- Search log exists
- No banned phrases
