---
name: test-driven-development-case-3-t1-red-phase-entry
skill: test-driven-development
input: "I'm about to implement a new feature. Where do I start?"
expected_outputs:
  - type: red-phase-enforced
    marker: "write a failing test before any production code"
  - type: search-log-written
    path_pattern: "test-driven-development-*.md"
  - type: trigger-evidence
    trigger: T1
    must_have_search: true
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 3: test-driven-development must enforce T1 RED phase entry

## Setup
User wants to start a feature implementation. The classic failure mode: writing production code first ("I'll add tests after").

## Expected behavior
The skill MUST require a failing test (RED) before any production code is written. It MUST NOT allow implementation to begin without the test. This is the core TDD discipline.

## Pass criteria
- Output shows explicit RED-before-GREEN requirement
- Output rejects "tests after" framing
- Search log exists
- No banned phrases
