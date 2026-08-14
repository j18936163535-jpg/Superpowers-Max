---
name: systematic-debugging-case-1-trigger-t1-root-cause-facts
skill: systematic-debugging
input: "What is the root cause?"
expected_outputs:
  - type: inline-citation
    min_count: 2
    required_tier: [T1, T2]
  - type: search-log-written
    path_pattern: "systematic-debugging-*.md"
  - type: trigger-evidence
    trigger: T1
    must_have_search: true
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 1: systematic-debugging must trigger T1 search for root-cause facts

## Setup
Run systematic-debugging with input: "What is the root cause?"

## Expected behavior
The skill MUST trigger a web search (T1) before stating any fact about debugging methodology or root-cause analysis. The output must include inline citations like `[T1:url]` and write a search log file.

## Pass criteria
- ≥2 inline citations with [T1:url] or [T2:url] tags
- A search-log file matching `systematic-debugging-*.md` exists
- The search log shows T1 trigger was used
- No banned phrases appear in the body
