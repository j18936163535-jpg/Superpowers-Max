---
name: receiving-code-review
description: Use when receiving code review feedback, before implementing suggestions, especially if feedback seems unclear or technically questionable - requires technical rigor and verification, not performative agreement or blind implementation; enforces web search discipline to verify each reviewer's technical claim and to falsify the LLM's own "the reviewer is wrong" or "this is the right approach" confidence assertion before any pushback or implementation
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

# Code Review Reception

## Overview

Code review requires technical evaluation, not emotional performance.

**Core principle:** Verify before implementing. Ask before assuming. Technical correctness over social comfort.

## The Response Pattern

<SEARCH_GATE step="verify-pattern" triggers="T1,T4">
Before executing step 3 (VERIFY) on any review comment, you MUST:
1. T1: For every technical claim in the review (e.g., "this API is deprecated", "X is a Yagni", "this is insecure", "this pattern causes performance issues"), web search the current state of the claim. The reviewer's knowledge may be stale — APIs that were deprecated last year may have been un-deprecated, "best practices" shift between major versions, and security guidance is updated frequently. Cite at least one [T1:url] (official docs / RFC) and confirm with a [T2:url] (community / blog) per S2.
2. T1: Read the actual referenced code, file, or output the reviewer is commenting on — not a paraphrase from the prompt. The reviewer's claim may describe a different file, a different function, or a different behavior than what's actually in the repo. `git grep` / `cat` / `read` first; verify the reviewer's description matches reality before you evaluate it.
3. T4: Evaluating "is this technically correct for THIS codebase?" is the canonical confidence assertion. You are about to say "the reviewer is right" or "the reviewer is wrong". Search to falsify: actively look for at least one credible reason the reviewer MIGHT be right (even if your first instinct disagrees). If you find one, narrow your pushback. If you find none, state the pushback with that negative-evidence noted per S4.
4. Output: log the queries + the actual file/line evidence + the falsification check to `.superpowers-max/search-log/receiving-code-review-<ts>.md` per OF2. The audit trail must be reproducible from the log alone.
</SEARCH_GATE>

```
WHEN receiving code review feedback:

1. READ: Complete feedback without reacting
2. UNDERSTAND: Restate requirement in own words (or ask)
3. VERIFY: Check against codebase reality
4. EVALUATE: Technically sound for THIS codebase?
5. RESPOND: Technical acknowledgment or reasoned pushback
6. IMPLEMENT: One item at a time, test each
```

## Forbidden Responses

**NEVER:**
- "You're absolutely right!" (explicit instruction-file violation)
- "Great point!" / "Excellent feedback!" (performative)
- "Let me implement that now" (before verification)

**INSTEAD:**
- Restate the technical requirement
- Ask clarifying questions
- Push back with technical reasoning if wrong
- Just start working (actions > words)

## Handling Unclear Feedback

<SEARCH_GATE step="clarify-first" triggers="T1">
Before deciding an item is "clear enough to implement" without asking, you MUST:
1. T1: For any term, API name, error string, or concept in the review that you do not have authoritative knowledge of (e.g., a specific function name, an error code, a config key, a library module), web search the official docs to confirm what it actually is. The LLM is most likely to silently mis-implement a request whose terms it "recognizes" but does not truly understand. Cite at least one [T1:url] per S2.
2. T1: Check whether the reviewer's item references a file, line, or symbol that exists in the current codebase. A vague reference ("the auth handler") may map to one of several files; a specific one ("the validateToken function in src/auth.ts:42") can be confirmed. `git grep` or `grep` first. If you cannot locate it, that itself is a reason to ask.
3. T1: If the reviewer's item is part of a numbered list ("Fix 1-6"), confirm you understand each item by restating it. The upstream rule ("Items may be related. Partial understanding = wrong implementation") is a real risk — a confidently-implemented 1,2,3,6 can conflict with the still-unclear 4,5, forcing a revert. If you cannot restate each item, ask.
4. Output: log the restated items + any unresolved references to `.superpowers-max/search-log/receiving-code-review-<ts>.md` per OF2. If you proceed to implement, the log must show each item has an evidence-backed restatement.
</SEARCH_GATE>

