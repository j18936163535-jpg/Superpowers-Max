---
name: writing-skills-case-2-trigger-t2-skill-existence
skill: writing-skills
input: "Should this skill exist or extend another?"
expected_outputs:
  - type: inline-citation
    min_count: 3
    required_tier: [T1, T2]
  - type: search-log-written
    path_pattern: "writing-skills-*.md"
  - type: trigger-evidence
    trigger: T2
    must_have_search: true
  - type: source-count
    min_unique_sources: 2
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 2: writing-skills must trigger T2 search + multi-source for skill-existence decisions

## Setup
Run writing-skills with input: "Should this skill exist or extend another?"

## Expected behavior
The skill MUST trigger a web search (T2) before recommending a new skill vs extending an existing one. The output must cite ≥2 independent sources (per S2 multi-source rule) so the decision is grounded.

## Pass criteria
- ≥3 inline citations
- ≥2 unique sources (T1 or T2)
- A search-log file exists with T2 trigger
- No banned phrases
