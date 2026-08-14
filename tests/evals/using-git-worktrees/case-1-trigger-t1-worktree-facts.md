---
name: using-git-worktrees-case-1-trigger-t1-worktree-facts
skill: using-git-worktrees
input: "What branch should I work in?"
expected_outputs:
  - type: inline-citation
    min_count: 2
    required_tier: [T1, T2]
  - type: search-log-written
    path_pattern: "using-git-worktrees-*.md"
  - type: trigger-evidence
    trigger: T1
    must_have_search: true
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 1: using-git-worktrees must trigger T1 search for worktree-isolation facts

## Setup
Run using-git-worktrees with input: "What branch should I work in?"

## Expected behavior
The skill MUST trigger a web search (T1) before stating any fact about git worktree patterns or branch isolation. The output must include inline citations like `[T1:url]` and write a search log file.

## Pass criteria
- ≥2 inline citations with [T1:url] or [T2:url] tags
- A search-log file matching `using-git-worktrees-*.md` exists
- The search log shows T1 trigger was used
- No banned phrases appear in the body
