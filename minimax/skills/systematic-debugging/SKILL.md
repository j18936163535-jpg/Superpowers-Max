---
name: systematic-debugging
description: Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes - requires root-cause investigation before any fix attempt; enforces web search discipline to verify each error-message interpretation, each "X is broken because Y" root-cause claim, and each "the bug is" assertion against current 2026 evidence before treating any hypothesis as confirmed Search discipline is MANDATORY: see <MANDATORY_PREAMBLE> at top of this skill before any response.
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

# Systematic Debugging

## Overview

**Core principle:** ALWAYS find root cause before attempting fixes. Symptom fixes are failure.

**Violating the letter of this process is violating the spirit of debugging.**

## The Iron Law

<SEARCH_GATE step="iron-law-enter" triggers="T1">
Before stating or applying the iron law ("NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST"), you MUST:
1. T1: Web search "root cause analysis first vs fix now 2026" and "systematic debugging iron law best practice 2026" to confirm the rule is still the current consensus in 2026 — it should not have been superseded by a newer framework (e.g., a "ship-the-mitigation-then-investigate" SRE pattern, an automated observability-driven discipline, or a newer spec like SLSA / OpenTelemetry-led root-cause automation). Cite at least one [T1:url] (official docs / RFC) and confirm with a [T2:url] (community / blog) per S2.
2. T1: For the specific failure type in front of you, search the current best practice for that failure class (e.g., "flaky test root cause 2026", "memory leak debugging methodology 2026"). The general iron law is stable, but the specific Phase-1 evidence-gathering steps (which signals, which log levels, which tracing tools) shift with each major version of observability tooling. Train on stale techniques and Phase 1 will miss the actual cause.
3. T1: Confirm you are about to enter Phase 1 (Root Cause Investigation) and not skip directly to a fix. LLMs routinely state the iron law and then immediately propose a fix — a behavior pattern that violates the rule while citing it. Re-read your last paragraph: if it ends with "so let's try X", the iron law has been violated. Return to Phase 1.
4. Output: log the queries + the failure class + the chosen Phase 1 entry path to `.superpowers-max/search-log/systematic-debugging-<ts>.md` per OF2, with at least one [T1:url] / [T2:url] citation. The audit trail must show you actually entered Phase 1 in this message, not after the fact.
</SEARCH_GATE>

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

If you haven't completed Phase 1, you cannot propose fixes.

## When to Use

Use for ANY technical issue:
- Test failures
- Bugs in production
- Unexpected behavior
- Performance problems
- Build failures
- Integration issues

**Use this ESPECIALLY when:**
- Under time pressure (emergencies make guessing tempting)
- "Just one quick fix" seems obvious
- You've already tried multiple fixes
- Previous fix didn't work
- You don't fully understand the issue

**Don't skip when:**
- Issue seems simple (simple bugs have root causes too)
- You're in a hurry (rushing guarantees rework)
- Manager wants it fixed NOW (systematic is faster than thrashing)

## The Four Phases

You MUST complete each phase before proceeding to the next.

### Phase 1: Root Cause Investigation

**BEFORE attempting ANY fix:**

1. **Read Error Messages Carefully**

<SEARCH_GATE step="error-read" triggers="T1">
Before interpreting any error message, warning, or stack trace as "this means X", you MUST:
1. T1: For each error string / error code / warning text in the failure, web search the current authoritative meaning in the project's runtime/library. Error wording shifts between major versions: a "ConnectionResetError" in Python 3.10 may have a different triggering condition than in 3.12; a React "Hydration failed" warning may map to a different root cause in React 18 vs 19. The LLM's training-data interpretation may be stale. Cite at least one [T1:url] (official docs / changelog) and one [T2:url] (community confirmation) per S2.
2. T1: For each error message that references a file path, line number, function, or symbol, verify the symbol actually exists at that location in the current codebase. An error may reference a file that was renamed, a function that was refactored, or a line that has since moved. `git grep` / `cat` / `read` first; do not trust the line number from the prompt.
3. T1: For each "this means X" interpretation you write down, search for the current known false-positives. Library authors publish "common misconceptions" docs and Stack Overflow high-vote questions identify the most common misreadings. If the interpretation is a known false positive, discard it and search for the correct meaning.
4. Output: log the actual error string + the verified symbol/file evidence + the cited [T1:url] for each error to `.superpowers-max/search-log/systematic-debugging-<ts>.md` per OF2. The audit trail must show the interpretation was searched, not assumed.
</SEARCH_GATE>

   - Don't skip past errors or warnings
   - They often contain the exact solution
   - Read stack traces completely
   - Note line numbers, file paths, error codes

