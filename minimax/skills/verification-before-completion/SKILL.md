---
name: verification-before-completion
description: Use when about to claim work is complete, fixed, or passing, before committing or creating PRs - requires running verification commands and confirming output before making any success claims; evidence before assertions always; enforces web search discipline to verify current best practice and to falsify the LLM's own confidence before any completion claim Search discipline is MANDATORY: see <MANDATORY_PREAMBLE> at top of this skill before any response.
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


# Verification Before Completion

## Overview

**Core principle:** Evidence before claims, always.

**Violating the letter of this rule is violating the spirit of this rule.**

## The Iron Law

<SEARCH_GATE step="iron-law" triggers="T1,T4">
Before stating or applying the iron law, you MUST:
1. T1: Web search "verification before completion best practice 2026" and "evidence before claims principle software 2026" to confirm the rule is still the current consensus in 2026 — it should not have been superseded by a newer framework (e.g., a "trust but verify" variant, an automated CI-only discipline, or a newer spec like SLSA/Sigstore-led attestation).
2. T4: This is a universal rule. Recognizing a universal rule is the canonical T4 confidence assertion — you are about to say "this is always true". Search to falsify: look for at least one credible case where the rule legitimately does NOT apply (e.g., trivial throwaway scripts, CI auto-gated commits, machine-verified proofs). If you find a genuine exception, narrow the rule in your output. If you find none, state the rule with that negative-evidence noted.
3. Output: log the queries to `.superpowers-max/search-log/verification-before-completion-<ts>.md` per OF2, with the chosen phrasing of the rule and a [T1:url] / [T2:url] citation.
</SEARCH_GATE>

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you haven't run the verification command in this message, you cannot claim it passes.

## The Gate Function

<SEARCH_GATE step="gate-function" triggers="T1,T4">
Before executing the gate function on any claim, you MUST:
1. T1: Web search "<claim type> verification command 2026" to confirm the verification command you'd run (test runner, build tool, lint, smoke check) is still the right one. The project's tooling may have changed since training-data cutoff — e.g., a new test runner, a deprecated build flag, a shifted linter default. Never run a command you haven't first confirmed is current.
2. T1: For each command you plan to run, search the official docs to confirm the expected exit code and output format. A 0/non-zero interpretation can flip between major versions; partial output can be misleading; cached output can mask failure.
3. T4: After running, before claiming "I followed the gate function" — that is a confidence assertion. Re-read the actual captured output (not a paraphrase, not a summary from earlier) and confirm each of the 5 steps was actually performed in this message. If you skipped any step, state the skip and its reason explicitly.
4. Output: log the queries + the actual command + the actual exit code + the actual output excerpt to `.superpowers-max/search-log/verification-before-completion-<ts>.md` per OF2. The audit trail must be reproducible from the log alone.
</SEARCH_GATE>

```
BEFORE claiming any status or expressing satisfaction:

1. IDENTIFY: What command proves this claim?
2. RUN: Execute the FULL command (fresh, complete)
3. READ: Full output, check exit code, count failures
4. VERIFY: Does output confirm the claim?
   - If NO: State actual status with evidence
   - If YES: State claim WITH evidence
5. ONLY THEN: Make the claim

Skip any step = lying, not verifying
```

## Common Failures

| Claim | Requires | Not Sufficient |
|-------|----------|----------------|
| Tests pass | Test command output: 0 failures | Previous run, "should pass" |
| Linter clean | Linter output: 0 errors | Partial check, extrapolation |
| Build succeeds | Build command: exit 0 | Linter passing, logs look good |
| Bug fixed | Test original symptom: passes | Code changed, assumed fixed |
| Regression test works | Red-green cycle verified | Test passes once |
| Agent completed | VCS diff shows changes | Agent reports "success" |
| Requirements met | Line-by-line checklist | Tests passing |

## Red Flags - STOP

- Using "should", "probably", "seems to"
- Expressing satisfaction before verification ("Great!", "Perfect!", "Done!", etc.)
- About to commit/push/PR without verification
- Trusting agent success reports
- Relying on partial verification
- Thinking "just this once"
- Tired and wanting work over
- **ANY wording implying success without having run verification**

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "Should work now" | RUN the verification |
| "I'm confident" | Confidence ≠ evidence |
| "Just this once" | No exceptions |
| "Linter passed" | Linter ≠ compiler |
| "Agent said success" | Verify independently |
| "I'm tired" | Exhaustion ≠ excuse |
| "Partial check is enough" | Partial proves nothing |
| "Different words so rule doesn't apply" | Spirit over letter |

## Key Patterns

**Tests:**
<SEARCH_GATE step="tests-pattern" triggers="T1">
Before claiming "all tests pass", you MUST:
1. T1: Web search the project's test runner to confirm the exact command and what "all pass" means in this runner (e.g., does "0 failures" include skipped/pending? Is there a coverage gate that must also be met? Does the runner cache results across runs?). Training-data knowledge of `npm test` / `pytest` / `cargo test` / `go test` may not match the project's actual config.
2. T1: Search for the project's test framework's current exit-code semantics — a 0 exit is necessary but not always sufficient (e.g., some frameworks exit 0 on partial pass with a warning).
3. T1: Confirm the test run is FRESH (not cached, not from a previous invocation, not a partial rerun). Cross-reference the actual command output's timestamp/random seed against the claim.
4. Output: cite the actual command + actual pass count + actual exit code in the claim. If any of those are missing, the claim is [UNVERIFIED] regardless of how confident you feel.
</SEARCH_GATE>

