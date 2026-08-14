---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code - produces bite-sized, TDD-shaped implementation plans an engineer with zero context can execute; enforces web search discipline before each planning decision (scope split, file structure, task right-sizing, step granularity), so the plan reflects current 2026 best practice rather than stale training data
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

# Writing Plans

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each task, code, testing, docs they might need to check, how to test it. Give them the whole plan as bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they don't know good test design very well.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Context:** If working in an isolated worktree, it should have been created via the `superpowers:using-git-worktrees` skill at execution time.

**Save plans to:** `docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md`
- (User preferences for plan location override this default)

## Scope Check

<SEARCH_GATE step="scope-check" triggers="T2">
Before deciding whether to keep this as a single plan, split it into sub-plans, or push back to brainstorming for re-scoping, you MUST:
1. T2: Web search "implementation plan size best practice 2026" and "spec decomposition single plan vs multiple plans 2026" to confirm the current 2026 guidance on what counts as a single-plan scope. The training-data heuristic ("if it has independent subsystems, split") is stable in shape but the threshold ("how many subsystems", "how much surface area", "how many reviewers") shifts between years. A 2024 reference of "3-5 tasks per plan" may now be 5-8 with subagent-driven execution, or may have tightened back to 2-4 with a renewed focus on reviewer fatigue. Cite at least one [T1:url] (official docs / RFC / industry guidance) and one [T2:url] (community / blog) per S2.
2. T2: For the specific spec in front of you, search the current best practice for that kind of decomposition. "Auth + API + billing + analytics" is a textbook split; a feature spec with "frontend form, backend endpoint, one database migration" is a textbook single plan. The LLM is most likely to either over-split (treating every distinct file as a separate plan) or under-split (packing 3 weeks of work into one plan). The current 2026 examples and case studies provide the calibrated bar.
3. T2: If the spec does need to be split, search the current best practice for the *handoff contract* between sub-plans. Sub-plans must produce working, testable software on their own (per upstream), but the exact contract — what interface the first plan exposes, what the second plan can assume, what gets stubbed — is the kind of detail that has a current best practice (per subagent-driven-development and the plan-handoff conventions in 2026). Cite at least one [T1:url] for the contract pattern.
4. Output: log the queries + the chosen scope decision (single / split / push-back) + the contract between sub-plans to `.superpowers-max/search-log/writing-plans-<ts>.md` per OF2. The audit trail must show the scope decision was searched, not assumed from training data.
</SEARCH_GATE>

If the spec covers multiple independent subsystems, it should have been broken into sub-project specs during brainstorming. If it wasn't, suggest breaking this into separate plans — one per subsystem. Each plan should produce working, testable software on its own.

## File Structure

<SEARCH_GATE step="file-structure" triggers="T2,T3">
Before mapping out which files will be created or modified and what each one is responsible for, you MUST:
1. T2: Web search "file structure best practice 2026 <language/framework>" and "module decomposition responsibility vs technical layer 2026" to confirm the current 2026 guidance for the specific stack. File-structure rules in the upstream skill ("design units with clear boundaries", "files that change together should live together", "split by responsibility not technical layer") are stable in shape but the specifics shift: a "responsibility" in 2024 React may map to a hook + a co-located test; a "responsibility" in 2024 Python may map to a module + a `__init__.py` re-export; a "responsibility" in 2026 may map to a feature folder with multiple files, a server component, or a route group. The LLM must verify the current pattern, not apply a 2022 React convention to a 2026 codebase. Cite at least one [T1:url] (official framework docs) and one [T2:url] (community / blog) per S2.
2. T2: For the specific decision you are about to make (e.g., "should this be a separate file or a method on the existing class", "should this be a hook, a util, or a context provider", "should this be a new module or an addition to an existing module"), web search the current 2026 best practice for that micro-decision. The LLM is most likely to apply the first pattern it recognizes from training data — including patterns that were correct for the project's stack in 2024 but are now superseded (e.g., a now-deprecated helper, a now-replaced state management pattern, a now-banned cross-cutting concern location). Search before committing to the structure.
3. T3: Treat this as a process step entry — also search "file structure for implementation plans 2026" / "codebase file mapping best practice 2026" to catch any recent shift in the meta-pattern (how to *document* file structure in a plan, what level of detail a plan should specify, when to leave it to the implementer). A plan that over-specifies file paths the implementer would have chosen anyway, or under-specifies paths that are load-bearing for the plan's task boundaries, is a plan failure. Search the current 2026 examples.
4. T2: If the codebase has established patterns, search whether those patterns are still the 2026 best practice before propagating them to the new plan. "In existing codebases, follow established patterns" is a safe default in the upstream skill, but it can also launder stale patterns. A codebase that uses large files in 2026 may be doing so because the project has not been modernized, not because large files are still the recommended pattern. State explicitly whether the established pattern is current.
5. Output: log the queries + the chosen file structure + the verification of the established pattern to `.superpowers-max/search-log/writing-plans-<ts>.md` per OF2. The audit trail must show the file structure was searched, not assumed.
</SEARCH_GATE>

