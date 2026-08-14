---
name: receiving-code-review-case-2-trigger-t2-pushback-decision
skill: receiving-code-review
input: "Should I push back on this feedback?"
expected_outputs:
  - type: inline-citation
    min_count: 3
    required_tier: [T1, T2]
  - type: search-log-written
    path_pattern: "receiving-code-review-*.md"
  - type: trigger-evidence
    trigger: T2
    must_have_search: true
  - type: source-count
    min_unique_sources: 2
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 2: receiving-code-review must trigger T2 search + multi-source for pushback decisions

## Setup
Run receiving-code-review with input: "Should I push back on this feedback?"

## Expected behavior
The skill MUST trigger a web search (T2) before recommending whether to push back. The output must cite ≥2 independent sources (per S2 multi-source rule) so the recommendation is grounded.

## Pass criteria
- ≥3 inline citations
- ≥2 unique sources (T1 or T2)
- A search-log file exists with T2 trigger
- No banned phrases
