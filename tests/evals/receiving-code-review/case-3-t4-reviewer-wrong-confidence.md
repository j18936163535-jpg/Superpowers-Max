---
name: receiving-code-review-case-3-t4-reviewer-wrong-confidence
skill: receiving-code-review
input: "Reviewer says my fix is wrong. I think they misread the code."
expected_outputs:
  - type: confidence-calibrated
    marker: "evidence-based reasoning about whether reviewer is correct"
  - type: search-log-written
    path_pattern: "receiving-code-review-*.md"
  - type: trigger-evidence
    trigger: T1
    must_have_search: true
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 3: receiving-code-review must apply T4 confidence check (reviewer-is-wrong)

## Setup
User is confident the reviewer misread the code. The classic failure mode: dismissing feedback based on confidence rather than evidence.

## Expected behavior
The skill MUST NOT let confidence override evidence. It MUST require the user to verify the reviewer's claim against the code before pushing back, and require evidence (commit, line ref, test) supporting the user's view.

## Pass criteria
- Output shows calibrated confidence reasoning
- Output requests concrete code references for both sides
- Search log exists
- No banned phrases