```
✅ [Run test command] [See: 34/34 pass] "All tests pass"
❌ "Should pass now" / "Looks correct"
```

**Regression tests (TDD Red-Green):**
<SEARCH_GATE step="regression-pattern" triggers="T1,T4">
Before claiming a regression test "works", you MUST:
1. T1: Web search "regression test red green cycle 2026" to confirm the TDD discipline is still the standard. Also search for any newer variant (mutation testing, property-based testing, snapshot regression) that may apply to this case.
2. T1: Confirm the reverted-fix run ACTUALLY FAILED in this session — not a previous session, not a paraphrase, not "I'm sure it would have failed". Capture the actual failure output (test name + exit code + error message excerpt). If the test did not fail when the fix was reverted, the regression test is not actually catching the regression.
3. T4: Claiming "the test works" is the canonical T4 confidence assertion — you are asserting the test would catch the bug if reintroduced. Search to falsify: consider adversarial inputs, edge cases the test does not cover, and the test's scope. If the test only covers a narrow slice, say so.
4. Output: log the write/revert/restore sequence + actual pass counts at each step to `.superpowers-max/search-log/verification-before-completion-<ts>.md` per OF2.
</SEARCH_GATE>

```
✅ Write → Run (pass) → Revert fix → Run (MUST FAIL) → Restore → Run (pass)
❌ "I've written a regression test" (without red-green verification)
```

**Build:**
<SEARCH_GATE step="build-pattern" triggers="T1">
Before claiming "build succeeds", you MUST:
1. T1: Web search the project's build tool to confirm the exact command and what "build passes" means here. A successful build may still emit warnings that signal real problems (deprecated APIs, missing type definitions, unreferenced exports). "Exit 0" is necessary, not sufficient.
2. T1: Search the build tool's current docs for the difference between a "clean build" and an "incremental build" — and which one you actually ran. A passing incremental build can mask a broken clean build.
3. T1: Confirm the build artifact exists and is non-empty (file size > 0, mtime updated). A passing `tsc --noEmit` is not a build; a passing `go build` that emits no binary is suspicious.
4. Output: cite the actual command + actual exit code + actual artifact size/hash in the claim. Note any warnings even if exit was 0.
</SEARCH_GATE>

```
✅ [Run build] [See: exit 0] "Build passes"
❌ "Linter passed" (linter doesn't check compilation)
```

**Requirements:**
<SEARCH_GATE step="requirements-pattern" triggers="T1,T4">
Before claiming "all requirements met" or "phase complete", you MUST:
1. T1: Re-read the plan/spec from disk (do not rely on memory or the prompt summary). Plans can be updated mid-task; the LLM's training-data version is stale. Web search for any references to external standards, APIs, or library versions the plan depends on — confirm they are still current.
2. T1: For each requirement, verify the specific evidence that proves it is met (a passing test, a CLI command output, a rendered screenshot, a log line). "Tests pass" is not the same as "all requirements met" — tests can be missing, requirements can be untested.
3. T4: Claiming "all requirements met" is the canonical T4 confidence assertion — you are asserting completeness. Search to falsify: enumerate any requirement that has weak or no evidence, any "should" / "probably" in your own reasoning, any unverified dependency on external state.
4. Output: produce the line-by-line checklist with each item marked ✅ verified-with-evidence or ⚠️ partial-or-unverified, then state completion with that checklist attached. The checklist IS the claim; the claim without the checklist is [UNVERIFIED].
</SEARCH_GATE>

```
✅ Re-read plan → Create checklist → Verify each → Report gaps or completion
❌ "Tests pass, phase complete"
```

**Agent delegation:**
<SEARCH_GATE step="agent-delegation" triggers="T1">
Before trusting an agent's success report, you MUST:
1. T1: Web search "verifying subagent output 2026" to confirm the current best practice for independently checking delegated work. The standard is "VCS diff + output capture + test re-run", but newer methods may exist (e.g., structured agent reports with cryptographic signatures, sandbox re-execution, trace-based verification).
2. T1: Inspect the actual VCS diff yourself — `git diff` or equivalent — and confirm the changes match what the agent reported. An agent can report "fixed X" while the diff shows an unrelated change. An agent can report "no changes" while the diff shows a half-finished edit.
3. T1: Re-run the test/build/lint that the agent claims passed. Agent self-reports can be wrong (test framework misconfiguration, cached results, env drift). Treat the agent's report as one data point, not as evidence.
4. Output: state the actual diff summary + actual re-run output in your report, not the agent's paraphrase. If the diff and the agent's report disagree, the diff wins; flag the disagreement explicitly.
</SEARCH_GATE>

```
✅ Agent reports success → Check VCS diff → Verify changes → Report actual state
❌ Trust agent report
```

## When To Apply

**ALWAYS before:**
- ANY variation of success/completion claims
- ANY expression of satisfaction
- ANY positive statement about work state
- Committing, PR creation, task completion
- Moving to next task
- Delegating to agents

**Rule applies to:**
- Exact phrases
- Paraphrases and synonyms
- Implications of success
- ANY communication suggesting completion/correctness