Before defining tasks, map out which files will be created or modified and what each one is responsible for. This is where decomposition decisions get locked in.

- Design units with clear boundaries and well-defined interfaces. Each file should have one clear responsibility.
- You reason best about code you can hold in context at once, and your edits are more reliable when files are focused. Prefer smaller, focused files over large ones that do too much.
- Files that change together should live together. Split by responsibility, not by technical layer.
- In existing codebases, follow established patterns. If the codebase uses large files, don't unilaterally restructure - but if a file you're modifying has grown unwieldy, including a split in the plan is reasonable.

This structure informs the task decomposition. Each task should produce self-contained changes that make sense independently.

## Task Right-Sizing

<SEARCH_GATE step="task-right-sizing" triggers="T2">
Before drawing task boundaries, you MUST:
1. T2: Web search "task right-sizing implementation plan 2026" and "task size for code review 2026" to confirm the current 2026 guidance on what counts as "right-sized". The upstream rule ("smallest unit that carries its own test cycle and is worth a fresh reviewer's gate") is the shape of the answer but the calibration shifts: a "fresh reviewer's gate" in 2024 may have been 30-60 minutes of review; in 2026 with AI-assisted review the gate may be shorter, or with a focus on reviewer cognitive load it may be longer. A 2024 reference of "30-90 minutes per task" may now be 20-45 minutes or 45-120 minutes. Cite at least one [T1:url] (industry guidance / engineering org blog) and one [T2:url] (community / SO) per S2.
2. T2: For the specific split-vs-fold decisions you are about to make (e.g., "is the DB migration part of this task or its own task", "is the config file change a separate task or folded into the first task that uses it", "is the test fixture a separate task or folded into the test task"), web search the current 2026 best practice for that micro-decision. The LLM is most likely to over-split (treating every distinct file as a separate task) or under-split (packing 3 reviewers'-gates of work into one task). The current 2026 examples and case studies provide the calibrated bar.
3. T2: If the plan will be executed by subagents (per the "Execution Handoff" section), search the current 2026 best practice for subagent task boundaries. Subagents have different right-sizing criteria than human engineers — a subagent task that is "right-sized for a human reviewer" may be too large (because subagent context windows are different) or too small (because subagent overhead per task is higher). The upstream rule was written for human reviewers; the subagent-driven variant has its own current best practice. Cite at least one [T1:url] (subagent-driven-development docs / current framework).
4. Output: log the queries + the chosen task boundary + the subagent-vs-human distinction to `.superpowers-max/search-log/writing-plans-<ts>.md` per OF2. The audit trail must show the right-sizing was searched, not assumed from training data.
</SEARCH_GATE>

A task is the smallest unit that carries its own test cycle and is worth a
fresh reviewer's gate. When drawing task boundaries: fold setup,
configuration, scaffolding, and documentation steps into the task whose
deliverable needs them; split only where a reviewer could meaningfully
reject one task while approving its neighbor. Each task ends with an
independently testable deliverable.

## Bite-Sized Task Granularity

<SEARCH_GATE step="bite-sized-granularity" triggers="T3">
Before writing the per-step granularity for any task, you MUST:
1. T3: Treat this as a process step entry — web search "step granularity implementation plan 2026" and "bite-sized task step best practice 2026" to confirm the current 2026 guidance on what counts as a "bite-sized step". The upstream rule ("each step is one action (2-5 minutes)") is the shape of the answer but the calibration shifts: a "2-5 minute step" in 2024 was calibrated for a human engineer reading on a laptop; in 2026 with subagent execution the granularity is different (subagents are faster per step but have higher per-step overhead, so the optimal step size is different). A 2024 reference of "5-15 minutes" may now be 2-5 minutes or 10-20 minutes. Cite at least one [T1:url] (current industry guidance / TDD practitioner blog) and one [T2:url] (community / SO) per S2.
2. T3: For the specific kind of step you are about to write (e.g., "write the failing test", "implement the minimal code", "commit"), web search the current 2026 best practice for the granularity of that step type. The TDD micro-cycle ("write test → run it → implement → run again → commit") has a stable shape but the specific steps have shifted: a 2024 "write the failing test" step assumed a 30-second test run; a 2026 "write the failing test" step may include a snapshot-update step, a coverage-check step, or a pre-commit-hook step. The "2-5 minutes" rule is the *target*; the *content* of each step has evolved.
3. T3: If the implementer is a subagent (per the "Execution Handoff" section), search the current 2026 best practice for subagent step granularity. Subagents benefit from even smaller, more explicit steps than human engineers (because they cannot infer implicit context), but also from fewer, more meaningful steps (because each step has overhead). The "2-5 minutes" rule may need to be tightened to "1-3 minutes" or loosened to "5-10 minutes" for subagent execution. Cite at least one [T1:url] (subagent-driven-development docs / current framework).
4. Output: log the queries + the chosen granularity + the subagent-vs-human distinction to `.superpowers-max/search-log/writing-plans-<ts>.md` per OF2. The audit trail must show the granularity was searched, not assumed from training data.
</SEARCH_GATE>

**Each step is one action (2-5 minutes):**
- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Commit" - step

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

## Global Constraints

[The spec's project-wide requirements — version floors, dependency limits,
naming and copy rules, platform requirements — one line each, with exact
values copied verbatim from the spec. Every task's requirements implicitly
include this section.]

---
```

## Task Structure

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

**Interfaces:**
- Consumes: [what this task uses from earlier tasks — exact signatures]
- Produces: [what later tasks rely on — exact function names, parameter
  and return types. A task's implementer sees only their own task; this
  block is how they learn the names and types neighboring tasks use.]

- [ ] **Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

- [ ] **Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

- [ ] **Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

- [ ] **Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
````

## No Placeholders

Every step must contain the actual content an engineer needs. These are **plan failures** — never write them:
- "TBD", "TODO", "implement later", "fill in details"
- "Add appropriate error handling" / "add validation" / "handle edge cases"
- "Write tests for the above" (without actual test code)
- "Similar to Task N" (repeat the code — the engineer may be reading tasks out of order)
- Steps that describe what to do without showing how (code blocks required for code steps)
- References to types, functions, or methods not defined in any task

## Self-Review

After writing the complete plan, look at the spec with fresh eyes and check the plan against it. This is a checklist you run yourself — not a subagent dispatch.

**1. Spec coverage:** Skim each section/requirement in the spec. Can you point to a task that implements it? List any gaps.

**2. Placeholder scan:** Search your plan for red flags — any of the patterns from the "No Placeholders" section above. Fix them.

**3. Type consistency:** Do the types, method signatures, and property names you used in later tasks match what you defined in earlier tasks? A function called `clearLayers()` in Task 3 but `clearFullLayers()` in Task 7 is a bug.

If you find issues, fix them inline. No need to re-review — just fix and move on. If you find a spec requirement with no task, add the task.

## Execution Handoff

After saving the plan, offer execution choice:

**"Plan complete and saved to `docs/superpowers/plans/<filename>.md`. Two execution options:**

**1. Subagent-Driven (recommended)** - I dispatch a fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** - Execute tasks in this session using executing-plans, batch execution with checkpoints

**Which approach?"**

**If Subagent-Driven chosen:**
- **REQUIRED SUB-SKILL:** Use superpowers:subagent-driven-development
- Fresh subagent per task + two-stage review

**If Inline Execution chosen:**
- **REQUIRED SUB-SKILL:** Use superpowers:executing-plans
- Batch execution with checkpoints for review
