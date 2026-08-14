---
name: writing-plans-case-3-t2-t3-step-granularity
skill: writing-plans
input: "Draft a plan to add user authentication to our app."
expected_outputs:
  - type: step-granularity-correct
    marker: "steps small enough to execute without further decomposition"
  - type: search-log-written
    path_pattern: "writing-plans-*.md"
  - type: trigger-evidence
    trigger: T1
    must_have_search: true
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 3: writing-plans must enforce T2+T3 step granularity

## Setup
User asks for a plan on a multi-week feature. Classic failure modes: 1-step plans ("add auth"), or 50-step plans with vague dependencies.

## Expected behavior
The skill MUST produce steps that are each individually completable (T2) and that have clear dependencies / ordering (T3). No hand-wavy "set up auth" steps. Each step must be small enough to ship and verifiable.

## Pass criteria
- Output shows multiple fine-grained steps
- Steps have clear acceptance criteria
- Search log exists
- No banned phrases
