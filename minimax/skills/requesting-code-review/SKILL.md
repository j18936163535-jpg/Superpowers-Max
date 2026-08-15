---
name: requesting-code-review
description: Use when completing tasks, implementing major features, or before merging to verify work meets requirements; enforces web search discipline at the when-to-request-review trigger check, the craft-review-template and dispatch-subagent decisions, the act-on-feedback severity classification, the pushback-when-wrong judgment, the red-flags banned-actions list, and the common-rationalizations table, so each review-request decision reflects current 2026 best practice (review-trigger criteria, subagent-dispatch conventions, severity-classification surface, pushback shape, banned-actions surface, excuse/reality taxonomy) rather than stale training data Search discipline is MANDATORY: see <MANDATORY_PREAMBLE> at top of this skill before any response.
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

# Requesting Code Review

Dispatch a code reviewer subagent to catch issues before they cascade. The reviewer gets precisely crafted context for evaluation — never your session's history.

**Core principle:** Review early, review often.

<SEARCH_GATE step="when-to-request-review" triggers="T1,T4">
Before deciding "this change warrants a review" and reaching for the dispatch step, you MUST:
1. T1: Web search the current 2026 review-trigger criteria for the change class you just finished. The upstream's "Mandatory" list (after each task in subagent-driven development / after major feature / before merge to main) and "Optional but valuable" list (stuck / before refactoring / after complex bug) are a 2023-style trigger surface; current 2026 SDD/DDD conventions have expanded the trigger set to include post-incident fixes, security-sensitive diffs, schema migrations, public-API surface changes, and feature-flag flips. Confirm your change class maps to a current trigger before claiming "this is ready for review". Cite at least one [T1:url] (official guidance) + one [T2:url] (community / blog) per S2.
2. T1: For the "Optional but valuable" triggers, check whether the current 2026 best practice treats them as "valuable" or "expected". "When stuck" and "before refactoring" may have shifted from optional-fresh-perspective to mandatory-pair-review in mature 2026 workflows. Web search "code review trigger 2026" / "pair review refactor best practice 2026" before claiming a trigger is optional. Cite per S2.
3. T4: Deciding "this is ready for review" is the canonical T4 confidence assertion. The LLM is most likely to skip review when the change feels small ("just a typo fix", "just a doc update", "just a test rename"). Search to falsify: actively look for at least one credible reason the change MIGHT warrant review (touches a hot path, public API, security-sensitive code, even if small; or sets a precedent the team may want to lock in). If you find one, request review. If you find none, state the no-review decision with that negative-evidence noted per S4.
4. Output: log the change class + the matching trigger + the falsification check to `.superpowers-max/search-log/requesting-code-review-<ts>.md` per OF2. If you skip review, the log must show the trigger check passed (or no current trigger applies) and the falsification check produced no candidate.
</SEARCH_GATE>

## When to Request Review

**Mandatory:**
- After each task in subagent-driven development
- After completing major feature
- Before merge to main

**Optional but valuable:**
- When stuck (fresh perspective)
- Before refactoring (baseline check)
- After fixing complex bug

<SEARCH_GATE step="craft-review-template" triggers="T1">
Before capturing BASE_SHA/HEAD_SHA and dispatching the reviewer, you MUST:
1. T1: Web search the current 2026 best practice for the review-template placeholder set. The upstream's four placeholders (`{DESCRIPTION}` / `{PLAN_OR_REQUIREMENTS}` / `{BASE_SHA}` / `{HEAD_SHA}`) are a baseline; current 2026 review templates commonly extend with `{DIFF_STAT}` (file count, +/- lines, top-changed directories), `{TEST_RESULTS}` (test command + pass/fail counts), `{LINKED_PLAN}` (link to the active plan), `{REVIEWER_FOCUS}` (security? performance? API? style?), and `{EXPECTED_RISK}` (where the author thinks the bugs likely hide). The LLM's training data defaults to the four-placeholder template and misses the 2026 context the reviewer needs to evaluate efficiently. Cite at least one [T1:url] (a current 2026 review template) per S2.
2. T1: Verify the BASE_SHA / HEAD_SHA capture command is current. `git rev-parse HEAD~1` is correct for a single-commit change but may miss context for a multi-commit branch; current 2026 review templates often prefer `git merge-base origin/main HEAD` (for branch review) or `git log --oneline BASE..HEAD` (to surface the commit-list in the dispatch prompt). Confirm the capture command captures what the reviewer needs. Cite per S2.
3. T1: For multi-commit branches, the upstream's `git log --oneline | grep "Task 1" | head -1` pattern is fragile (case-sensitive, may miss if the commit-message convention shifted). Web search the current 2026 SDD commit-message convention for this project / framework, or use `git log BASE..HEAD --oneline` for a deterministic commit-list. Confirm the SHA capture will resolve unambiguously.
4. Output: log the actual SHA capture command + its output + the populated template (with any 2026-specific extensions) to `.superpowers-max/search-log/requesting-code-review-<ts>.md` per OF2. The dispatch prompt sent to the reviewer subagent must be evidence-backed, not template-verbatim.
</SEARCH_GATE>