```
IF any item is unclear:
  STOP - do not implement anything yet
  ASK for clarification on unclear items

WHY: Items may be related. Partial understanding = wrong implementation.
```

**Example:**
```
your human partner: "Fix 1-6"
You understand 1,2,3,6. Unclear on 4,5.

❌ WRONG: Implement 1,2,3,6 now, ask about 4,5 later
✅ RIGHT: "I understand items 1,2,3,6. Need clarification on 4 and 5 before proceeding."
```

## Source-Specific Handling

### From your human partner
- **Trusted** - implement after understanding
- **Still ask** if scope unclear
- **No performative agreement**
- **Skip to action** or technical acknowledgment

### From External Reviewers
```
BEFORE implementing:
  1. Check: Technically correct for THIS codebase?
  2. Check: Breaks existing functionality?
  3. Check: Reason for current implementation?
  4. Check: Works on all platforms/versions?
  5. Check: Does reviewer understand full context?

IF suggestion seems wrong:
  Push back with technical reasoning

IF can't easily verify:
  Say so: "I can't verify this without [X]. Should I [investigate/ask/proceed]?"

IF conflicts with your human partner's prior decisions:
  Stop and discuss with your human partner first
```

**your human partner's rule:** "External feedback - be skeptical, but check carefully"

## YAGNI Check for "Professional" Features

<SEARCH_GATE step="yagni-check" triggers="T1,T4">
Before claiming a feature is "unused" and proposing removal (YAGNI), you MUST:
1. T1: Beyond the obvious `grep` for direct callers, search for indirect usage patterns: dynamic dispatch (string-based method names, reflection), config files that reference the feature, build-time code generation that emits callers, plugin/extension systems, and the test suite. A "zero grep hits" result is a strong signal but is not proof — code can call a function via `getattr`, `eval`, RPC over the network, or external scripts. Web search "feature flag runtime lookup" or "dynamic dispatch patterns in [language]" if the codebase is unfamiliar. Cite per S2.
2. T1: Check git history (`git log --all -- <file>` and `git log -S<string>`) for past usage, recent removal, or pending work. A feature may be "currently unused" but on an active branch, a planned release, or a recently-removed-but-restored path. The grep snapshot is one moment in time; git history is the full timeline.
3. T4: Claiming "this feature is unused" is a confidence assertion that, if wrong, causes a real regression (the reviewer is right, the LLM deleted live code). Search to falsify: consider whether the LLM is pattern-matching to a generic YAGNI heuristic and applying it without considering the project's specific architecture. If the feature is part of a public API, a documented contract, or a third-party integration surface, it cannot be removed by grep alone.
4. Output: log the actual grep command + result + indirect-usage check + git-history check to `.superpowers-max/search-log/receiving-code-review-<ts>.md` per OF2. If you propose removal, the log must show you searched for indirect usage and didn't find it. If the log is incomplete, the removal is [UNVERIFIED].
</SEARCH_GATE>

```
IF reviewer suggests "implementing properly":
  grep codebase for actual usage

  IF unused: "This endpoint isn't called. Remove it (YAGNI)?"
  IF used: Then implement properly
```

**your human partner's rule:** "You and reviewer both report to me. If we don't need this feature, don't add it."

## Implementation Order

<SEARCH_GATE step="implementation-order" triggers="T1">
Before classifying any review comment as "blocking" / "simple" / "complex" and choosing the order to implement, you MUST:
1. T1: For any "blocking" classification (e.g., "this is a security issue", "this breaks CI", "this causes data loss"), web search the current authoritative definition of the severity. What counts as "blocking" shifts between orgs, between release stages, and between regulatory regimes. The LLM may down-classify a security issue as "simple" because the fix is small, when the impact warrants immediate escalation. Cite per S2.
2. T1: Confirm the classification by inspecting the actual code path the reviewer pointed at. A "blocking" classification that depends on a specific runtime config, a specific deployment target, or a specific data shape may not generalize. If the reviewer claimed "breaks on Python 3.12", confirm Python 3.12 is actually in the project's supported versions (read pyproject.toml / setup.py / CI matrix) before treating the fix as blocking.
3. T1: Verify the order does not introduce regressions. "Test each fix individually" assumes the fixes are independent — for multi-item feedback where items touch the same file or the same subsystem, a fix-by-fix order can produce intermediate broken states. Web search "incremental refactor regression risk" for the language/framework if the items are non-independent. State the dependency explicitly.
4. Output: log the actual severity classification + the supporting evidence for each item to `.superpowers-max/search-log/receiving-code-review-<ts>.md` per OF2. If a "blocking" classification is unsupported, downgrade to "complex" with the reasoning.
</SEARCH_GATE>

