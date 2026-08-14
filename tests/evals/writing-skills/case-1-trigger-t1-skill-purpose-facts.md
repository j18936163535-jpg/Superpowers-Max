---
name: writing-skills-case-1-trigger-t1-skill-purpose-facts
skill: writing-skills
input: "What should this skill do?"
expected_outputs:
  - type: inline-citation
    min_count: 2
    required_tier: [T1, T2]
  - type: search-log-written
    path_pattern: "writing-skills-*.md"
  - type: trigger-evidence
    trigger: T1
    must_have_search: true
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 1: writing-skills must trigger T1 search for skill-purpose facts

## Setup
Run writing-skills with input: "What should this skill do?"

## Expected behavior
The skill MUST trigger a web search (T1) before stating any fact about skill design, scope, or frontmatter structure. The output must include inline citations like `[T1:url]` and write a search log file.

## Pass criteria
- ≥2 inline citations with [T1:url] or [T2:url] tags
- A search-log file matching `writing-skills-*.md` exists
- The search log shows T1 trigger was used
- No banned phrases appear in the body
