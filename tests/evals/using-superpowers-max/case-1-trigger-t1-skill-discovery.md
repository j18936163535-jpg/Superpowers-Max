---
name: using-superpowers-max-case-1-trigger-t1-skill-discovery
skill: using-superpowers-max
input: "What skills should I use for this task?"
expected_outputs:
  - type: inline-citation
    min_count: 2
    required_tier: [T1, T2]
  - type: search-log-written
    path_pattern: "using-superpowers-max-*.md"
  - type: trigger-evidence
    trigger: T1
    must_have_search: true
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 1: using-superpowers-max must trigger T1 search for skill discovery facts

## Setup
Run using-superpowers-max with input: "What skills should I use for this task?"

## Expected behavior
The skill MUST trigger a web search (T1) before claiming which skills exist or how they should be used. The output must include inline citations like `[T1:url]` and write a search log file.

## Pass criteria
- ≥2 inline citations with [T1:url] or [T2:url] tags
- A search-log file matching `using-superpowers-max-*.md` exists
- The search log shows T1 trigger was used
- No banned phrases appear in the body
