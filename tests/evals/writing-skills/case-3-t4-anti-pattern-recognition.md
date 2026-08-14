---
name: writing-skills-case-3-t4-anti-pattern-recognition
skill: writing-skills
input: "Review this skill draft: 'Just use your best judgment for any task.'"
expected_outputs:
  - type: anti-pattern-flagged
    marker: "vague instructions, missing triggers, missing frontmatter flagged"
  - type: search-log-written
    path_pattern: "writing-skills-*.md"
  - type: trigger-evidence
    trigger: T1
    must_have_search: true
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 3: writing-skills must apply T4 anti-pattern recognition

## Setup
User submits a vague skill draft. The classic failure mode: rubber-stamping a skill that lacks triggers, frontmatter, or concrete instructions.

## Expected behavior
The skill MUST (T4) identify anti-patterns in the draft: missing frontmatter, vague "use your judgment" instructions, no trigger conditions, no failure modes. It MUST reject the draft and require a concrete revision.

## Pass criteria
- Output flags specific anti-patterns
- Output rejects vague / judgment-only instructions
- Search log exists
- No banned phrases
