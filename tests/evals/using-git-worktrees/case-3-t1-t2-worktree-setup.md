---
name: using-git-worktrees-case-3-t1-t2-worktree-setup
skill: using-git-worktrees
input: "Set up an isolated workspace for a new feature."
expected_outputs:
  - type: worktree-setup-correct
    marker: "concrete git worktree commands and isolation verification"
  - type: search-log-written
    path_pattern: "using-git-worktrees-*.md"
  - type: trigger-evidence
    trigger: T1
    must_have_search: true
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 3: using-git-worktrees must enforce T1+T2 worktree setup

## Setup
User asks for an isolated workspace. The classic failure mode: switching branches in-place (loses uncommitted work) or copying the directory (no shared history).

## Expected behavior
The skill MUST propose a `git worktree add` (or equivalent) flow, with explicit branch selection, base commit, and a verification step that the new worktree is on the correct branch and isolated from the main checkout.

## Pass criteria
- Output shows explicit `git worktree add` (or equivalent) commands
- Output verifies isolation (branch, base, separate working tree)
- Search log exists
- No banned phrases
