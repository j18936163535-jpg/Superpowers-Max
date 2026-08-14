---
name: dispatching-parallel-agents-case-2-trigger-t2-parallel-or-sequential
skill: dispatching-parallel-agents
input: "Should these tasks run in parallel?"
expected_outputs:
  - type: inline-citation
    min_count: 3
    required_tier: [T1, T2]
  - type: search-log-written
    path_pattern: "dispatching-parallel-agents-*.md"
  - type: trigger-evidence
    trigger: T2
    must_have_search: true
  - type: source-count
    min_unique_sources: 2
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 2: dispatching-parallel-agents must trigger T2 search + multi-source for parallel-vs-sequential decisions

## Setup
Run dispatching-parallel-agents with input: "Should these tasks run in parallel?"

## Expected behavior
The skill MUST trigger a web search (T2) before recommending parallel execution. The output must cite ≥2 independent sources (per S2 multi-source rule) so the parallelism decision is grounded.

## Pass criteria
- ≥3 inline citations
- ≥2 unique sources (T1 or T2)
- A search-log file exists with T2 trigger
- No banned phrases
