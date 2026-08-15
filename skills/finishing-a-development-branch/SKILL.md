---
name: finishing-a-development-branch
description: Use when implementation is complete, all tests pass, and you need to decide how to integrate the work; enforces web search discipline at the merge-vs-PR decision, the discard-work confirmation, and the cleanup step, so each integration decision reflects current 2026 best practice (integration-option criteria, destructive-action confirmation shape, worktree-cleanup boundaries) rather than stale training data Search discipline is MANDATORY: see <MANDATORY_PREAMBLE> at top of this skill before any response.
---

<MANDATORY_PREAMBLE>
# Mandatory Search-Discipline Preamble (superpowers-max v1.0.0-max)

> **This preamble is BINDING. It is not advisory. It applies to every action
> you take in this skill, before any other instruction below.**

You are operating under the **superpowers-max** regime. The hard rule:

> **Every fact you state must come from a search you performed in this session.
> Every decision must be backed by a search for current best practices.
> Every self-confident assertion must be verified against a search.**

"Based on my training data" is **not** a substitute for search. Your training
data is stale, confabulated, and one-sided. If you are tempted to write it,
search instead.

## T1. Search before every fact (HARD-GATE)

Before stating any of the following, **call `web_search` first**:
- API behavior, library usage, configuration, version compatibility
- Performance claims, benchmarks, latency numbers
- Data points, statistics, "X% of users do Y"
- Security advice, vulnerability status, CVE details
- Best practices, recommended patterns, "the standard way"
- Any specific version number, release date, or deprecation claim
- Any quoted text attributed to an external source

**Exempt**: file paths, line numbers, and content visible in the current
project's repository (read directly with file tools, not searched).

## T2. Search before every decision (HARD-GATE)

Before recommending any of the following, **call `web_search` first**:
- A library, framework, or tool choice
- An architectural approach or pattern
- A testing strategy
- A refactor plan that touches shared code
- A "this is safe to do" assurance

**Reason**: training-data "best practices" lag reality by 6-24 months. By the
time you confidently recommend X, the community may have moved to Y.

## T3. Search at step entry (HARD-GATE)

Before starting any of the following skill steps, **call `web_search` first**:
- Phase 1 of any skill that has phases
- "Now we will look at X" / "Next, let's examine Y" transitions
- Any step that requires understanding current state of an external system

**Reason**: the skill's steps are written assuming the world is in a known
state. That state may have changed.

## T4. Search before every self-confident assertion (HARD-GATE)

Before writing any of the following phrases, **call `web_search` first**:
- "The bug is X" / "The cause is Y"
- "This works because Z" / "The right way is W"
- "X is broken due to Y"
- "We should use X here"
- "This is the correct approach"
- Any sentence that ends with conviction and no citation

**Reason**: this is the most common failure mode. You feel sure, so you skip
the search. The whole point of the discipline is to break that pattern.

## Banned phrases (HARD-FAIL if you write one without prior search in this session)

The following phrases are immediate red flags that you have skipped a search:

- "based on my training"
- "as I recall" / "from what I recall"
- "from what I know"
- "generally speaking" / "in general"
- "I believe" / "I think" (for factual claims)
- "typically" / "usually" / "often" (for best practices)
- "in my experience"
- "the standard approach is"
- "this is well-known" / "this is well established"
- "according to the docs" (without citing a specific URL you just fetched)

If you catch yourself about to write one of these, **STOP** and search.

## Failure modes (HARD-GATE)

When search returns a problematic result, you must follow one of these:

- **FM1 — Empty results**: Say "I could not find X" and ask the user for
  direction. **Do not invent** an answer.
- **FM2 — Partial results**: Label the answer with `[UNVERIFIED-AT:<date>:<source-url>]`
  and explicitly mark what is missing.
- **FM3 — Conflicting sources**: Present the conflict (each source with its
  URL and date), and **ask the user to choose** before proceeding.

## Citation format (HARD-GATE)

Every fact you state must be tagged with one of:

- `[T1:url]` — verified by a single source at the time of search
- `[T1:url1,T1:url2]` — verified by multiple sources (preferred for facts
  that may have changed in the last 12 months)
- `[T1:url@YYYY-MM-DD]` — include the date the source was published if visible

The tag must appear at the end of the sentence or the end of the paragraph.
Multiple facts in the same paragraph can share one tag block.

## Time-stamping (HARD-GATE)