2. **Reproduce Consistently**
   - Can you trigger it reliably?
   - What are the exact steps?
   - Does it happen every time?
   - If not reproducible → gather more data, don't guess

3. **Check Recent Changes**
   - What changed that could cause this?
   - Git diff, recent commits
   - New dependencies, config changes
   - Environmental differences

4. **Gather Evidence in Multi-Component Systems**

<SEARCH_GATE step="gather-evidence" triggers="T1">
Before claiming "the failure is at layer X" based on instrumentation, you MUST:
1. T1: For the specific signal you logged (env var name, keychain identity, HTTP header, file presence, exit code), web search the current authoritative propagation rule. A "workflow → build script" propagation that worked last year may have changed because the CI runner version bumped, the shell was changed from `bash` to `sh`, or a secrets-mounting mechanism was deprecated. Cite at least one [T1:url] (official CI runner docs / official build-tool docs) per S2.
2. T1: For each component boundary you instrumented, confirm the signal you logged is the correct signal. A "verbose" flag in version 1.x of a tool may have moved to a different flag in 2.x, may have changed its output format, or may be ignored under certain configurations. The LLM may "log X" but the underlying tool may have stopped emitting X — yielding a false-negative "X is unset" claim.
3. T1: After running once, before claiming "layer N is the failing component", web search the failure mode pattern you observed. A "secrets present but not propagated" symptom can have multiple distinct root causes (env var prefix mismatch, shell wrapper, sub-process detachment, encoding issue). The LLM may lock in the first cause it recognizes; the search log must show the alternatives were considered.
4. Output: log the actual instrumented command + the actual captured output + the cited [T1:url] for each signal to `.superpowers-max/search-log/systematic-debugging-<ts>.md` per OF2. The audit trail must show the signal was emitted as expected, not assumed to be emitted.
</SEARCH_GATE>

   **WHEN system has multiple components (CI → build → signing, API → service → database):**

   **BEFORE proposing fixes, add diagnostic instrumentation:**
   ```
   For EACH component boundary:
     - Log what data enters component
     - Log what data exits component
     - Verify environment/config propagation
     - Check state at each layer

   Run once to gather evidence showing WHERE it breaks
   THEN analyze evidence to identify failing component
   THEN investigate that specific component
   ```

   **Example (multi-layer system):**
   ```bash
   # Layer 1: Workflow
   echo "=== Secrets available in workflow: ==="
   echo "IDENTITY: ${IDENTITY:+SET}${IDENTITY:-UNSET}"

   # Layer 2: Build script
   echo "=== Env vars in build script: ==="
   env | grep IDENTITY || echo "IDENTITY not in environment"

   # Layer 3: Signing script
   echo "=== Keychain state: ==="
   security list-keychains
   security find-identity -v

   # Layer 4: Actual signing
   codesign --sign "$IDENTITY" --verbose=4 "$APP"
   ```

   **This reveals:** Which layer fails (secrets → workflow ✓, workflow → build ✗)

5. **Trace Data Flow**

   **WHEN error is deep in call stack:**

   See `root-cause-tracing.md` in this directory for the complete backward tracing technique.

   **Quick version:**
   - Where does bad value originate?
   - What called this with bad value?
   - Keep tracing up until you find the source
   - Fix at source, not at symptom

### Phase 2: Pattern Analysis

**Find the pattern before fixing:**

1. **Find Working Examples**
   - Locate similar working code in same codebase
   - What works that's similar to what's broken?

2. **Compare Against References**
   - If implementing pattern, read reference implementation COMPLETELY
   - Don't skim - read every line
   - Understand the pattern fully before applying

