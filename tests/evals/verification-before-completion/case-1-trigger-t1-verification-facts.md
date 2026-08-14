---
name: verification-before-completion-case-1-trigger-t1-verification-facts
skill: verification-before-completion
input: "Did the tests pass?"
expected_outputs:
  - type: inline-citation
    min_count: 2
    required_tier: [T1, T2]
  - type: search-log-written
    path_pattern: "verification-before-completion-*.md"
  - type: trigger-evidence
    trigger: T1
    must_have_search: true
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 1: verification-before-completion must trigger T1 search for verification facts

## Setup
Run verification-before-completion with input: "Did the tests pass?"

## Expected behavior
The skill MUST trigger a web search (T1) before stating any fact about test-pass verification methodology. The output must include inline citations like `[T1:url]` and write a search log file.

## Pass criteria
- ≥2 inline citations with [T1:url] or [T2:url] tags
- A search-log file matching `verification-before-completion-*.md` exists
- The search log shows T1 trigger was used
- No banned phrases appear in the body
