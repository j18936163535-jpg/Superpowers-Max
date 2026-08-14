---
name: systematic-debugging-case-2-trigger-t2-workaround-decision
skill: systematic-debugging
input: "Should I add a workaround or fix the root?"
expected_outputs:
  - type: inline-citation
    min_count: 3
    required_tier: [T1, T2]
  - type: search-log-written
    path_pattern: "systematic-debugging-*.md"
  - type: trigger-evidence
    trigger: T2
    must_have_search: true
  - type: source-count
    min_unique_sources: 2
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 2: systematic-debugging must trigger T2 search + multi-source for workaround-vs-root decisions

## Setup
Run systematic-debugging with input: "Should I add a workaround or fix the root?"

## Expected behavior
The skill MUST trigger a web search (T2) before recommending a workaround-vs-root-fix path. The output must cite ≥2 independent sources (per S2 multi-source rule) so the trade-off is grounded.

## Pass criteria
- ≥3 inline citations
- ≥2 unique sources (T1 or T2)
- A search-log file exists with T2 trigger
- No banned phrases
