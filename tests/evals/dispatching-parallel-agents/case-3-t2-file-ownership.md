---
name: dispatching-parallel-agents-case-3-t2-file-ownership
skill: dispatching-parallel-agents
input: "Dispatch agents to refactor 5 files at once."
expected_outputs:
  - type: file-ownership-enforced
    marker: "each agent has exclusive file ownership, no overlap"
  - type: search-log-written
    path_pattern: "dispatching-parallel-agents-*.md"
  - type: trigger-evidence
    trigger: T1
    must_have_search: true
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 3: dispatching-parallel-agents must enforce T2 file ownership

## Setup
User wants multiple agents to refactor overlapping files. The classic failure mode: parallel agents editing the same file produces merge conflicts and lost work.

## Expected behavior
The skill MUST partition files so each agent has exclusive ownership. The skill MUST refuse to dispatch agents that share a file path, and MUST require either explicit file-ownership table or sequential execution when overlap is unavoidable.

## Pass criteria
- Output shows explicit per-agent file list
- Output rejects overlapping file ownership
- Search log exists
- No banned phrases
