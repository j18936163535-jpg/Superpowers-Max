---
name: systematic-debugging-case-3-t1-bug-interpretation
skill: systematic-debugging
input: "Production is throwing intermittent 500 errors. Is this a bug?"
expected_outputs:
  - type: interpretation-grounded
    marker: "reproducible evidence required before classifying as bug"
  - type: search-log-written
    path_pattern: "systematic-debugging-*.md"
  - type: trigger-evidence
    trigger: T1
    must_have_search: true
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 3: systematic-debugging must enforce T1 bug-interpretation discipline

## Setup
User reports a vague symptom. The classic failure mode: jumping to "it's a bug" or "it's a config issue" without reproduction.

## Expected behavior
The skill MUST require reproducible evidence (logs, steps, frequency) before classifying the symptom. It MUST NOT pick a root-cause family (network, DB, code) based on the user's framing alone.

## Pass criteria
- Output demands reproduction evidence before classification
- Output does not pre-commit to a root cause
- Search log exists
- No banned phrases
