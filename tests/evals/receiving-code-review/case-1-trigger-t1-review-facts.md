---
name: receiving-code-review-case-1-trigger-t1-review-facts
skill: receiving-code-review
input: "How should I address this comment?"
expected_outputs:
  - type: inline-citation
    min_count: 2
    required_tier: [T1, T2]
  - type: search-log-written
    path_pattern: "receiving-code-review-*.md"
  - type: trigger-evidence
    trigger: T1
    must_have_search: true
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 1: receiving-code-review must trigger T1 search for review-handling facts

## Setup
Run receiving-code-review with input: "How should I address this comment?"

## Expected behavior
The skill MUST trigger a web search (T1) before stating any fact about code-review handling. The output must include inline citations like `[T1:url]` and write a search log file.

## Pass criteria
- ≥2 inline citations with [T1:url] or [T2:url] tags
- A search-log file matching `receiving-code-review-*.md` exists
- The search log shows T1 trigger was used
- No banned phrases appear in the body
