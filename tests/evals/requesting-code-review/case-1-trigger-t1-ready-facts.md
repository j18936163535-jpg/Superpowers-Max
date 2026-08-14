---
name: requesting-code-review-case-1-trigger-t1-ready-facts
skill: requesting-code-review
input: "Is this code ready for review?"
expected_outputs:
  - type: inline-citation
    min_count: 2
    required_tier: [T1, T2]
  - type: search-log-written
    path_pattern: "requesting-code-review-*.md"
  - type: trigger-evidence
    trigger: T1
    must_have_search: true
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 1: requesting-code-review must trigger T1 search for review-readiness facts

## Setup
Run requesting-code-review with input: "Is this code ready for review?"

## Expected behavior
The skill MUST trigger a web search (T1) before stating any fact about review-readiness criteria. The output must include inline citations like `[T1:url]` and write a search log file.

## Pass criteria
- ≥2 inline citations with [T1:url] or [T2:url] tags
- A search-log file matching `requesting-code-review-*.md` exists
- The search log shows T1 trigger was used
- No banned phrases appear in the body