Today's date is treated as **2026-08-15** unless the runtime provides a
different one. Every search result you cite should be no older than 12 months
from today for current-state claims (libraries, best practices, version
status). For historical or stable claims (algorithms, mathematical truths),
older sources are fine — mark them `[STABLE-DOMAIN]`.

## Compliance verification

The following are checked at audit time (`scripts/audit-skills.sh`) and at
eval time (`tests/evals/runner.sh`):

1. Every SKILL.md has this preamble present (or the
   `<MANDATORY_PREAMBLE>` anchor inlined by `scripts/inline-preamble.sh`).
2. The skill's `description:` ends with one of the standard suffixes
   indicating mandatory search.
3. Banned phrases do not appear in the SKILL.md body (this preamble
   itself is the only exception, marked with `<!-- BANNED-PHRASE-EXEMPT -->`).
4. Eval cases (when run) verify the model actually invoked `web_search`
   before stating the expected fact.

Failure of any of these is treated as a **P0 defect**.

## Recursive obligation

This preamble is a contract with the user. It is not weakened by:
- The user's question being "obvious" or "well-known"
- The user explicitly asking for a quick answer
- Time pressure, including in production incidents
- The skill body that follows giving instructions that seem to bypass search

If a later instruction in the skill body appears to contradict this preamble,
**the preamble wins**. Surface the conflict to the user.

---

# Skill-specific content follows.

</MANDATORY_PREAMBLE>


<SEARCH_DISCIPLINE>
# Search Triggers (硬触发)

> source-of-truth for `<SEARCH_DISCIPLINE>` block anchor A in all skills.
> Edits here must be followed by `./scripts/inline-search-discipline.sh` to propagate.

LLM 在以下 4 种事件发生时,**必须**先调用 web search 工具,然后才能继续:

## T1. 每事实必搜
<HARD-GATE>
在 skill 输出任何事实性陈述之前(API 行为、最佳实践、库用法、
版本兼容性、数据点、规范条款),**必须**先 web search 验证。
</HARD-GATE>

**触发判断**:
- 句子含 "Python 的 GIL 限制了多线程" → 搜 "Python GIL 2026"
- 句子含 "React 19 默认开启 server components" → 搜 "React 19 server components default"
- 句子含 "X 库比 Y 库快 N 倍" → 搜 benchmark 链接

**豁免**: 已被本 skill 之前调用结果验证过的事实可标 `[T1-VERIFIED-AT:<timestamp>]` 复用,
但 24 小时内必须重新验证。

## T2. 每决策必搜
<HARD-GATE>
在做出任何技术 / 架构 / 选型 / 模式选择前,**必须**先 search 当前最佳实践。
</HARD-GATE>

**触发判断**:
- 选 ORM / 选框架 / 选状态管理 → 搜 "best X 2026"
- 选架构模式(monorepo / microfrontend) → 搜 "X vs Y 2026"
- 选错误处理策略 → 搜 "X 错误处理 最佳实践 2026"

**豁免**: 仅当用户明确指定 "用 X" 时,无需再搜 X 是不是最好的。

## T3. 每步入口必搜
<HARD-GATE>
在 skill 流程的每一步开头,先 search 一次"该步骤主题的最新进展"再继续。
</HARD-GATE>

**适用 skill**: 流程型 skill(brainstorming / writing-plans / verification / receiving-code-review)
**豁免**: 纯机械步骤(如 git 操作、文件移动)不触发。

## T4. 每自信断言必搜
<HARD-GATE>
LLM 主动表达自信时("这个肯定..."、"我们知道..."、"明显..."、
"应该是..."、"一般来说...")**必须**先 search 来证伪自己。
</HARD-GATE>

**反幻觉**: 这是最锐的一条。LLM 最容易在"自信断言"上栽。
即使是"我刚 verify 过的事实"也要在 24h 后重新验证。
# Source Quality Rules (源选择硬规则)

> source-of-truth for `<SEARCH_DISCIPLINE>` block anchor A in all skills.

## S1. 金字塔分级

| 等级 | 类型 | 例 | 使用规则 |
|---|---|---|---|
| T1 权威 | 官方文档 / RFC / 同行评审论文 / 政府数据 | python.org, rfc-editor.org, DOI | 直接采用,无需交叉 |
| T2 知名 | 知名博客 / SO 高赞 / 行业头部公司工程博客 | kubernetes.io/blog, eng.uber.com, SO score>100 | 需 ≥1 个 T1 背书,或 ≥2 个 T2 独立 |
| T3 普通 | 论坛 / 个人博客 / AI 生成 / 营销文 | medium 个人, reddit 普通帖 | 仅作 hint,不作为依据 |

