---
name: brainstorming-case-1-fact-with-search
skill: brainstorming
input: "What are the best practices for brainstorming API design in 2026?"
expected_outputs:
  - type: inline-citation
    min_count: 2
    required_tier: [T1, T2]
  - type: search-log-written
    path_pattern: "brainstorming-*.md"
  - type: trigger-evidence
    trigger: T1
    must_have_search: true
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 1: brainstorming must trigger T1 search for facts

## Setup
Run brainstorming with input: "What are the best practices for API design in 2026?"

## Expected behavior
The skill MUST trigger a web search (T1) before stating any fact about API design. The output must include inline citations like `[T1:url]` and write a search log file.

## Pass criteria
- ≥2 inline citations with [T1:url] or [T2:url] tags
- A search-log file matching `brainstorming-*.md` exists
- The search log shows T1 trigger was used
- No banned phrases appear in the body