3. **Identify Differences**
   - What's different between working and broken?
   - List every difference, however small
   - Don't assume "that can't matter"

4. **Understand Dependencies**
   - What other components does this need?
   - What settings, config, environment?
   - What assumptions does it make?

### Phase 3: Hypothesis and Testing

**Scientific method:**

1. **Form Single Hypothesis**

<SEARCH_GATE step="form-hypothesis" triggers="T1">
Before writing down "I think X is the root cause because Y" (or any "X is broken because Y" claim), you MUST:
1. T1: For the specific cause X you are proposing, web search the current authoritative evidence. A "root cause" claim is a fact-claim: it asserts that this specific mechanism is the one producing the symptom. Library behavior changes between versions; an "X is the cause" pattern that was true for v1.x of a library may have been superseded in v2.x. Cite at least one [T1:url] (official docs / changelog / RFC) and confirm with a [T2:url] (community / blog / SO) per S2.
2. T1: For each "because Y" reason in the hypothesis, web search whether Y is still a valid mechanism in the current stack. The LLM may chain a true premise (Y was a cause last year) to a true conclusion (X is broken) but with a now-incorrect causal link. "Process A passes data to Process B via env var" is true in 2024, but if Process B was rewritten in 2025 to read from a config file, the Y-mechanism is broken and the hypothesis is wrong even though both halves are individually true.
3. T1: For the failure class (test failure / build failure / perf regression / integration issue), web search the current "common root causes in 2026" list. The LLM is most likely to lock in the first hypothesis that fits the symptom — including a hypothesis that was a known red herring last year. Confirm your hypothesis is on the current top-N list, not a previously-popular-but-now-debunked cause.
4. Output: log the actual hypothesis text + the cited [T1:url] for the cause + the cited [T1:url] for the mechanism + the "common causes" check to `.superpowers-max/search-log/systematic-debugging-<ts>.md` per OF2. The audit trail must show the hypothesis was searched, not just written down.
</SEARCH_GATE>

   - State clearly: "I think X is the root cause because Y"
   - Write it down
   - Be specific, not vague

2. **Test Minimally**
   - Make the SMALLEST possible change to test hypothesis
   - One variable at a time
   - Don't fix multiple things at once

3. **Verify Before Continuing**