## How to Request

**1. Get git SHAs:**
```bash
BASE_SHA=$(git rev-parse HEAD~1)  # or origin/main
HEAD_SHA=$(git rev-parse HEAD)
```

<SEARCH_GATE step="dispatch-subagent" triggers="T1">
Before dispatching the `general-purpose` reviewer subagent, you MUST:
1. T1: Web search the current 2026 subagent-dispatch conventions for code review. The upstream's "Dispatch a `general-purpose` subagent, filling the template" rule is a 2023-style dispatch; current 2026 frameworks may use `code-reviewer` (a dedicated role) or a custom agent defined per project. Confirm `general-purpose` is still the right choice for this project — or whether a more specialized agent exists. Cite at least one [T1:url] (the project's agent registry) per S2. If the project does not define a specialized reviewer, the upstream's `general-purpose` rule is still correct, and the log must note that.
2. T1: The upstream's "precisely crafted context, never your session's history" rule is the load-bearing one. Confirm the dispatch prompt you are about to send does NOT include session history, prior tool calls, or any content that came from this session's working memory. The LLM's training data defaults to "give the reviewer the full context" which is exactly what the upstream warns against — the reviewer is most useful when it evaluates the diff, not the LLM's reasoning about the diff. Web search "subagent context hygiene 2026" / "code review subagent prompt shape 2026" for current best practice. Cite per S2.
3. T1: For very large diffs (e.g., > 1000 lines, > 20 files), the current 2026 best practice may be to split the review into multiple subagent dispatches (one per logical chunk) rather than one massive prompt. Web search "incremental code review large diff 2026" if the diff size is non-trivial. If you do split, the BASE_SHA/HEAD_SHA boundaries must be coherent (no half-features).
4. Output: log the chosen agent role + the prompt shape + the diff size and the split decision (if any) to `.superpowers-max/search-log/requesting-code-review-<ts>.md` per OF2. The dispatch prompt must reference the evidence-backed template, not a session-history paste.
</SEARCH_GATE>

**2. Dispatch code reviewer subagent:**

Dispatch a `general-purpose` subagent, filling the template at [code-reviewer.md](code-reviewer.md)

**Placeholders:**
- `{DESCRIPTION}` - Brief summary of what you built
- `{PLAN_OR_REQUIREMENTS}` - What it should do
- `{BASE_SHA}` - Starting commit
- `{HEAD_SHA}` - Ending commit

<SEARCH_GATE step="act-on-feedback" triggers="T1,T4">
Before classifying any review feedback as Critical / Important / Minor and choosing the order to act on it, you MUST:
1. T1: Web search the current 2026 severity-classification conventions. The upstream's three-bucket model (Critical / Important / Minor) is the baseline; current 2026 review frameworks commonly use four-bucket (Blocker / Critical / Major / Minor) or five-bucket (Security / Correctness / Performance / Maintainability / Style) taxonomies. The LLM's training data defaults to the three-bucket model; confirm the project / framework uses three-bucket, or re-bucket per the current convention. Cite at least one [T1:url] per S2.
2. T1: For each item the reviewer raised, verify the technical claim by inspecting the actual code path the reviewer pointed at. A "Critical" claim that depends on a specific runtime config, deployment target, or data shape may not generalize; an "Important" claim may be project-specific. The LLM is most likely to trust the reviewer's severity classification by default — verify per item, not in bulk. Web search the specific library / API / pattern the reviewer cited, especially if the reviewer's reasoning involves version-specific behavior. Cite per S2.
3. T4: Classifying a Critical-severity issue as "Minor / note for later" is the canonical T4 confidence assertion that causes real harm — the LLM downplays a problem the reviewer flagged as urgent. Search to falsify: for each item you are tempted to downclassify, actively look for at least one credible reason the reviewer's severity is RIGHT (security boundary crossed, data corruption path, performance cliff, public-API break). If you find one, keep the original classification. If you find none, state the downclassify decision with that negative-evidence noted per S4. The upstream's "Fix Critical issues immediately" rule is non-negotiable; downclassify only with evidence.
4. T4: The "Note Minor issues for later" rule is the second-most-skip-able. The LLM is most likely to defer Minor items indefinitely. Search to falsify: confirm the "later" is a real future point (a tracked issue, a follow-up branch, a documented TODO) — not just a vague intent. If "later" is undefined, the Minor item is actually Important (because it will not get done). Cite per S2.
5. Output: log each item's original severity + your verified severity + the falsification check to `.superpowers-max/search-log/requesting-code-review-<ts>.md` per OF2. The audit trail must show each Critical was treated as Critical and each downclassify was evidence-backed.
</SEARCH_GATE>

