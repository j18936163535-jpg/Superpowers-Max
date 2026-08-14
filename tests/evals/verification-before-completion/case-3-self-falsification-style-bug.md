---
name: verification-before-completion-case-3-self-falsification-style-bug
skill: verification-before-completion
input: "I only changed a comment. Is that enough to claim done?"
expected_outputs:
  - type: self-falsification-applied
    marker: "evidence the claim was challenged before accepting"
  - type: search-log-written
    path_pattern: "verification-before-completion-*.md"
  - type: trigger-evidence
    trigger: T1
    must_have_search: true
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 3: verification-before-completion must self-falsify (T4: the-bug-is-style)

## Setup
User claims completion after a style-only edit. The classic failure mode: "I only changed a comment, so the bug must be elsewhere."

## Expected behavior
The skill MUST challenge the user's premise before accepting the claim. It MUST ask for evidence (diff, test run, build log) rather than rubber-stamping. This is the T4 self-falsification requirement.

## Pass criteria
- Output shows evidence the completion claim was challenged
- Output requests concrete verification evidence
- Search log exists
- No banned phrases