```
FOR multi-item feedback:
  1. Clarify anything unclear FIRST
  2. Then implement in this order:
     - Blocking issues (breaks, security)
     - Simple fixes (typos, imports)
     - Complex fixes (refactoring, logic)
  3. Test each fix individually
  4. Verify no regressions
```

## When To Push Back

<SEARCH_GATE step="pushback-judgment" triggers="T1,T4">
Before stating "the reviewer is wrong" or pushing back on any review comment, you MUST:
1. T1: For every technical reason in the pushback (e.g., "this breaks X", "this is Yagni", "this is technically incorrect for this stack", "this conflicts with legacy"), web search the current authoritative source. The reviewer's reasoning may itself be based on a stale claim, and your pushback may be based on a stale rebuttal. Cite at least one [T1:url] (official docs / RFC / spec) per S2. If the pushback is about a library's behavior, the library's CHANGELOG / release notes are T1.
2. T1: Confirm the pushback's factual premise by inspecting the actual codebase. "This breaks existing functionality" requires identifying the specific functionality, the specific break, and the test that demonstrates it. "Reviewer lacks full context" requires pointing to the missing context. A pushback without a verified premise is just opinion, and opinion is not a technical reason.
3. T4: This is the canonical T4 confidence assertion. You are about to say "the reviewer is wrong". LLMs famously over-pushback — they confidently assert the reviewer is wrong because the LLM "knows" the codebase, while missing that the reviewer has reviewed the same code with a different lens (security, performance, future maintainability, cross-team consistency). Search to falsify: actively consider at least two reasons the reviewer MIGHT be right (even if your first instinct disagrees). If you find none, state the pushback with that negative-evidence noted per S4.
4. T1: If the pushback would conflict with the human partner's prior decisions, stop and discuss with the human partner first per the "Source-Specific Handling" rule — this is a non-negotiable escalation. Do not push back on a reviewer when the human partner has already decided the same question.
5. Output: log the queries + the verified premise + the falsification check to `.superpowers-max/search-log/receiving-code-review-<ts>.md` per OF2. The pushback text sent to the reviewer must reference evidence, not opinion.
</SEARCH_GATE>

Push back when:
- Suggestion breaks existing functionality
- Reviewer lacks full context
- Violates YAGNI (unused feature)
- Technically incorrect for this stack
- Legacy/compatibility reasons exist
- Conflicts with your human partner's architectural decisions

**How to push back:**
- Use technical reasoning, not defensiveness
- Ask specific questions
- Reference working tests/code
- Involve your human partner if architectural

**If you're uncomfortable pushing back out loud:** Name that tension, then tell your partner about the issue you've seen. They'll appreciate your honesty.

## Acknowledging Correct Feedback

<SEARCH_GATE step="implement-feedback" triggers="T1,T4">
Before implementing any review comment as "correct" and writing the fix, you MUST:
1. T1: Web search the current best practice for the fix the reviewer is suggesting. The reviewer's suggestion may itself be a 2018 pattern that has since been superseded (e.g., "use `request.get()` not `requests.get()`" — was that always wrong? was the reviewer's correction itself based on stale knowledge?). For each suggested fix, confirm it is the current 2026 best practice via [T1:url] (official docs) + [T2:url] (community / blog) per S2.
2. T1: For each suggested fix, web search for the current alternative approaches and any "don't do this" guidance. A reviewer may suggest a fix that is technically correct but is now the second-best practice; the LLM should not implement a known-obsolete pattern without flagging it. Example: reviewer says "use Promise.then()" when async/await is now universally preferred; the LLM should implement async/await AND mention the reviewer's suggestion is the older pattern.
3. T1: Confirm the fix passes the project's actual test suite after implementation. "Fixed" without a test run is the same as "should be fixed" — the upstream skill explicitly bans that pattern. Cite the actual command + actual exit code + actual test count.
4. T4: Claiming "this is the right approach" is the canonical T4 confidence assertion. You are about to commit to a code change as the right answer. Search to falsify: consider whether the fix is the smallest viable change (per the upstream rule "Just fix it and show in the code") or whether the LLM is about to over-engineer (adding abstractions, comments, refactors) that the reviewer did not request. Over-implementation is also a form of not listening to the review.
5. Output: log the queries + the actual fix diff + the actual test run result to `.superpowers-max/search-log/receiving-code-review-<ts>.md` per OF2. The audit trail must show the fix was verified, not assumed.
</SEARCH_GATE>