## S2. 多源交叉为硬规则
<HARD-GATE>
任何非平凡事实,必须 ≥2 独立源确认。单一源不能下定论。
</HARD-GATE>
"独立" = 不同作者 / 不同组织 / 不同时间。
单一来源(无论多权威)只能作为"候选",不能作为"定论"。

## S3. 类型广(跨域验证)
<HARD-GATE>
广范围 ≠ 数量广,要类型广: 官方 + 社区 + 学术 + 实际使用者反馈。
</HARD-GATE>
"X 库好" 需搜: 官方 + 社区评价 + benchmark + 实际用户 issue 反馈。
避免单一视角偏差(只看官方 = 营销; 只看社区 = 偏见)。

## S4. 时效性硬要求
<HARD-GATE>
依赖时间的主题,必须包含年份 / 月份 / 显式日期。
禁用: "目前"、"现在"、"现在主流"、"近期"、"通常"。
强制: "2026 年 8 月"、"截至 2026-Q2"、"2025 年 12 月发布"。
</HARD-GATE>
原因: 训练数据天然会过期,模糊时间词会掩盖时效。
# Output Format (呈现硬规则)

> source-of-truth for `<SEARCH_DISCIPLINE>` block anchor A in all skills.

## OF1. 内联引用(每次输出必须)
每个事实 / 决策 / 结论后,必须立即附 source label:

- 简单事实:`[T1:python.org/rst/...]` 或 `[T2:so.com/q/123, eng.uber.com/...]`
- 决策结论:`[DECISION:基于 T1+T2 交叉,选 X]`
- 自验证后:`[T1-VERIFIED-AT:2026-08-15T05:00:00Z]`
- 失败/冲突:`[UNVERIFIED:原因]` / `[CONFLICT:T1说X,T2说Y]`

## OF2. 结构化搜索日志(每个 skill invocation 写一份)
路径: `.superpowers-max/search-log/<skill>-<YYYY-MM-DDTHH-MM-SS>.md`

格式(强制):
```markdown
# Search Log: <skill> @ <timestamp>
session_id: <id>
skill: <skill-name>
step: <step-name>

## Queries
1. <query-1>
   - results: <N>
   - sources: [T1:url1, T2:url2]
   - used: yes/no
   - reason: <why used or skipped>

2. <query-2>
   ...

## Decisions Made
- D1: <decision>
  basis: [T1:url1, T2:url2]
  confidence: high/medium/low

## Failures
- F1: <what failed>
  fallback: <what we did instead>

## Conflicts
- C1: T1 says X, T2 says Y
  presented: yes (per failure rule C)
```

## OF3. 日志位置与保留
- 路径: `.superpowers-max/search-log/`
- 保留: 30 天(自动清理,可用 `scripts/cleanup-logs.sh`)
- 上传: 默认不上传(本地)。如要分享可手工 `git add`。
# Failure Handling (失败/冲突硬规则)

> source-of-truth for `<SEARCH_DISCIPLINE>` block anchor A in all skills.

## FM1. 多通道 fallback
<HARD-GATE>
web_search 失败 → firecrawl → MCP 学术 / 专业数据源 → 仍失败才标 [UNVERIFIED]。
不能因一个渠道死了就放弃。
</HARD-GATE>

fallback 顺序(可配置,默认如下):
1. web_search (内置)
2. firecrawl (高级抓取,需配置)
3. MCP 学术 / 金融 / 医学(专业数据源)
4. 标 [UNVERIFIED],记录于 search log

## FM2. 降级 + 显式标注
<HARD-GATE>
全部通道失败时,标 [UNVERIFIED] + 原因,可继续推进,但事后可被审查。
</HARD-GATE>

```
[UNVERIFIED:query="X", tried=web+firecrawl+mcp, reason=all_failed_or_empty]
基于训练数据,我的回答是 Y。但未能在搜索中验证。
请用户审查。
```

## FM3. 源冲突必须呈现
<HARD-GATE>
多源冲突时,LLM 必须呈现冲突各方观点,不许静默选边。
</HARD-GATE>

```
[CONFLICT:topic="X"]
- T1 (official): <观点 A>
- T2 (community): <观点 B>
我的判断: <基于 X / Y / Z 选择 A / B / 不选>
但你应知道存在 B。
```

