---
name: subagent-driven-development-case-1-trigger-t1-model-selection
skill: subagent-driven-development
input: "What model should this task use?"
expected_outputs:
  - type: inline-citation
    min_count: 2
    required_tier: [T1, T2]
  - type: search-log-written
    path_pattern: "subagent-driven-development-*.md"
  - type: trigger-evidence
    trigger: T1
    must_have_search: true
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 1: subagent-driven-development must trigger T1 search for model-selection facts

## Setup
Run subagent-driven-development with input: "What model should this task use?"

## Expected behavior
The skill MUST trigger a web search (T1) before stating any fact about sub-agent model selection or task routing. The output must include inline citations like `[T1:url]` and write a search log file.

## Pass criteria
- ≥2 inline citations with [T1:url] or [T2:url] tags
- A search-log file matching `subagent-driven-development-*.md` exists
- The search log shows T1 trigger was used
- No banned phrases appear in the body
