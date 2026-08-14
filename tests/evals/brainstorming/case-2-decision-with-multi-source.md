---
name: brainstorming-case-2-decision-with-multi-source
skill: brainstorming
input: "Should I use REST or GraphQL for a new project?"
expected_outputs:
  - type: inline-citation
    min_count: 3
    required_tier: [T1, T2]
  - type: search-log-written
    path_pattern: "brainstorming-*.md"
  - type: trigger-evidence
    trigger: T2
    must_have_search: true
  - type: source-count
    min_unique_sources: 2
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 2: brainstorming must trigger T2 search + multi-source for decisions

## Setup
Run brainstorming with input: "Should I use REST or GraphQL for a new project?"

## Expected behavior
The skill MUST trigger a web search (T2) before recommending an approach. The output must cite ≥2 independent sources (per S2 multi-source rule).

## Pass criteria
- ≥3 inline citations
- ≥2 unique sources (T1 or T2)
- A search-log file exists with T2 trigger
- No banned phrases