**3. Act on feedback:**
- Fix Critical issues immediately
- Fix Important issues before proceeding
- Note Minor issues for later
- Push back if reviewer is wrong (with reasoning)

## Example

```
[Just completed Task 2: Add verification function]

You: Let me request code review before proceeding.

BASE_SHA=$(git log --oneline | grep "Task 1" | head -1 | awk '{print $1}')
HEAD_SHA=$(git rev-parse HEAD)

[Dispatch code reviewer subagent]
  DESCRIPTION: Added verifyIndex() and repairIndex() with 4 issue types
  PLAN_OR_REQUIREMENTS: Task 2 from docs/superpowers/plans/deployment-plan.md
  BASE_SHA: a7981ec
  HEAD_SHA: 3df7661

[Subagent returns]:
  Strengths: Clean architecture, real tests
  Issues:
    Important: Missing progress indicators
    Minor: Magic number (100) for reporting interval
  Assessment: Ready to proceed

You: [Fix progress indicators]
[Continue to Task 3]
```

<SEARCH_GATE step="common-rationalizations" triggers="T1,T4">
Before applying any rationale from the Common Rationalizations table (or any new rationale you generate to justify skipping review), you MUST:
1. T1: For each excuse in the table, web search the current 2026 counter-evidence. The upstream's two rows ("I'll just review the diff myself" / "The reviewer needs my whole session history") are the 2023 baseline; current 2026 LLMs have new failure modes that the table does not yet cover — e.g., "context-window-saving auto-skips review on small diffs", "post-hoc review of the LLM's own diff is not actually a review", "session-history is a hallucination source for the reviewer, not just a context-overflow source". Confirm the table's reality column still applies, and add any new 2026 rationale / reality rows that have emerged. Cite at least one [T1:url] (a documented 2026 LLM-review-failure-mode analysis) per S2.
2. T1: For any new rationale you are about to apply, search for evidence that it is a known LLM trap. The LLM's training data contains many "reasonable-sounding" excuses that have been documented as failure modes ("the change is too small to review", "the reviewer would just rubber-stamp it", "I'll review my own diff after the fact"). Web search "LLM code review self-justification failure 2026" / "agent review-skip rationale 2026" for the current taxonomy. Cite per S2.
3. T4: Applying a rationale from this table is a confidence assertion — the LLM is saying "this rule does not apply to me right now". Search to falsify: actively consider whether the rationale's "Reality" column actually applies to your current state. If you have a context-window concern, check the actual session size (per the inline rule "reviewing the diff inline burns the context window you need to keep driving the work" — confirm your context is actually at risk, not just feels large). If you have a session-history concern, check whether the dispatch prompt you are about to send actually contains session content, not just crafted context. If neither is true, the rationale does not apply.
4. Output: log each rationale you considered + the falsification check + the dispatch decision to `.superpowers-max/search-log/requesting-code-review-<ts>.md` per OF2. If you skipped review, the log must show the rationale's reality column was checked and did not apply, with negative-evidence noted.
</SEARCH_GATE>

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "I'll just review the diff myself instead of dispatching a reviewer" | You're the coordinator — reviewing the diff inline burns the context window you need to keep driving the work. Dispatch a reviewer subagent: the diff and the evaluation live in its context, and only the findings come back to you. |
| "The reviewer needs my whole session history to understand the change" | Hand it precisely crafted context, never your session's history. That keeps the reviewer on the work product, not your thought process. |

