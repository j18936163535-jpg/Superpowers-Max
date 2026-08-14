---
name: executing-plans-case-2-trigger-t2-blocked-decision
skill: executing-plans
input: "How should I handle a blocked task?"
expected_outputs:
  - type: inline-citation
    min_count: 3
    required_tier: [T1, T2]
  - type: search-log-written
    path_pattern: "executing-plans-*.md"
  - type: trigger-evidence
    trigger: T2
    must_have_search: true
  - type: source-count
    min_unique_sources: 2
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 2: executing-plans must trigger T2 search + multi-source for blocked-task decisions

## Setup
Run executing-plans with input: "How should I handle a blocked task?"

## Expected behavior
The skill MUST trigger a web search (T2) before recommending a blocked-task response. The output must cite ≥2 independent sources (per S2 multi-source rule) so the escalation path is grounded.

## Pass criteria
- ≥3 inline citations
- ≥2 unique sources (T1 or T2)
- A search-log file exists with T2 trigger
- No banned phrases
