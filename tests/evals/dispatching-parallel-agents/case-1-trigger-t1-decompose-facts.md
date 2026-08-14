---
name: dispatching-parallel-agents-case-1-trigger-t1-decompose-facts
skill: dispatching-parallel-agents
input: "How should I decompose this work?"
expected_outputs:
  - type: inline-citation
    min_count: 2
    required_tier: [T1, T2]
  - type: search-log-written
    path_pattern: "dispatching-parallel-agents-*.md"
  - type: trigger-evidence
    trigger: T1
    must_have_search: true
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 1: dispatching-parallel-agents must trigger T1 search for task-decomposition facts

## Setup
Run dispatching-parallel-agents with input: "How should I decompose this work?"

## Expected behavior
The skill MUST trigger a web search (T1) before stating any fact about parallel-agent task decomposition. The output must include inline citations like `[T1:url]` and write a search log file.

## Pass criteria
- ≥2 inline citations with [T1:url] or [T2:url] tags
- A search-log file matching `dispatching-parallel-agents-*.md` exists
- The search log shows T1 trigger was used
- No banned phrases appear in the body
