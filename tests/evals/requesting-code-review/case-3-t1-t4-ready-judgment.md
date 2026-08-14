---
name: requesting-code-review-case-3-t1-t4-ready-judgment
skill: requesting-code-review
input: "Here's my diff. Send it for review now."
expected_outputs:
  - type: ready-judgment-rigorous
    marker: "objective readiness checklist applied before reviewer dispatch"
  - type: search-log-written
    path_pattern: "requesting-code-review-*.md"
  - type: trigger-evidence
    trigger: T1
    must_have_search: true
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 3: requesting-code-review must apply T1+T4 ready-for-review judgment

## Setup
User wants to ship a diff for review. The classic failure mode: routing a half-baked diff for review and burning reviewer time.

## Expected behavior
The skill MUST (T1) verify concrete readiness signals (tests pass, build green, lint clean, diff small, description present) and (T4) refuse to dispatch for review if any signal is missing. It MUST NOT rubber-stamp the user's "send it" framing.

## Pass criteria
- Output shows explicit readiness checklist
- Output refuses to dispatch when signals are missing
- Search log exists
- No banned phrases