把判断权交回用户。

</SEARCH_DISCIPLINE>

# Finishing a Development Branch

## Overview

**Core principle:** Verify tests → Detect environment → Present options → Execute choice → Clean up.

**Announce at start:** "I'm using the finishing-a-development-branch skill to complete this work."

## Step 1: Verify Tests

Run the project's full test suite (`npm test` / `cargo test` / `pytest` / `go test ./...`).

**If tests fail**, report the failures and stop — the menu comes after a green suite:

```
Tests failing (<N> failures). Must fix before completing:

[Show failures]
```

**If tests pass:** continue to Step 2.

## Step 2: Detect Environment

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
# Capture now, while still inside the workspace — Step 5 changes directory
# before cleanup (Step 6) needs this value
WORKTREE_PATH=$(git rev-parse --show-toplevel)
```

This determines which menu to show and how cleanup works:

| State | Menu | Cleanup |
|-------|------|---------|
| `GIT_DIR == GIT_COMMON` (normal repo) | Standard 3 options | No worktree to clean up |
| `GIT_DIR != GIT_COMMON`, named branch | Standard 3 options | Provenance-based (see Step 6) |
| `GIT_DIR != GIT_COMMON`, detached HEAD | Reduced 2 options (no merge) | Externally managed — leave in place |

## Step 3: Determine Base Branch

The base branch is whatever this work forked from — usually named in the
plan, the conversation, or the branch's upstream. If it is not already
known, ask: "This branch split from <your best guess> - is that correct?"
Confirm before merging: merging into the wrong base is expensive to undo.

## Step 4: Present Options

<SEARCH_GATE step="merge-vs-pr-decision" triggers="T2">
Before presenting the integration menu, you MUST:
1. T2: Web search "merge vs pull request criteria 2026" and "when to merge locally vs create PR 2026" to confirm the upstream's 3-option menu (Merge / PR / Keep) is still the current 2026 consensus for the integration-decision surface. The shape is stable; the *criteria* shift. A 2024 reference may have treated "merge locally is fine for solo work, PR for team work" as sufficient; a 2026 reference may have tightened the criteria to include: team-convention check (does the project have an explicit "always PR" or "direct-merge-to-main" policy?), change-risk profile (small doc fix → direct merge; large refactor → PR required; security-touching change → PR + review from security owner), CI integration (does the project rely on CI checks that only run on PRs — e.g., required status checks that gate merge?), and review requirement (does the project require code review for all changes — and if so, the "merge locally" option is structurally unavailable, and presenting it without a T2 check is misleading). The LLM must verify the current 2026 integration-option criteria, not apply 2022 defaults to a 2026 menu. Cite at least one [T2:url] (engineering org blog / framework docs / current 2026 integration-decision guidance).
2. T2: For the specific change being integrated, search the current 2026 best practice for the *kind* of integration recommendation. The upstream rule "Wait for their answer; the integration decision is theirs" is a hand-off rule; the 2026 specifics include: for documentation-only changes (no production code touched → direct merge is the 2026 default in most codebases; PR is optional), for production-code changes with no breaking API shift (merge locally is acceptable if team convention allows; PR for review if convention requires), for breaking-API / schema changes (PR + explicit migration-plan section in the PR body is the 2026 default; direct merge is rarely acceptable), and for security-sensitive changes (PR + security-owner review is the 2026 default; direct merge is structurally excluded). The LLM is most likely to present the menu verbatim and wait — that's correct for the decision itself, but if the human partner asks "which would you recommend?", the LLM must be able to answer with the current 2026 kind-specific criteria, not a 2022 default like "always PR for safety". The 2026 case studies calibrate the bar. Cite at least one [T2:url] (community / engineering blog / current 2026 case study) for the kind-specific integration recommendation.
3. T2: For the "merge queue" / "draft PR" / "squash merge" / "rebase merge" sub-choices (which may or may not be present in the 2026 menu), search the current 2026 best practice for the merge-strategy surface. The upstream's menu does not enumerate these; the 2026 specifics include: a check on whether the project uses a merge queue (GitHub merge queue, GitLab merge train) — if so, "Option 2: Push and Create PR" should produce a draft PR that the queue will promote, not a ready-to-merge PR; a check on whether the project enforces squash-merge / rebase-merge / merge-commit (this is a project-config decision, not an LLM decision); and a check on whether the LLM is presenting a "PR" that won't be auto-merged because the project's branch-protection rules block it. The LLM is most likely to push the branch and call the forge's default PR-creation endpoint without checking the project's merge strategy. The 2026 case studies calibrate the bar. Cite at least one [T2:url] (current framework docs / current 2026 merge-strategy guidance for the forge in use).
4. Output: log the queries + the integration-option criteria used + the kind-specific recommendation + the merge-strategy check to `.superpowers-max/search-log/finishing-a-development-branch-<ts>.md` per OF2. The audit trail must show the menu was informed by current 2026 criteria, not defaulted to "present the 3-option menu verbatim" from training data.
</SEARCH_GATE>

**Normal repo and named-branch worktree — present exactly these 3 options:**

```
Implementation complete. What would you like to do?