<SEARCH_GATE step="the-bug-is" triggers="T1,T4">
Before writing, stating, or acting on "the bug is X" (i.e., before moving from hypothesis to Phase 4 implementation), you MUST:
1. T1: For the confirmed cause X, web search the current authoritative mechanism one final time. By the time the LLM is at "the bug is", it has high confidence — and high confidence is exactly when the LLM most commonly skips the search it should have done at "form-hypothesis". A new minor release of the library may have shipped since your earlier search, or a new SO answer may have surfaced a counter-example. Re-confirm with at least one [T1:url] (current as of 2026) per S2.
2. T1: For the test that "passes now" (Phase 3.3 → Phase 4 transition), web search the current best practice for that test type. A test that "passes" can pass for the wrong reason (e.g., test is flaky, mock is too loose, assertion doesn't check the right thing). Search "how to verify a [bug-class] test actually exercises the failure" — a test that passes after a fix without exercising the original failure mode is a false positive and the fix is unverified.
3. T4: "The bug is X" is THE canonical T4 confidence assertion. You are about to commit to a code change as the right answer. LLMs famously over-commit at this step — once a hypothesis is "verified", the LLM stops considering alternatives. Search to falsify: actively look for at least two credible alternative explanations that ALSO fit all the evidence you have. If you find a viable alternative, narrow your confidence or run an additional discriminating test. If you find none, state "the bug is X" with the alternatives considered and ruled out per S4 (negative-evidence).
4. T1: If your verification is based on a "minimal change" (Phase 3.2), check that the minimal change actually exercises the cause. The LLM may have "tested the hypothesis" by tweaking a different variable than the one the hypothesis named. State explicitly which variable the minimal change varied, and confirm it is the variable in your hypothesis.
5. Output: log the re-confirmation queries + the alternative explanations considered + the discriminating-test result to `.superpowers-max/search-log/systematic-debugging-<ts>.md` per OF2. The audit trail must show the T4 falsification was actually performed, not just cited.
</SEARCH_GATE>

   - Did it work? Yes → Phase 4
   - Didn't work? Form NEW hypothesis
   - DON'T add more fixes on top

4. **When You Don't Know**
   - Say "I don't understand X"
   - Don't pretend to know
   - Ask for help
   - Research more

### Phase 4: Implementation

**Fix the root cause, not the symptom:**

1. **Create Failing Test Case**
   - Simplest possible reproduction
   - Automated test if possible
   - One-off test script if no framework
   - MUST have before fixing
   - Use the `superpowers:test-driven-development` skill for writing proper failing tests

2. **Implement Single Fix**

<SEARCH_GATE step="implement-fix" triggers="T1">
Before writing any code change to fix the root cause, you MUST:
1. T1: For the specific fix you are about to implement, web search the current best practice. A "fix" that worked last year may have been superseded by a built-in library feature, a built-in runtime guard, a deprecated API, or a new recommended pattern. The LLM is most likely to implement the fix it "remembers" from training data without checking whether the fix is now the second-best practice. Cite at least one [T1:url] (official docs) and one [T2:url] (community / blog) per S2.
2. T1: For each "X is broken because Y" link in the causal chain, search whether the fix actually addresses Y. A fix that targets a symptom adjacent to Y (e.g., catching the exception instead of preventing the bad value, retrying instead of fixing the underlying race) may "make the test pass" without addressing the root cause. The test passes but the bug recurs under slightly different conditions. Search "fix addresses root cause vs symptom in [bug-class]" to verify the fix is on the right level of the causal chain.
3. T1: For the one-line / one-change discipline, search whether the minimal fix requires a specific surrounding context. A minimal fix that drops a lock may be correct, but may also need a corresponding `defer release()` or `try/finally` to be safe in the current version of the runtime. Verify the fix is complete at the current API surface, not just at the surface the LLM has memorized.
4. Output: log the actual fix diff + the cited [T1:url] for the fix pattern + the cited [T1:url] for "root cause vs symptom" + the surrounding-context check to `.superpowers-max/search-log/systematic-debugging-<ts>.md` per OF2. The audit trail must show the fix was verified as current best practice, not assumed.
</SEARCH_GATE>

   - Address the root cause identified
   - ONE change at a time
   - No "while I'm here" improvements
   - No bundled refactoring

3. **Verify Fix**
   - Test passes now?
   - No other tests broken?
   - Issue actually resolved?
   - Use the `superpowers:verification-before-completion` skill before claiming success

4. **If Fix Doesn't Work**
   - STOP
   - Count: How many fixes have you tried?
   - If < 3: Return to Phase 1, re-analyze with new information
   - **If ≥ 3: STOP and question the architecture (step 5 below)**
   - DON'T attempt Fix #4 without architectural discussion

5. **If 3+ Fixes Failed: Question Architecture**

   **Pattern indicating architectural problem:**
   - Each fix reveals new shared state/coupling/problem in different place
   - Fixes require "massive refactoring" to implement
   - Each fix creates new symptoms elsewhere

   **STOP and question fundamentals:**
   - Is this pattern fundamentally sound?
   - Are we "sticking with it through sheer inertia"?
   - Should we refactor architecture vs. continue fixing symptoms?

   **Discuss with your human partner before attempting more fixes**

   This is NOT a failed hypothesis - this is a wrong architecture.

## Red Flags - STOP and Follow Process

If you catch yourself thinking:
- "Quick fix for now, investigate later"
- "Just try changing X and see if it works"
- "Add multiple changes, run tests"
- "Skip the test, I'll manually verify"
- "It's probably X, let me fix that"
- "I don't fully understand but this might work"
- "Pattern says X but I'll adapt it differently"
- "Here are the main problems: [lists fixes without investigation]"
- Proposing solutions before tracing data flow
- **"One more fix attempt" (when already tried 2+)**
- **Each fix reveals new problem in different place**

**ALL of these mean: STOP. Return to Phase 1.**

**If 3+ fixes failed:** Question the architecture (see Phase 4.5)

## your human partner's Signals You're Doing It Wrong

**Watch for these redirections:**
- "Is that not happening?" - You assumed without verifying
- "Will it show us...?" - You should have added evidence gathering
- "Stop guessing" - You're proposing fixes without understanding
- "Ultra-think this" - Question fundamentals, not just symptoms
- "We're stuck?" (frustrated) - Your approach isn't working

**When you see these:** STOP. Return to Phase 1.

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Issue is simple, don't need process" | Simple issues have root causes too. Process is fast for simple bugs. |
| "Emergency, no time for process" | Systematic debugging is FASTER than guess-and-check thrashing. |
| "Just try this first, then investigate" | First fix sets the pattern. Do it right from the start. |
| "I'll write test after confirming fix works" | Untested fixes don't stick. Test first proves it. |
| "Multiple fixes at once saves time" | Can't isolate what worked. Causes new bugs. |
| "Reference too long, I'll adapt the pattern" | Partial understanding guarantees bugs. Read it completely. |
| "I see the problem, let me fix it" | Seeing symptoms ≠ understanding root cause. |
| "One more fix attempt" (after 2+ failures) | 3+ failures = architectural problem. Question pattern, don't fix again. |

## Quick Reference

| Phase | Key Activities | Success Criteria |
|-------|---------------|------------------|
| **1. Root Cause** | Read errors, reproduce, check changes, gather evidence | Understand WHAT and WHY |
| **2. Pattern** | Find working examples, compare | Identify differences |
| **3. Hypothesis** | Form theory, test minimally | Confirmed or new hypothesis |
| **4. Implementation** | Create test, fix, verify | Bug resolved, tests pass |

## When Process Reveals "No Root Cause"

<SEARCH_GATE step="no-root-cause" triggers="T1">
Before claiming "there is no root cause" or "this is truly environmental / timing-dependent / external", you MUST:
1. T1: For the specific "no root cause" class (environmental / timing-dependent / external), web search the current authoritative 2026 view. The 95% claim in the upstream skill is a heuristic; the current best practice for distinguishing "truly external" from "incomplete investigation" has been refined by post-mortem studies from major SRE orgs. The bar for "no root cause" should be the current 2026 bar, not a bar the LLM internalized from training data. Cite at least one [T1:url] (SRE post-mortem / industry study) per S2.
2. T1: For each "I investigated X" claim (e.g., "I checked the network", "I checked the clock skew", "I checked the upstream API"), web search what the current 2026 investigation protocol for that class is. The LLM may have "checked X" via a method that is no longer considered sufficient — e.g., a `ping` test for a flaky network failure, a single-run timing check for a race condition. If the method is below the current bar, the "no root cause" claim is unsupported and Phase 1 must continue.
3. T1: For the proposed handling (retry / timeout / error message / monitoring), web search the current best practice for that pattern. A retry without exponential backoff, a timeout without a corresponding budget, an error message without actionable guidance, a monitoring metric without an alert — each is a known anti-pattern in 2026 that the LLM may implement by default. Search the official docs for the library/framework to confirm the current recommended pattern.
4. Output: log the actual investigation commands + the cited [T1:url] for the 2026 bar + the cited [T1:url] for the proposed handling pattern to `.superpowers-max/search-log/systematic-debugging-<ts>.md` per OF2. The audit trail must show the "no root cause" claim was tested against the current 2026 bar, not a stale bar. If the audit trail is incomplete, the claim is [UNVERIFIED] and Phase 1 must continue.
</SEARCH_GATE>

If systematic investigation reveals issue is truly environmental, timing-dependent, or external:

1. You've completed the process
2. Document what you investigated
3. Implement appropriate handling (retry, timeout, error message)
4. Add monitoring/logging for future investigation

**But:** 95% of "no root cause" cases are incomplete investigation.

## Supporting Techniques

These techniques are part of systematic debugging and available in this directory:

- **`root-cause-tracing.md`** - Trace bugs backward through call stack to find original trigger
- **`defense-in-depth.md`** - Add validation at multiple layers after finding root cause
- **`condition-based-waiting.md`** - Replace arbitrary timeouts with condition polling
