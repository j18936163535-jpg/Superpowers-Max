---
name: using-git-worktrees-case-2-trigger-t2-worktree-or-branch
skill: using-git-worktrees
input: "Should I use a worktree or just a branch?"
expected_outputs:
  - type: inline-citation
    min_count: 3
    required_tier: [T1, T2]
  - type: search-log-written
    path_pattern: "using-git-worktrees-*.md"
  - type: trigger-evidence
    trigger: T2
    must_have_search: true
  - type: source-count
    min_unique_sources: 2
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 2: using-git-worktrees must trigger T2 search + multi-source for worktree-vs-branch decisions

## Setup
Run using-git-worktrees with input: "Should I use a worktree or just a branch?"

## Expected behavior
The skill MUST trigger a web search (T2) before recommending a worktree-vs-branch setup. The output must cite ≥2 independent sources (per S2 multi-source rule) so the trade-off is grounded.

## Pass criteria
- ≥3 inline citations
- ≥2 unique sources (T1 or T2)
- A search-log file exists with T2 trigger
- No banned phrases