1. Merge back to <base-branch> locally
2. Push and create a Pull Request
3. Keep the branch as-is (I'll handle it later)

Which option?
```

**Detached HEAD — present exactly these 2 options:**

```
Implementation complete. You're on a detached HEAD (externally managed workspace).

1. Push as new branch and create a Pull Request
2. Keep as-is (I'll handle it later)

Which option?
```

Present the menu exactly as written — concise, with every option coming
from the list above. Discarding the work happens only in response to your
human partner explicitly asking for it (see "If your human partner asks to
discard the work" below). Wait for their answer; the integration decision
is theirs.

## Step 5: Execute Choice

### Option 1: Merge Locally

```bash
# Get main repo root for CWD safety
MAIN_ROOT=$(git -C "$(git rev-parse --git-common-dir)/.." rev-parse --show-toplevel)
cd "$MAIN_ROOT"

# Merge first — verify success before removing anything
git checkout <base-branch>
git pull
git merge <feature-branch>

# Verify tests on merged result
<test command>
```

If tests fail on the merged result: stop, leave the worktree and branch in
place, and investigate — nothing has been pushed, so the merge is local
and recoverable.

Once the merged result is green: clean up the worktree (Step 6), then
delete the branch:

```bash
git branch -d <feature-branch>
```

### Option 2: Push and Create PR

```bash
git push -u origin <feature-branch>
# From a detached HEAD, name the new branch on the remote:
# git push origin HEAD:refs/heads/<new-branch>
```

Then create the pull/merge request against <base-branch> with the forge's
tooling — its CLI if one is available, or the creation URL most forges
print when you push — following the repo's PR template and conventions if
present, and report the URL to your human partner.

Keep the worktree — your human partner iterates on PR feedback there.

### Option 3: Keep As-Is

Report: "Keeping branch <name>. Worktree preserved at <path>."

### If your human partner asks to discard the work

<SEARCH_GATE step="discard-confirmation" triggers="T2,T4">
Before presenting the destructive-action confirmation prompt, you MUST:
1. T2: Web search "destructive git action confirmation 2026" and "branch force delete confirmation best practice 2026" to confirm the upstream's "Type 'discard' to confirm" rule is still the current 2026 consensus for the destructive-action confirmation surface. The shape is stable; the *confirmation surface* shifts. A 2024 reference may have treated "list what will be deleted, wait for the exact word" as sufficient; a 2026 reference may have tightened the surface to include: explicit-timeout check (does the confirmation expire after N hours? a 2026 reference may add "if you don't confirm within 24h, the work is preserved automatically"), scope re-statement (does the surface re-state what stays vs. what goes — e.g., "this discards the commits on this branch; the remote-tracking ref is unaffected; the worktree path is removed"), recovery-window check (does the 2026 best practice include a "you can recover the commits from the reflog for N days" note?), and audit-trail check (does the surface log the discard event with the confirmation word + timestamp + which worktree + which branch?). The LLM must verify the current 2026 destructive-action confirmation surface, not apply 2022 defaults to a 2026 destructive action. Cite at least one [T2:url] (engineering org blog / framework docs / current 2026 destructive-action guidance).
2. T2: For the specific kind of work being discarded, search the current 2026 best practice for the *kind* of confirmation. The upstream rule "Confirm first ... Wait for that exact confirmation" is a high-level statement; the 2026 specifics include: for branch-only discard (no uncommitted work — the discard affects only committed history; the confirmation may be lighter), for branch + uncommitted-changes discard (the discard affects both committed and uncommitted — the confirmation must list both, with the uncommitted changes explicitly noted because they have no recovery path), for branch + unpushed-commits discard (the discard affects commits that exist nowhere except the local branch — the confirmation must note "these commits are not on any remote; once deleted, recovery requires reflog access within N days"), and for branch + force-pushed-after-rejection discard (the discard affects commits that may have been on the remote before a force-push overwrote them — the confirmation must note the force-push history and the recovery path through reflog on the remote). The LLM is most likely to present the confirmation verbatim from the upstream template. The 2026 case studies calibrate the bar. Cite at least one [T2:url] (community / engineering blog / current 2026 case study) for the kind-specific confirmation surface.
3. T4: The "they obviously want this gone" reflex is a confidence assertion. Before presenting the confirmation prompt (or, worse, executing the discard), search the current 2026 evidence on the *base rate* of "user said get rid of it but actually wanted something else" (e.g., "what fraction of agent-executed discards in 2026 were reverts requested by the user?", "what's the cost of an unconfirmed discard vs. an over-cautious keep?", "what's the LLM's training-data bias on destructive-action confirmation?"). The LLM's training data defaults to "user said discard, so I should help them discard fast" — a heuristic that destroys work the human partner could have recovered in minutes with one more clarifying question. The current 2026 evidence on destructive-action base rates is the calibration: the LLM must verify the "they want this gone" classification with evidence (not just "they said it once"), and must present the confirmation prompt even when the human partner's tone suggests certainty. If the evidence surfaces that "they're frustrated" is not a reliable signal for "they want destructive action", the LLM must surface as [CONFLICT] and apply the upstream's "Wait for that exact confirmation" rule with extra diligence, not skip it because of perceived urgency.
4. Output: log the queries + the destructive-action confirmation surface used + the kind-specific confirmation shape + the base-rate check + the confirmation decision to `.superpowers-max/search-log/finishing-a-development-branch-<ts>.md` per OF2. The audit trail must show the confirmation was informed by current 2026 destructive-action criteria, not defaulted to "they said discard, so discard" from training data.
</SEARCH_GATE>

This path exists only as a response to an explicit request to throw the
work away. Confirm first:

```
This will permanently delete:
- Branch <name>
- All commits: <commit-list>
- Worktree at <path>

Type 'discard' to confirm.
```

Wait for that exact confirmation. When it arrives:

```bash
MAIN_ROOT=$(git -C "$(git rev-parse --git-common-dir)/.." rev-parse --show-toplevel)
cd "$MAIN_ROOT"
```

Then clean up the worktree (Step 6) and force-delete the branch:

```bash
git branch -D <feature-branch>
```

## Step 6: Cleanup Workspace

<SEARCH_GATE step="cleanup-workspace" triggers="T2">
Before running any cleanup command, you MUST:
1. T2: Web search "git worktree cleanup best practice 2026" and "git worktree remove behavior 2026" to confirm the upstream's "If WORKTREE_PATH is under .worktrees/ or worktrees/ ... git worktree remove" rule is still the current 2026 consensus for the worktree-cleanup surface. The shape is stable; the *cleanup surface* shifts. A 2024 reference may have treated `git worktree remove <path>` + `git worktree prune` as the canonical cleanup; a 2026 reference may have tightened the surface to include: a `git worktree lock` check (does the worktree have an active lock file that must be released first? a stale lock can block `git worktree remove` in git 2.40+), a `git worktree move` check (did the worktree's path change since the worktree was created? if so, the upstream's captured `WORKTREE_PATH` may be stale, and a re-check is needed before `git worktree remove`), a sparse-worktree check (git 2.42+ supports sparse-checkout worktrees — does the current 2026 best practice treat them differently from full worktrees on cleanup?), and a `git worktree repair` check (does the worktree have a corrupt `.git` file that must be repaired before removal? `git worktree remove` on a corrupt worktree can leave the main repo in an inconsistent state). The LLM must verify the current 2026 worktree-cleanup surface, not apply 2022 defaults to a 2026 git worktree. Cite at least one [T2:url] (git-scm.com docs / current 2026 git release notes / current 2026 worktree-management guidance).
2. T2: For the specific worktree being cleaned up, search the current 2026 best practice for the *kind* of cleanup. The upstream rule "If WORKTREE_PATH is under .worktrees/ or worktrees/ ... we own cleanup" is a high-level statement; the 2026 specifics include: for Superpowers-created worktrees under `.worktrees/` (the upstream's path — `git worktree remove` is correct, and the LLM owns the cleanup), for worktrees created by the host environment (the LLM must NOT run `git worktree remove` — the host owns the cleanup, and a platform-provided exit tool may be the right action), for worktrees created by an external tool (e.g., a CI tool's ephemeral worktree, a third-party plugin's worktree — the LLM must NOT touch them, even if the path looks like `.worktrees/` or `worktrees/`), and for worktrees with linked worktrees (git 2.40+ supports linked worktrees with a shared `.git` — the cleanup may be different). The LLM is most likely to run `git worktree remove` on any worktree whose path matches the upstream's pattern. The 2026 case studies calibrate the bar. Cite at least one [T2:url] (community / engineering blog / current 2026 case study) for the kind-specific cleanup.
3. T2: For the "host environment owns this workspace" case, search the current 2026 best practice for the host-cleanup handoff. The upstream rule "If your platform provides a workspace-exit tool, use it" is a high-level statement; the 2026 specifics include: a check for a platform-provided exit hook (some 2026 platforms run cleanup on workspace-close; running `git worktree remove` *and* the platform's exit tool can double-delete or race), a check for workspace-state preservation (some 2026 platforms preserve the workspace for re-entry; removing the worktree would lose the resume point), a check for CI-vs-local distinction (a CI workspace is ephemeral and doesn't need the "host owns it" rule; the cleanup is always LLM-owned), and a check for the "externally managed workspace" case from Step 2 (the upstream already classified it — the LLM must respect the Step 2 classification, not re-derive it during Step 6). The LLM is most likely to either over-clean (run `git worktree remove` on a host-owned workspace) or under-clean (skip the platform's exit tool when available). The 2026 case studies calibrate the bar. Cite at least one [T2:url] (current platform docs / current 2026 host-cleanup guidance).
4. Output: log the queries + the worktree-cleanup surface used + the kind-specific cleanup decision + the host-cleanup handoff check to `.superpowers-max/search-log/finishing-a-development-branch-<ts>.md` per OF2. The audit trail must show the cleanup was informed by current 2026 worktree-management criteria, not defaulted to "git worktree remove on path match" from training data.
</SEARCH_GATE>

**Runs for Option 1 and confirmed discards.** Options 2 and 3 always
preserve the worktree. Both callers have already changed directory to the
main repo root — worktree removal must run from outside the worktree —
and use the `GIT_DIR`/`GIT_COMMON`/`WORKTREE_PATH` values captured in
Step 2, from before that directory change.

**If `GIT_DIR == GIT_COMMON`:** Normal repo, no worktree to clean up. Done.

**If `WORKTREE_PATH` is under `.worktrees/` or `worktrees/`:** Superpowers
created this worktree — we own cleanup:

```bash
git worktree remove "$WORKTREE_PATH"
git worktree prune  # Self-healing: clean up any stale registrations
```

**Otherwise:** The host environment owns this workspace — leave it in
place. If your platform provides a workspace-exit tool, use it.

## Quick Reference

| Option | Merge | Push | Keep Worktree | Cleanup Branch |
|--------|-------|------|---------------|----------------|
| 1. Merge locally | yes | - | - | yes |
| 2. Create PR | - | yes | yes | - |
| 3. Keep as-is | - | - | yes | - |
| Discard (explicit request only) | - | - | - | yes (force) |

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Tests passed earlier this session" | Run the suite on the tree you are about to integrate. A green run only proves the tree it ran on. |
| "They obviously want it merged" | Integration is your human partner's decision. Present the menu and wait. |
| "They seem done with this feature — I'll offer to discard it" | The menu is complete as written. Discard happens only when your human partner asks for it in so many words. |
| "'Yeah, get rid of it' counts as confirmation" | Only the typed word `discard` authorizes deletion. |
| "The PR is up, so the worktree is clutter now" | PR feedback gets fixed in that worktree. It stays until the work lands. |
| "This other worktree looks stale — I'll clean it too" | Clean up only worktrees under `.worktrees/` or `worktrees/`. Everything else belongs to the host. |
| "The merged-result failure is probably flaky" | A failing merged result stops everything. Branch and worktree stay put while you investigate. |
| "The base branch is obviously main" | Confirm the fork point or ask. Merging into the wrong base is expensive to undo. |
| "The push was rejected — force-push will fix it" | A rejected push means the remote moved. Investigate; force-push only on your human partner's explicit request. |
