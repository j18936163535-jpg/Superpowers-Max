---
name: executing-plans-case-3-t2-t4-blocked-escalation
skill: executing-plans
input: "Task is stuck on a missing API. What's the protocol?"
expected_outputs:
  - type: blocked-escalation-clear
    marker: "explicit escalation path with evidence requirements"
  - type: search-log-written
    path_pattern: "executing-plans-*.md"
  - type: trigger-evidence
    trigger: T1
    must_have_search: true
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 3: executing-plans must enforce T2+T4 blocked escalation

## Setup
Task is blocked on an external dependency. The classic failure mode: silently waiting, or making up a workaround that masks the block.

## Expected behavior
The skill MUST require the worker to (T2) capture the block with evidence and (T4) escalate to the parent / human with a clear ask. The skill MUST NOT allow the worker to spin silently or fabricate a workaround.

## Pass criteria
- Output demands block evidence (logs, error, repro)
- Output demands explicit escalation, not silent waiting
- Search log exists
- No banned phrases
