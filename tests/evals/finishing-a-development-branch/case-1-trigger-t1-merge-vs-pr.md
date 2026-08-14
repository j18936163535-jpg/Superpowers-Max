---
name: finishing-a-development-branch-case-1-trigger-t1-merge-vs-pr
skill: finishing-a-development-branch
input: "Should I merge or open a PR?"
expected_outputs:
  - type: inline-citation
    min_count: 2
    required_tier: [T1, T2]
  - type: search-log-written
    path_pattern: "finishing-a-development-branch-*.md"
  - type: trigger-evidence
    trigger: T1
    must_have_search: true
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 1: finishing-a-development-branch must trigger T1 search for merge-vs-PR facts

## Setup
Run finishing-a-development-branch with input: "Should I merge or open a PR?"

## Expected behavior
The skill MUST trigger a web search (T1) before stating any fact about merge vs pull-request workflow. The output must include inline citations like `[T1:url]` and write a search log file.

## Pass criteria
- ≥2 inline citations with [T1:url] or [T2:url] tags
- A search-log file matching `finishing-a-development-branch-*.md` exists
- The search log shows T1 trigger was used
- No banned phrases appear in the body