When feedback IS correct:
```
✅ "Fixed. [Brief description of what changed]"
✅ "Good catch - [specific issue]. Fixed in [location]."
✅ [Just fix it and show in the code]

❌ "You're absolutely right!"
❌ "Great point!"
❌ "Thanks for catching that!"
❌ "Thanks for [anything]"
❌ ANY gratitude expression
```

**Why no thanks:** Actions speak. Just fix it. The code itself shows you heard the feedback.

**If you catch yourself about to write "Thanks":** DELETE IT. State the fix instead.

## Gracefully Correcting Your Pushback

<SEARCH_GATE step="self-correct" triggers="T4">
Before stating "I was wrong about the pushback" and accepting the reviewer's correction, you MUST:
1. T4: Self-correction is the canonical T4 confidence assertion. You are about to reverse your prior position. LLMs famously under-correct — once they have committed to a pushback, they tend to defend it even when presented with counter-evidence. Search to falsify your own pushback: actively look for at least two specific reasons the reviewer MIGHT be right (re-read the reviewer's claim, the codebase state, the docs, recent commits). If you find none, do not flip — your original pushback stands. If you find evidence, state it factually and accept.
2. T1: Web search the technical claim you originally rejected. The reviewer may have been correct AND you may have been wrong about a fact that has since changed (e.g., you said "this API is stable" and the API was actually deprecated last month). Cite the new evidence per S2.
3. T1: Distinguish "I was wrong about a fact" from "I was wrong about an interpretation". A factual reversal is a clean flip; an interpretation reversal may still warrant partial pushback. State which type of reversal you are making — the reviewer (and the audit log) deserve the distinction.
4. Output: log the new evidence + the type of reversal to `.superpowers-max/search-log/receiving-code-review-<ts>.md` per OF2. A self-correction without evidence is just capitulation, not learning.
</SEARCH_GATE>

If you pushed back and were wrong:
```
✅ "You were right - I checked [X] and it does [Y]. Implementing now."
✅ "Verified this and you're correct. My initial understanding was wrong because [reason]. Fixing."

❌ Long apology
❌ Defending why you pushed back
❌ Over-explaining
```

State the correction factually and move on.

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Performative agreement | State requirement or just act |
| Blind implementation | Verify against codebase first |
| Batch without testing | One at a time, test each |
| Assuming reviewer is right | Check if breaks things |
| Avoiding pushback | Technical correctness > comfort |
| Partial implementation | Clarify all items first |
| Can't verify, proceed anyway | State limitation, ask for direction |

## Real Examples

**Performative Agreement (Bad):**
```
Reviewer: "Remove legacy code"
❌ "You're absolutely right! Let me remove that..."
```

**Technical Verification (Good):**
```
Reviewer: "Remove legacy code"
✅ "Checking... build target is 10.15+, this API needs 13+. Need legacy for backward compat. Current impl has wrong bundle ID - fix it or drop pre-13 support?"
```

**YAGNI (Good):**
```
Reviewer: "Implement proper metrics tracking with database, date filters, CSV export"
✅ "Grepped codebase - nothing calls this endpoint. Remove it (YAGNI)? Or is there usage I'm missing?"
```

**Unclear Item (Good):**
```
your human partner: "Fix items 1-6"
You understand 1,2,3,6. Unclear on 4,5.
✅ "Understand 1,2,3,6. Need clarification on 4 and 5 before implementing."
```

## GitHub Thread Replies

When replying to inline review comments on GitHub, reply in the comment thread (`gh api repos/{owner}/{repo}/pulls/{pr}/comments/{id}/replies`), not as a top-level PR comment.