<SEARCH_GATE step="red-flags-banned" triggers="T1,T4">
Before dismissing any "Red Flags" rule as "not applicable to this change", you MUST:
1. T1: For each "Never" rule in the Red Flags list, web search the current 2026 best practice to confirm the rule is still in force. The upstream's four rules (skip review because simple / ignore Critical / proceed with unfixed Important / argue with valid technical feedback) are the 2023 baseline; current 2026 review frameworks may have added new "Never" categories — e.g., "Never re-dispatch the same reviewer after pushback without addressing the original concern", "Never suppress a Critical issue in a commit message" (the "fix typo" pattern), "Never bundle Minor cleanup into a Critical-fix commit". Confirm the list is current and add any new 2026 "Never" rules. Cite at least one [T1:url] per S2.
2. T1: Verify the "Arguing with valid technical feedback" rule applies to your current state. Valid = the reviewer's reasoning is technically correct, not just "the reviewer has authority". The LLM is most likely to conflate "I disagree" with "the reviewer is wrong" — these are different. Web search "valid vs invalid technical pushback 2026" / "code review authority vs correctness 2026" for the current boundary. Cite per S2.
3. T4: "Skip review because it's simple" is the LLM's most-applied-but-most-often-wrong confidence assertion in code review. The LLM's training data defaults to "small = simple = no review needed", which ignores that small diffs can touch hot paths, public APIs, security boundaries, or set precedents. Search to falsify: for each "simple" diff you are about to skip review on, actively look for at least one credible reason review is warranted (touches a security-sensitive file? changes a public API? modifies a heavily-called function? sets a precedent?). If you find one, request review. If you find none, state the no-review decision with negative-evidence noted per S4. Cite per S2.
4. T4: "Proceed with unfixed Important issues" is the second-most-skip-able. The LLM's training data defaults to "I'll fix it in a follow-up" which often never happens. Search to falsify: confirm the "follow-up" is a real tracked item (an issue, a follow-up branch, a documented TODO) — not just a vague intent. If "follow-up" is undefined, the Important issue is actually Critical (because the work will not get done). The upstream's "Fix Important issues before proceeding" rule is non-negotiable without evidence-backed deferral.
5. Output: log each "Never" rule you considered dismissing + the falsification check + the dispatch decision to `.superpowers-max/search-log/requesting-code-review-<ts>.md` per OF2. The audit trail must show no rule was dismissed without evidence, and the falsification check actually produced candidates.
</SEARCH_GATE>

## Red Flags

**Never:**
- Skip review because "it's simple"
- Ignore Critical issues
- Proceed with unfixed Important issues
- Argue with valid technical feedback

<SEARCH_GATE step="pushback-when-wrong" triggers="T1,T4">
Before pushing back on any review comment as "the reviewer is wrong", you MUST:
1. T1: For every technical claim in your pushback (e.g., "this breaks X", "this is Yagni for this codebase", "this is technically incorrect for this stack", "this conflicts with our convention"), web search the current authoritative source. The reviewer's claim may itself be based on a 2023 paper that has since been superseded; your pushback may be based on an equally-stale rebuttal. Cite at least one [T1:url] (official docs / RFC / spec / library CHANGELOG) per S2. If the pushback is about a library's behavior, the library's CHANGELOG / release notes are T1.
2. T1: Confirm the pushback's factual premise by inspecting the actual codebase. "This breaks existing functionality" requires identifying the specific functionality, the specific break, and the test that demonstrates it. "Reviewer lacks full context" requires pointing to the missing context. "Convention" requires citing the convention (where is it documented?). A pushback without a verified premise is just opinion, and opinion is not a technical reason. Web search the codebase's actual behavior — `git grep`, `cat`, `read` first; verify your premise matches reality before you evaluate it. Cite per S2.
3. T4: "The reviewer is wrong" is the canonical T4 confidence assertion in code-review pushback. LLMs famously over-pushback — they confidently assert the reviewer is wrong because the LLM "knows" the codebase, while missing that the reviewer has reviewed the same code with a different lens (security, performance, future maintainability, cross-team consistency, or a different mental model of the spec). Search to falsify: actively consider at least two reasons the reviewer MIGHT be right (even if your first instinct disagrees). If you find none, state the pushback with that negative-evidence noted per S4.
4. T1: The upstream's "Show code/tests that prove it works" rule is the load-bearing one. Confirm you actually have the code/test evidence in hand — not "I think the test exists" or "I will run the test after". Run the test, get the actual exit code, cite the actual output. "Should work" is not evidence. Cite per S2.
5. T1: For the "Request clarification" option, verify the request is specific. A vague "can you clarify?" is a request that wastes the reviewer's time. A specific "I read the comment as X; is the intent Y?" is a request that the reviewer can answer in one message. The LLM is most likely to ask vague clarification to avoid having to commit to a position. Web search "specific vs vague code review clarification 2026" for current norms. Cite per S2.
6. Output: log the queries + the verified premise + the falsification check + the actual test run result (if applicable) to `.superpowers-max/search-log/requesting-code-review-<ts>.md` per OF2. The pushback text sent to the reviewer must reference evidence, not opinion.
</SEARCH_GATE>

**If reviewer wrong:**
- Push back with technical reasoning
- Show code/tests that prove it works
- Request clarification

See template at: [code-reviewer.md](code-reviewer.md)
