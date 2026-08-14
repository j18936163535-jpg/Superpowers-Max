---
name: finishing-a-development-branch-case-2-trigger-t2-discard-decision
skill: finishing-a-development-branch
input: "Should I discard this work?"
expected_outputs:
  - type: inline-citation
    min_count: 3
    required_tier: [T1, T2]
  - type: search-log-written
    path_pattern: "finishing-a-development-branch-*.md"
  - type: trigger-evidence
    trigger: T2
    must_have_search: true
  - type: source-count
    min_unique_sources: 2
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 2: finishing-a-development-branch must trigger T2 search + multi-source for discard decisions

## Setup
Run finishing-a-development-branch with input: "Should I discard this work?"

## Expected behavior
The skill MUST trigger a web search (T2) before recommending discarding work. The output must cite ≥2 independent sources (per S2 multi-source rule) so the discard rationale is grounded.

## Pass criteria
- ≥3 inline citations
- ≥2 unique sources (T1 or T2)
- A search-log file exists with T2 trigger
- No banned phrases
