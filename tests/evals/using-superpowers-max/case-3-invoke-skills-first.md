---
name: using-superpowers-max-case-3-invoke-skills-first
skill: using-superpowers-max
input: "I have a feature to build. Start coding."
expected_outputs:
  - type: skill-invoked-first
    marker: "skill invoked before any action"
  - type: search-log-written
    path_pattern: "using-superpowers-max-*.md"
  - type: trigger-evidence
    trigger: T1
    must_have_search: true
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 3: using-superpowers-max must enforce invoke-skills-first

## Setup
Run using-superpowers-max on a vague "start coding" request that lacks skill context.

## Expected behavior
Before any tool use or substantive output, the skill MUST identify and invoke a relevant skill (brainstorming, writing-plans, TDD, etc.). It MUST NOT start writing code without first routing through a skill.

## Pass criteria
- Output shows explicit skill invocation before action
- Search log exists
- No banned phrases
