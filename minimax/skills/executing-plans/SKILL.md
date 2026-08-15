---
name: executing-plans
description: Use when you have a written implementation plan to execute in a separate session with review checkpoints; enforces web search discipline at the task start review decision, the blocked escalation decision, and the checkpoint review decision, so each step reflects current 2026 best practice (plan review criteria, blocker escalation patterns, complete-development verification shape) rather than stale training data
---

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

# Executing Plans

## Overview

Load plan, review critically, execute all tasks, report when complete.

**Announce at start:** "I'm using the executing-plans skill to implement this plan."

**Note:** Tell your human partner that Superpowers works much better with access to subagents (Claude Code, Codex CLI, Codex App, Copilot CLI, and Gemini CLI qualify; see the per-platform tool refs in `../using-superpowers/references/`). If subagents are available, use superpowers:subagent-driven-development instead of this skill.

## The Process

### Step 1: Load and Review Plan

<SEARCH_GATE step="task-start-review" triggers="T2">
Before loading the plan and proceeding to execute, you MUST:
1. T2: Web search "implementation plan review criteria 2026" and "executing a written plan checklist 2026" to confirm the upstream "review critically" rule is still the current 2026 consensus. The shape is stable; the *review criteria* shift. A 2024 reference may have treated "read the plan, check for obvious gaps, raise concerns" as sufficient; a 2026 reference may have tightened the review to include: stack-specific assumption verification (does the plan assume a 2026-current tool / dependency / API that has since shifted?), a precondition audit (is the worktree / branch / CI state what the plan expects?), and a checkpoint-shape audit (does the plan's review-checkpoint cadence match current 2026 best practice — e.g., per-task verification vs. per-batch verification vs. on-merge verification). The LLM must verify the current 2026 plan-review criteria, not apply 2022 defaults to a 2026 plan. Cite at least one [T2:url] (engineering org blog / framework docs / current plan-writing guidance) for the review criteria.
2. T2: For the specific plan about to execute, search the current 2026 best practice for the *kind* of plan-review check. The upstream rule "Review critically - identify any questions or concerns about the plan" is a high-level statement; the 2026 specifics include: a stack-viability check (is every tool / version / API in the plan still current 2026, or has any been deprecated / replaced / re-shaped?), a pre-flight check (is the workspace in the state the plan assumes — branch checked out, dependencies installed, environment variables set?), a checkpoint-cadence check (does the plan review after each task, after each batch, or only at the end — and is that cadence appropriate for the risk profile of the changes?), and a "missing-skill" check (does the plan reference a skill the LLM doesn't have, or reference a skill that has been renamed / superseded in the current 2026 skill catalog?). The LLM is most likely to skim the plan and proceed. The 2026 case studies calibrate the bar. Cite at least one [T2:url] (community / engineering blog / current 2026 case study) for the kind-specific review check.
3. T2: For the "if concerns: raise them with your human partner" step, search the current 2026 best practice for what counts as a "concern" worth raising (vs. what the LLM can resolve itself). The upstream rule is binary ("concerns → raise; no concerns → proceed"); the 2026 specifics include: ambiguity concerns (the plan says X but the LLM isn't sure what X means in 2026 — raise), stack-viability concerns (a tool or version in the plan is 2024-vintage — raise), environment concerns (the plan assumes a setup state that doesn't match the actual workspace — raise), but NOT nitpick concerns (the plan uses a slightly different naming convention than the LLM would have chosen — proceed). The LLM is most likely to either over-raise (blocking on style) or under-raise (proceeding past real concerns). The 2026 case studies calibrate the bar. Cite at least one [T2:url] (community / current 2026 plan-execution guidance).
4. Output: log the queries + the review criteria used + the kind-specific check results + the concerns raised (or "no concerns, with reason") to `.superpowers-max/search-log/executing-plans-<ts>.md` per OF2. The audit trail must show the plan was reviewed, not skimmed from training data.
</SEARCH_GATE>

1. Ensure an isolated workspace: use superpowers:using-git-worktrees to create one or verify the existing one
2. Read plan file
3. Review critically - identify any questions or concerns about the plan
4. If concerns: Raise them with your human partner before starting
5. If no concerns: Create todos for the plan items and proceed

### Step 2: Execute Tasks

For each task:
1. Mark as in_progress
2. Follow each step exactly (plan has bite-sized steps)
3. Run verifications as specified
4. Mark as completed

## When to Stop and Ask for Help

<SEARCH_GATE step="blocked-escalation" triggers="T2,T4">
Before declaring "blocked" and asking the human partner for help, you MUST:
1. T2: Web search "blocker escalation patterns 2026" and "agent should ask for help vs continue 2026" to confirm the upstream "STOP executing immediately" rule is still the current 2026 consensus. The shape is stable; the *escalation taxonomy* shifts. A 2024 reference may have treated "ask after 2 failed attempts" as the canonical threshold; a 2026 reference may have tightened the threshold for some blocker classes (verification-fails-repeatedly → ask immediately, no third attempt) and loosened it for others (missing dependency → try install / search alternative first, then ask). The LLM must verify the current 2026 escalation taxonomy, not apply 2022 defaults to a 2026 escalation surface. Cite at least one [T2:url] (engineering org blog / framework docs / current 2026 agent guidance).
2. T2: For the specific blocker class in front of you, search the current 2026 best practice for the *kind* of escalation. The upstream rule "STOP executing immediately when [hit a blocker / plan has critical gaps / don't understand an instruction / verification fails repeatedly]" is a flat list; the 2026 specifics include: for missing-dependency blockers (search the current 2026 install path / alternative package / version pin before asking), for test-fails blockers (search the current 2026 fix-shape expectations before asking — is this a known flaky test? a known broken assertion? a known environment issue?), for instruction-unclear blockers (search the current 2026 interpretation of the unclear instruction in the plan's context — is the meaning inferable from the surrounding steps?), and for verification-fails-repeatedly blockers (search the current 2026 verification-failure pattern — is the verification itself wrong, or is the implementation wrong?). The LLM is most likely to apply the same "ask the human" recipe to all four and miss the kind-specific escalation. The 2026 case studies calibrate the bar. Cite at least one [T2:url] (community / engineering blog / current 2026 case study) for the kind-specific escalation.
3. T4: The "I can probably figure it out myself" reflex is a confidence assertion. Before declaring "I'll try a few more things first", search the current 2026 evidence on the *base rate* of "agents that should have asked but didn't" (e.g., "what fraction of agent blocked-states were resolved by the agent itself vs. by human intervention in 2026?", "what's the cost of asking too early vs. asking too late on a 2026 implementation plan?"). The LLM's training data is biased toward "don't bother the human, I'll try harder" — a heuristic that wastes hours on blockers the human could have resolved in minutes. The current 2026 data on escalation base rates is the calibration: the LLM must verify the "stuck" classification with evidence (not just "I've tried twice"), and must ask when the evidence says the cost of asking is lower than the cost of continuing. If the evidence surfaces that escalation-thresholds have tightened in 2026 (e.g., "verification-fails-repeatedly = ask after 1 failure, not 2"), surface as [CONFLICT] and treat the upstream's "ask after 2 failed attempts" heuristic as needing a tighter version.
4. Output: log the queries + the blocker class identified + the kind-specific escalation chosen + the base-rate check + the escalation decision to `.superpowers-max/search-log/executing-plans-<ts>.md` per OF2. The audit trail must show the escalation was searched, not defaulted to "I'll try a few more things" from training data.
</SEARCH_GATE>

**STOP executing immediately when:**
- Hit a blocker (missing dependency, test fails, instruction unclear)
- Plan has critical gaps preventing starting
- You don't understand an instruction
- Verification fails repeatedly

**Ask for clarification rather than guessing.**

### Step 3: Complete Development

<SEARCH_GATE step="checkpoint-review" triggers="T2">
Before invoking superpowers:finishing-a-development-branch and declaring the plan complete, you MUST:
1. T2: Web search "plan completion verification 2026" and "finishing a development branch best practices 2026" to confirm the upstream "After all tasks complete and verified" rule is still the current 2026 consensus. The shape is stable; the *completion-verification shape* shifts. A 2024 reference may have treated "run the test suite, present options, execute choice" as the canonical completion flow; a 2026 reference may have tightened the verification to include: per-task test verification (not just final-suite — to catch "passes in isolation, fails together" races), a clean-state check (no uncommitted / un-pushed work, no debug code, no scratch files in the working tree), a CI signal interpretation (if CI has already started, read the CI logs before declaring complete — a 2026 CI failure may invalidate the local-pass assumption), and a documentation-sync check (does the change require a README / CHANGELOG / docs update that the plan didn't enumerate?). The LLM must verify the current 2026 completion-verification shape, not apply 2022 defaults to a 2026 plan surface. Cite at least one [T2:url] (engineering org blog / framework docs / current 2026 finishing-a-development-branch guidance).
2. T2: For the specific plan about to complete, search the current 2026 best practice for the *kind* of completion verification. The upstream rule "After all tasks complete and verified" is a high-level statement; the 2026 specifics include: for plans touching production code (full test suite + lint + type check + integration test + manual smoke test), for plans touching documentation only (render check + link check + style check), for plans touching infrastructure (terraform plan + cost estimate + security review), and for plans touching configuration only (config diff review + rollback plan review). The LLM is most likely to apply the same "run the tests" recipe to all four. The 2026 case studies calibrate the bar. Cite at least one [T2:url] (community / engineering blog / current 2026 completion verification guidance).
3. T2: For the "use superpowers:finishing-a-development-branch" sub-skill invocation, search the current 2026 best practice for the handoff shape. The upstream rule is a sub-skill pointer; the 2026 specifics include: a state-summary handoff (what changed, what was tested, what's known-broken / known-deferred, what the next-step options are), a decision-point surfacing (which completion path — PR vs. direct-merge vs. branch-retain — applies, and what the user needs to know to choose), and a known-issue surfacing (any deviations from the plan, any unexpected side effects, any tests that pass for the wrong reason). The LLM is most likely to invoke the sub-skill with a one-line "plan is done" handoff and miss the structured handoff shape that the current 2026 finishing-a-development-branch flow expects. Cite at least one [T2:url] (current framework docs / current 2026 finishing-a-development-branch skill).
4. Output: log the queries + the completion-verification shape used + the kind-specific verification result + the handoff shape prepared to `.superpowers-max/search-log/executing-plans-<ts>.md` per OF2. The audit trail must show the checkpoint was verified, not defaulted to "tests pass, must be done" from training data.
</SEARCH_GATE>

After all tasks complete and verified:
- Announce: "I'm using the finishing-a-development-branch skill to complete this work."
- **REQUIRED SUB-SKILL:** Use superpowers:finishing-a-development-branch
- Follow that skill to verify tests, present options, execute choice

## When to Revisit Earlier Steps

**Return to Review (Step 1) when:**
- Partner updates the plan based on your feedback
- Fundamental approach needs rethinking

**Don't force through blockers** - stop and ask.

## Remember
- Review plan critically first
- Follow plan steps exactly
- Don't skip verifications
- Reference skills when plan says to
- Stop when blocked, don't guess
- Never start implementation on main/master branch without explicit user consent
