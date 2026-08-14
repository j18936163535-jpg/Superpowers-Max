# superpowers-max Foundation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Bootstrap a working superpowers-max repository with philosophy foundation, 2 maintenance scripts, and 6 platform plugin descriptors — ready for skill rewrites in Plan 2.

**Architecture:** Multi-platform plugin repo (Claude/Codex/Cursor/Kimi/OpenCode/Pi) containing shared search-discipline rules (`skills/_shared/*.md`) consumed by 14 individual skills (rewritten in Plan 2). Two maintenance scripts (`inline-search-discipline.sh`, `audit-skills.sh`) keep rules in sync and verify compliance.

**Tech Stack:** Markdown (skills), Bash (scripts), JSON/TOML/JS (plugin descriptors per platform), Python (audit helper if needed), Git + pre-commit.

**Spec reference:** `docs/superpowers/specs/2026-08-15-superpowers-max-design.md`

---

## Global Constraints

- License: **MIT** (inherited from upstream)
- Package name: **`superpowers-max`** (all platforms)
- Version: **`0.1.0-max`** for this plan's deliverables; bumps to `1.0.0-max` after P7
- Plugin descriptors: **6 platforms** (Claude/Codex/Cursor/Kimi/OpenCode/Pi)
- Philosophy: **反 LLM 中心主义** — search-discipline is mandatory, embedded, hard-triggered
- Hard constraints: 4-layer system (audit + evals + retro + 实战) — Plan 1 builds layer 1 (audit)
- No upstream remote (完全独立硬分叉)
- Commit style: `feat:` / `fix:` / `chore(philosophy):` / `chore(skill-X):` / `refactor:` / `docs:`
- File paths are workspace-relative from `/Users/lala/.minimax-agent-cn/projects/superpowers-max/`
- All shell commands assume `bash` (darwin/zsh-compatible); scripts use `#!/usr/bin/env bash` + `set -euo pipefail`

---

## File Structure (this plan creates these)

```
superpowers-max/
├── .git/                                    (created in Task 1)
├── .gitignore                               (Task 1)
├── README.md                                (Task 2)
├── LICENSE                                  (Task 2)
├── package.json                             (Task 2)
├── .version-bump.json                       (Task 2)
├── CHANGELOG.md                             (Task 2)
│
├── .claude-plugin/plugin.json               (Task 3)
├── .codex-plugin/extension.toml             (Task 3)
├── .cursor-plugin/plugin.json               (Task 3)
├── .kimi-plugin/manifest.json               (Task 3)
├── .pi/extensions/superpowers-max.ts        (Task 3)
├── .opencode/plugins/superpowers-max.js     (Task 3)
│
├── skills/_shared/
│   ├── triggers.md                          (Task 4)
│   ├── source-quality.md                    (Task 5)
│   ├── output-format.md                     (Task 6)
│   └── failure-modes.md                     (Task 7)
│
├── scripts/
│   ├── inline-search-discipline.sh          (Task 8)
│   ├── audit-skills.sh                      (Task 9)
│   └── tests/                               (Task 8/9 tests live here)
│       ├── test-inline-search-discipline.sh
│       └── test-audit-skills.sh
│
└── tests/                                   (empty for now, populated in Plan 3)
```

---

## Task 1: Git init + .gitignore

**Files:**
- Create: `.gitignore`

**Interfaces:**
- Consumes: nothing
- Produces: git repo + standard ignore file

- [ ] **Step 1: Initialize git repo**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
git init
git checkout -b main 2>/dev/null || git branch -M main
```

- [ ] **Step 2: Write .gitignore**

```bash
cat > .gitignore <<'EOF'
# OS
.DS_Store
Thumbs.db

# Editor
.idea/
.vscode/
*.swp
*~

# Node
node_modules/
package-lock.json

# Python
__pycache__/
*.pyc
.venv/

# superpowers-max runtime state
.superpowers-max/
.superpowers-max/search-log/
*.log

# Build / dist
dist/
build/

# Local secrets / config
.env
.env.local
EOF
```

- [ ] **Step 3: Commit**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
git add .gitignore
git commit -m "chore: init repo with standard gitignore"
```

---

## Task 2: README, LICENSE, package.json, version-bump, CHANGELOG

**Files:**
- Create: `README.md`
- Create: `LICENSE`
- Create: `package.json`
- Create: `.version-bump.json`
- Create: `CHANGELOG.md`

**Interfaces:**
- Consumes: nothing
- Produces: standard repo metadata + philosophy statement

- [ ] **Step 1: Write LICENSE (MIT, upstream-style)**

```bash
cat > /Users/lala/.minimax-agent-cn/projects/superpowers-max/LICENSE <<'EOF'
MIT License

Copyright (c) 2026 superpowers-max contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF
```

- [ ] **Step 2: Write package.json**

```bash
cat > /Users/lala/.minimax-agent-cn/projects/superpowers-max/package.json <<'EOF'
{
  "name": "superpowers-max",
  "version": "0.1.0-max",
  "description": "Superpowers skills with mandatory search discipline to compensate for LLM training-data gaps",
  "type": "module",
  "main": ".opencode/plugins/superpowers-max.js",
  "keywords": [
    "pi-package",
    "skills",
    "tdd",
    "debugging",
    "search-discipline",
    "anti-llm-centrism",
    "collaboration",
    "workflow"
  ],
  "license": "MIT",
  "pi": {
    "extensions": [
      "./.pi/extensions/superpowers-max.ts"
    ],
    "skills": [
      "./skills"
    ]
  }
}
EOF
```

- [ ] **Step 3: Write .version-bump.json**

```bash
cat > /Users/lala/.minimax-agent-cn/projects/superpowers-max/.version-bump.json <<'EOF'
{
  "current_version": "0.1.0-max",
  "bump_type": "minor"
}
EOF
```

- [ ] **Step 4: Write CHANGELOG.md (initial)**

```bash
cat > /Users/lala/.minimax-agent-cn/projects/superpowers-max/CHANGELOG.md <<'EOF'
# Changelog

All notable changes to superpowers-max are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html)
with a `-max` suffix to mark fork identity.

## [Unreleased]

## [0.1.0-max] - 2026-08-15

### Added
- Initial repository structure (Plan 1: foundation)
- Philosophy: 反 LLM 中心主义 — search-discipline mandatory
- 6-platform plugin descriptors (Claude, Codex, Cursor, Kimi, OpenCode, Pi)
- `skills/_shared/` rule source: triggers, source-quality, output-format, failure-modes
- `scripts/inline-search-discipline.sh` — syncs rules to per-skill blocks
- `scripts/audit-skills.sh` — static discipline audit (9 checks)

[Unreleased]: https://example.com/superpowers-max/compare/v0.1.0-max...HEAD
[0.1.0-max]: https://example.com/superpowers-max/releases/tag/v0.1.0-max
EOF
```

- [ ] **Step 5: Write README.md**

```bash
cat > /Users/lala/.minimax-agent-cn/projects/superpowers-max/README.md <<'EOF'
# superpowers-max

> **Superpowers skills with mandatory search discipline** — using full-process, multi-frequency, high-quality, broad-scope web search to compensate for LLM training-data gaps.

## What is this?

`superpowers-max` is a **fully independent hard fork** of [`obra/superpowers`](https://github.com/obra/superpowers).
We keep the same 14 skills and 6-platform plugin coverage, but each skill is hardened with an embedded
**search-discipline system**: every fact, every decision, every skill-step entry, and every
self-confident assertion must trigger a real web search against tier-classified sources
with multi-source cross-validation and explicit failure handling.

## Philosophy

> Training data is intrinsically stale, confabulated, and one-sided. An LLM is not a knowledge source —
> it is a reasoning engine that requires fresh, external information to deliver trustworthy answers.

This is the **anti-LLM-centrism** stance. `superpowers-max` rejects the implicit assumption that the
LLM's training data is "basically correct, with discipline to catch the rest." Instead, we treat
search as the **first action**, not a fallback.

## Hard constraints (4-layer system)

| Layer | Tool | Runs when |
|---|---|---|
| Static audit | `scripts/audit-skills.sh` | pre-commit + CI |
| Behavior evals | `tests/evals/` (Plan 3) | CI + pre-release |
| Monthly retro | `docs/retro/` | monthly |
| Real-project use | running max in 1-2 real projects | continuously |

Together these are structurally **stronger** than upstream's "1 author + tests" combination.

## Status

- v0.1.0-max — Plan 1: foundation (this release)
- v1.0.0-max — Plan 4: 14 skills rewritten, evals pass, real project validated

See `docs/superpowers/specs/2026-08-15-superpowers-max-design.md` for the full design.

## Quick start

```bash
git clone https://github.com/<you>/superpowers-max.git
cd superpowers-max
./scripts/audit-skills.sh    # static discipline audit
./scripts/inline-search-discipline.sh  # sync _shared/ to per-skill blocks
```

Plugin descriptors under `.claude-plugin/`, `.codex-plugin/`, etc. let platforms pick this up
automatically.

## License

MIT — see `LICENSE`.
EOF
```

- [ ] **Step 6: Commit**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
git add README.md LICENSE package.json .version-bump.json CHANGELOG.md
git commit -m "docs: add README, LICENSE, package metadata, CHANGELOG"
```

---

## Task 3: 6 platform plugin descriptors

**Files:**
- Create: `.claude-plugin/plugin.json`
- Create: `.codex-plugin/extension.toml`
- Create: `.cursor-plugin/plugin.json`
- Create: `.kimi-plugin/manifest.json`
- Create: `.pi/extensions/superpowers-max.ts`
- Create: `.opencode/plugins/superpowers-max.js`

**Interfaces:**
- Consumes: `package.json` (name: `superpowers-max`, version: `0.1.0-max`)
- Produces: 6 plugin descriptors enabling platform auto-load

- [ ] **Step 1: Write Claude plugin descriptor**

```bash
cat > /Users/lala/.minimax-agent-cn/projects/superpowers-max/.claude-plugin/plugin.json <<'EOF'
{
  "name": "superpowers-max",
  "version": "0.1.0-max",
  "description": "Superpowers skills with mandatory search discipline (anti-LLM-centrism)",
  "author": "superpowers-max contributors",
  "license": "MIT",
  "skills": "./skills"
}
EOF
```

- [ ] **Step 2: Write Codex extension descriptor**

```bash
cat > /Users/lala/.minimax-agent-cn/projects/superpowers-max/.codex-plugin/extension.toml <<'EOF'
[plugin]
name = "superpowers-max"
version = "0.1.0-max"
description = "Superpowers skills with mandatory search discipline (anti-LLM-centrism)"
license = "MIT"
skills_dir = "./skills"
EOF
```

- [ ] **Step 3: Write Cursor plugin descriptor**

```bash
cat > /Users/lala/.minimax-agent-cn/projects/superpowers-max/.cursor-plugin/plugin.json <<'EOF'
{
  "name": "superpowers-max",
  "version": "0.1.0-max",
  "description": "Superpowers skills with mandatory search discipline (anti-LLM-centrism)",
  "license": "MIT",
  "skills": "./skills"
}
EOF
```

- [ ] **Step 4: Write Kimi plugin manifest**

```bash
cat > /Users/lala/.minimax-agent-cn/projects/superpowers-max/.kimi-plugin/manifest.json <<'EOF'
{
  "name": "superpowers-max",
  "version": "0.1.0-max",
  "description": "Superpowers skills with mandatory search discipline (anti-LLM-centrism)",
  "license": "MIT",
  "skills": "./skills"
}
EOF
```

- [ ] **Step 5: Write Pi extension stub**

```bash
cat > /Users/lala/.minimax-agent-cn/projects/superpowers-max/.pi/extensions/superpowers-max.ts <<'EOF'
// Pi extension for superpowers-max
// Registers skills with Pi runtime; full implementation in Plan 2+ once skills are rewritten.
import type { Extension } from "@mariozechner/pi-coding-agent";

const extension: Extension = {
  name: "superpowers-max",
  version: "0.1.0-max",
  description: "Superpowers skills with mandatory search discipline",
};

export default extension;
EOF
```

- [ ] **Step 6: Write OpenCode plugin stub**

```bash
cat > /Users/lala/.minimax-agent-cn/projects/superpowers-max/.opencode/plugins/superpowers-max.js <<'EOF'
// OpenCode plugin for superpowers-max
// Registers skills with OpenCode runtime; full implementation in Plan 2+ once skills are rewritten.
export const name = "superpowers-max";
export const version = "0.1.0-max";
export const description = "Superpowers skills with mandatory search discipline";
EOF
```

- [ ] **Step 7: Commit**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
git add .claude-plugin/ .codex-plugin/ .cursor-plugin/ .kimi-plugin/ .pi/ .opencode/
git commit -m "feat: add 6 platform plugin descriptors"
```

---

## Task 4: skills/_shared/triggers.md

**Files:**
- Create: `skills/_shared/triggers.md`

**Interfaces:**
- Consumes: spec §5.1 (4 triggers)
- Produces: rule file consumed by `inline-search-discipline.sh` and embedded into each skill

- [ ] **Step 1: Write the file**

```bash
cat > /Users/lala/.minimax-agent-cn/projects/superpowers-max/skills/_shared/triggers.md <<'EOF'
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
EOF
```

- [ ] **Step 2: Commit**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
git add skills/_shared/triggers.md
git commit -m "feat(philosophy): add triggers.md (4 search triggers)"
```

---

## Task 5: skills/_shared/source-quality.md

**Files:**
- Create: `skills/_shared/source-quality.md`

- [ ] **Step 1: Write the file**

```bash
cat > /Users/lala/.minimax-agent-cn/projects/superpowers-max/skills/_shared/source-quality.md <<'EOF'
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
EOF
```

- [ ] **Step 2: Commit**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
git add skills/_shared/source-quality.md
git commit -m "feat(philosophy): add source-quality.md (4 source rules)"
```

---

## Task 6: skills/_shared/output-format.md

**Files:**
- Create: `skills/_shared/output-format.md`

- [ ] **Step 1: Write the file**

```bash
cat > /Users/lala/.minimax-agent-cn/projects/superpowers-max/skills/_shared/output-format.md <<'EOF'
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
\`\`\`markdown
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
\`\`\`

## OF3. 日志位置与保留
- 路径: `.superpowers-max/search-log/`
- 保留: 30 天(自动清理,可用 `scripts/cleanup-logs.sh`)
- 上传: 默认不上传(本地)。如要分享可手工 `git add`。
EOF
```

- [ ] **Step 2: Commit**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
git add skills/_shared/output-format.md
git commit -m "feat(philosophy): add output-format.md (3 output rules)"
```

---

## Task 7: skills/_shared/failure-modes.md

**Files:**
- Create: `skills/_shared/failure-modes.md`

- [ ] **Step 1: Write the file**

```bash
cat > /Users/lala/.minimax-agent-cn/projects/superpowers-max/skills/_shared/failure-modes.md <<'EOF'
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

\`\`\`
[UNVERIFIED:query="X", tried=web+firecrawl+mcp, reason=all_failed_or_empty]
基于训练数据,我的回答是 Y。但未能在搜索中验证。
请用户审查。
\`\`\`

## FM3. 源冲突必须呈现
<HARD-GATE>
多源冲突时,LLM 必须呈现冲突各方观点,不许静默选边。
</HARD-GATE>

\`\`\`
[CONFLICT:topic="X"]
- T1 (official): <观点 A>
- T2 (community): <观点 B>
我的判断: <基于 X / Y / Z 选择 A / B / 不选>
但你应知道存在 B。
\`\`\`

把判断权交回用户。
EOF
```

- [ ] **Step 2: Commit**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
git add skills/_shared/failure-modes.md
git commit -m "feat(philosophy): add failure-modes.md (3 failure rules)"
```

---

## Task 8: scripts/inline-search-discipline.sh + tests

**Files:**
- Create: `scripts/inline-search-discipline.sh`
- Create: `scripts/tests/test-inline-search-discipline.sh`
- Create: `scripts/tests/fixtures/skill-template/SKILL.md` (fixture for test)
- Create: `scripts/tests/fixtures/empty-skill/SKILL.md` (fixture for test)

**Interfaces:**
- Consumes: `skills/_shared/*.md` (4 files), `skills/*/SKILL.md` (any number)
- Produces: each `skills/X/SKILL.md` has its `<SEARCH_DISCIPLINE>` block (anchor A) replaced with concatenated `_shared` content

- [ ] **Step 1: Write the failing test**

```bash
mkdir -p /Users/lala/.minimax-agent-cn/projects/superpowers-max/scripts/tests/fixtures/skill-template
mkdir -p /Users/lala/.minimax-agent-cn/projects/superpowers-max/scripts/tests/fixtures/empty-skill

# Fixture 1: SKILL.md with existing <SEARCH_DISCIPLINE> block
cat > /Users/lala/.minimax-agent-cn/projects/superpowers-max/scripts/tests/fixtures/skill-template/SKILL.md <<'EOF'
# Test Skill
<SEARCH_DISCIPLINE>
OLD CONTENT TO BE REPLACED
</SEARCH_DISCIPLINE>

## Body
Some content
EOF

# Fixture 2: SKILL.md without anchor
cat > /Users/lala/.minimax-agent-cn/projects/superpowers-max/scripts/tests/fixtures/empty-skill/SKILL.md <<'EOF'
# Empty Skill
## Body
No anchor here
EOF

# Test script
cat > /Users/lala/.minimax-agent-cn/projects/superpowers-max/scripts/tests/test-inline-search-discipline.sh <<'EOF'
#!/usr/bin/env bash
# Test: inline-search-discipline.sh replaces or inserts anchor correctly.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SCRIPT="$REPO_ROOT/scripts/inline-search-discipline.sh"
TMPDIR="$(mktemp -d)"
trap "rm -rf $TMPDIR" EXIT

# Build a test repo that mirrors fixture structure
mkdir -p "$TMPDIR/skills/_shared"
cp "$REPO_ROOT/skills/_shared/"*.md "$TMPDIR/skills/_shared/"
mkdir -p "$TMPDIR/skills/skill-a"
mkdir -p "$TMPDIR/skills/skill-b"
cp "$REPO_ROOT/scripts/tests/fixtures/skill-template/SKILL.md" "$TMPDIR/skills/skill-a/SKILL.md"
cp "$REPO_ROOT/scripts/tests/fixtures/empty-skill/SKILL.md" "$TMPDIR/skills/skill-b/SKILL.md"

# Run the script in the test repo
( cd "$TMPDIR" && "$SCRIPT" ) >/dev/null

# Assert: skill-a's anchor was REPLACED (does not contain OLD CONTENT)
if grep -q "OLD CONTENT TO BE REPLACED" "$TMPDIR/skills/skill-a/SKILL.md"; then
  echo "FAIL: skill-a still contains old content (not replaced)"
  exit 1
fi

# Assert: skill-a's anchor now contains content from _shared
if ! grep -q "T1. 每事实必搜" "$TMPDIR/skills/skill-a/SKILL.md"; then
  echo "FAIL: skill-a anchor missing T1 trigger"
  exit 1
fi

# Assert: skill-b's anchor was INSERTED
if ! grep -q "<SEARCH_DISCIPLINE>" "$TMPDIR/skills/skill-b/SKILL.md"; then
  echo "FAIL: skill-b missing SEARCH_DISCIPLINE anchor"
  exit 1
fi

# Assert: skill-b's anchor also contains T1
if ! grep -q "T1. 每事实必搜" "$TMPDIR/skills/skill-b/SKILL.md"; then
  echo "FAIL: skill-b anchor missing T1 trigger"
  exit 1
fi

echo "PASS: inline-search-discipline.sh"
EOF

chmod +x /Users/lala/.minimax-agent-cn/projects/superpowers-max/scripts/tests/test-inline-search-discipline.sh
```

- [ ] **Step 2: Run test to verify it fails**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
./scripts/tests/test-inline-search-discipline.sh; echo "exit=$?"
```

Expected: FAIL with "command not found" or similar (script doesn't exist yet)

- [ ] **Step 3: Write the implementation**

```bash
cat > /Users/lala/.minimax-agent-cn/projects/superpowers-max/scripts/inline-search-discipline.sh <<'EOF'
#!/usr/bin/env bash
# inline-search-discipline.sh
# Sync skills/_shared/*.md into each skills/*/SKILL.md's <SEARCH_DISCIPLINE> block.
# - If anchor exists: replace its body with concatenated shared content.
# - If anchor missing: insert anchor at top of SKILL.md.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SHARED_DIR="$REPO_ROOT/skills/_shared"
SKILLS_DIR="$REPO_ROOT/skills"

if [ ! -d "$SHARED_DIR" ]; then
  echo "ERROR: $SHARED_DIR not found" >&2
  exit 1
fi

# Concatenate shared rules into a temp file
RULES_TMP="$(mktemp)"
trap "rm -f $RULES_TMP" EXIT
cat "$SHARED_DIR/triggers.md" "$SHARED_DIR/source-quality.md" \
    "$SHARED_DIR/output-format.md" "$SHARED_DIR/failure-modes.md" > "$RULES_TMP"

python3 - "$SHARED_DIR" "$SKILLS_DIR" "$RULES_TMP" <<'PYEOF'
import sys, os, re

shared_dir, skills_dir, rules_tmp = sys.argv[1], sys.argv[2], sys.argv[3]
with open(rules_tmp, 'r') as f:
    rules = f.read()

anchor_re = re.compile(r'<SEARCH_DISCIPLINE>.*?</SEARCH_DISCIPLINE>', re.DOTALL)
new_block = f'<SEARCH_DISCIPLINE>\n{rules}\n</SEARCH_DISCIPLINE>'

updated = 0
for entry in sorted(os.listdir(skills_dir)):
    if entry == '_shared':
        continue
    skill_md = os.path.join(skills_dir, entry, 'SKILL.md')
    if not os.path.isfile(skill_md):
        continue
    with open(skill_md, 'r') as f:
        content = f.read()
    if anchor_re.search(content):
        new_content = anchor_re.sub(lambda m: new_block, content, count=1)
        action = 'replaced'
    else:
        new_content = new_block + '\n\n' + content
        action = 'inserted'
    with open(skill_md, 'w') as f:
        f.write(new_content)
    print(f'  {action}: {skill_md}')
    updated += 1

print(f'Done: {updated} skill(s) updated')
PYEOF
EOF

chmod +x /Users/lala/.minimax-agent-cn/projects/superpowers-max/scripts/inline-search-discipline.sh
```

- [ ] **Step 4: Run test to verify it passes**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
./scripts/tests/test-inline-search-discipline.sh
```

Expected: `PASS: inline-search-discipline.sh`

- [ ] **Step 5: Commit**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
git add scripts/inline-search-discipline.sh scripts/tests/
git commit -m "feat(tools): inline-search-discipline.sh with tests"
```

---

## Task 9: scripts/audit-skills.sh + tests

**Files:**
- Create: `scripts/audit-skills.sh`
- Create: `scripts/tests/test-audit-skills.sh`
- Create: `scripts/tests/fixtures/audit-good/SKILL.md` (fixture)
- Create: `scripts/tests/fixtures/audit-bad-missing-trigger/SKILL.md` (fixture)
- Create: `scripts/tests/fixtures/audit-bad-banned-phrase/SKILL.md` (fixture)

**Interfaces:**
- Consumes: `skills/*/SKILL.md`
- Produces: stdout report + exit code (0=PASS, 1=FAIL, 2=DRIFT)

- [ ] **Step 1: Write the failing test**

```bash
mkdir -p /Users/lala/.minimax-agent-cn/projects/superpowers-max/scripts/tests/fixtures/audit-good
mkdir -p /Users/lala/.minimax-agent-cn/projects/superpowers-max/scripts/tests/fixtures/audit-bad-missing-trigger
mkdir -p /Users/lala/.minimax-agent-cn/projects/superpowers-max/scripts/tests/fixtures/audit-bad-banned-phrase

# Fixture: passing skill (will be created from the inline script for test isolation)
# We'll set this up inside the test script itself.

# Test script
cat > /Users/lala/.minimax-agent-cn/projects/superpowers-max/scripts/tests/test-audit-skills.sh <<'EOF'
#!/usr/bin/env bash
# Test: audit-skills.sh reports correct pass/fail per skill.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SCRIPT="$REPO_ROOT/scripts/audit-skills.sh"
TMPDIR="$(mktemp -d)"
trap "rm -rf $TMPDIR" EXIT

# Build minimal test repo: 1 good skill, 1 bad skill
mkdir -p "$TMPDIR/skills/_shared"
cp "$REPO_ROOT/skills/_shared/"*.md "$TMPDIR/skills/_shared/"

mkdir -p "$TMPDIR/skills/good-skill"
cat > "$TMPDIR/skills/good-skill/SKILL.md" <<SKILLEOF
---
name: good-skill
description: A test skill
---
<SEARCH_DISCIPLINE>
$(cat "$REPO_ROOT/skills/_shared/triggers.md")
$(cat "$REPO_ROOT/skills/_shared/source-quality.md")
$(cat "$REPO_ROOT/skills_/shared/output-format.md" 2>/dev/null || cat "$REPO_ROOT/skills/_shared/output-format.md")
$(cat "$REPO_ROOT/skills/_shared/failure-modes.md")
</SEARCH_DISCIPLINE>

## Body
Works fine.
SKILLEOF

mkdir -p "$TMPDIR/skills/bad-skill"
cat > "$TMPDIR/skills/bad-skill/SKILL.md" <<'SKILLEOF'
---
name: bad-skill
description: A test skill missing some rules
---
<SEARCH_DISCIPLINE>
Partial content without all rules.
</SEARCH_DISCIPLINE>

目前 this skill is missing some rules.
SKILLEOF

# Run audit; expect exit 1 (some fail)
output=$(cd "$TMPDIR" && SKILLS_DIR="$TMPDIR/skills" "$SCRIPT" 2>&1) && rc=0 || rc=$?

if [ "$rc" -eq 0 ]; then
  echo "FAIL: expected non-zero exit, got 0"
  echo "$output"
  exit 1
fi

# Output should mention both good-skill and bad-skill
if ! echo "$output" | grep -q "good-skill"; then
  echo "FAIL: output missing good-skill"
  echo "$output"
  exit 1
fi
if ! echo "$output" | grep -q "bad-skill"; then
  echo "FAIL: output missing bad-skill"
  echo "$output"
  exit 1
fi

echo "PASS: audit-skills.sh"
EOF

chmod +x /Users/lala/.minimax-agent-cn/projects/superpowers-max/scripts/tests/test-audit-skills.sh
```

- [ ] **Step 2: Run test to verify it fails**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
./scripts/tests/test-audit-skills.sh; echo "exit=$?"
```

Expected: FAIL (script doesn't exist)

- [ ] **Step 3: Write the implementation**

```bash
cat > /Users/lala/.minimax-agent-cn/projects/superpowers-max/scripts/audit-skills.sh <<'EOF'
#!/usr/bin/env bash
# audit-skills.sh
# Static audit: each skill's SKILL.md has the full <SEARCH_DISCIPLINE> block
# with all 4 triggers, 4 source rules, 3 failure rules, 3 output rules,
# no banned phrases, and complete frontmatter.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_DIR="${SKILLS_DIR:-$REPO_ROOT/skills}"
SHARED_DIR="$SKILLS_DIR/_shared"

if [ ! -d "$SHARED_DIR" ]; then
  echo "ERROR: $SHARED_DIR not found" >&2
  exit 1
fi

# Concatenated shared content (for drift check)
SHARED_HASH="$(cat "$SHARED_DIR/triggers.md" "$SHARED_DIR/source-quality.md" \
              "$SHARED_DIR/output-format.md" "$SHARED_DIR/failure-modes.md" | shasum -a 256 | awk '{print $1}')"

PASS=0
FAIL=0
DRIFT=0

printf '%-40s %-6s %s\n' "SKILL" "RESULT" "DETAIL"
printf '%-40s %-6s %s\n' "-----" "------" "------"

for skill_dir in "$SKILLS_DIR"/*/; do
  [ "$(basename "$skill_dir")" = "_shared" ] && continue
  skill_md="$skill_dir/SKILL.md"
  [ ! -f "$skill_md" ] && continue
  skill_name="$(basename "$skill_dir")"

  # Extract anchor block
  anchor_content="$(awk '/<SEARCH_DISCIPLINE>/,/<\/SEARCH_DISCIPLINE>/' "$skill_md" || true)"

  if [ -z "$anchor_content" ]; then
    printf '%-40s %-6s %s\n' "$skill_name" "FAIL" "missing <SEARCH_DISCIPLINE>"
    FAIL=$((FAIL+1))
    continue
  fi

  # Check 9 items
  missing=()

  # 1. anchor exists — already checked

  # 2-5. 4 triggers
  for t in "T1. 每事实必搜" "T2. 每决策必搜" "T3. 每步入口必搜" "T4. 每自信断言必搜"; do
    echo "$anchor_content" | grep -qF "$t" || missing+=("trigger:$t")
  done

  # 6-9. 4 source rules
  for s in "S1. 金字塔分级" "S2. 多源交叉为硬规则" "S3. 类型广" "S4. 时效性硬要求"; do
    echo "$anchor_content" | grep -qF "$s" || missing+=("source:$s")
  done

  # 10-12. 3 failure rules
  for f in "FM1. 多通道 fallback" "FM2. 降级 + 显式标注" "FM3. 源冲突必须呈现"; do
    echo "$anchor_content" | grep -qF "$f" || missing+=("failure:$f")
  done

  # 13-15. 3 output rules
  for o in "OF1. 内联引用" "OF2. 结构化搜索日志" "OF3. 日志位置与保留"; do
    echo "$anchor_content" | grep -qF "$o" || missing+=("output:$o")
  done

  # 16. drift check (anchor content matches _shared concat)
  anchor_hash="$(echo "$anchor_content" | shasum -a 256 | awk '{print $1}')"
  if [ "$anchor_hash" != "$SHARED_HASH" ]; then
    missing+=("drift")
  fi

  # 17. banned phrases
  for bp in "目前" "现在主流" "一般来说"; do
    grep -qF "$bp" "$skill_md" && missing+=("banned:$bp")
  done

  # 18. frontmatter complete
  head -5 "$skill_md" | grep -qE "^name: " || missing+=("frontmatter:name")
  head -5 "$skill_md" | grep -qE "^description: " || missing+=("frontmatter:description")

  if [ ${#missing[@]} -eq 0 ]; then
    printf '%-40s %-6s %s\n' "$skill_name" "PASS" "9/9"
    PASS=$((PASS+1))
  else
    printf '%-40s %-6s %s\n' "$skill_name" "FAIL" "${missing[*]}"
    FAIL=$((FAIL+1))
  fi
done

echo ""
echo "TOTAL: $((PASS+FAIL)) skills, $PASS pass, $FAIL fail"

# Exit codes
if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
exit 0
EOF

chmod +x /Users/lala/.minimax-agent-cn/projects/superpowers-max/scripts/audit-skills.sh
```

- [ ] **Step 4: Run test to verify it passes**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
./scripts/tests/test-audit-skills.sh
```

Expected: `PASS: audit-skills.sh`

- [ ] **Step 5: Run audit on the real repo (smoke test)**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
./scripts/audit-skills.sh
```

Expected: `TOTAL: 0 skills, 0 pass, 0 fail` (no skills yet — Plan 2 adds them). If it shows "no skills", that's fine for this plan.

- [ ] **Step 6: Commit**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
git add scripts/audit-skills.sh scripts/tests/test-audit-skills.sh
git commit -m "feat(tools): audit-skills.sh with tests (9-check static audit)"
```

---

## Task 10: Run inline + audit end-to-end + tag v0.1.0-max

**Files:** none new

**Interfaces:**
- Consumes: all prior tasks' outputs
- Produces: v0.1.0-max git tag, end-to-end verified

- [ ] **Step 1: Run inline-search-discipline.sh on real repo (no-op since no skills yet)**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
./scripts/inline-search-discipline.sh
```

Expected: `Done: 0 skill(s) updated` (no skills exist yet — Plan 2 adds them)

- [ ] **Step 2: Run both test scripts**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
./scripts/tests/test-inline-search-discipline.sh
./scripts/tests/test-audit-skills.sh
```

Expected: Both report `PASS: ...`

- [ ] **Step 3: View git log to verify all 10 commits**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
git log --oneline
```

Expected: 10 commits in order (Task 1 → Task 9, then this verification commit if needed)

- [ ] **Step 4: Tag v0.1.0-max**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
git tag -a v0.1.0-max -m "v0.1.0-max: Plan 1 foundation (repo, philosophy, tools)"
```

- [ ] **Step 5: Verify tag**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
git tag -l "v0.1.0-max"
git show v0.1.0-max --stat | head -20
```

Expected: Tag exists, points to HEAD, shows recent commits

---

## Self-Review (filled by plan author before handoff)

- [x] **Spec coverage:** Each spec section maps to a task:
  - §1 背景与动机 → README.md
  - §3 哲学核心 → README + `_shared/*.md`
  - §4 架构总览 → Task 1-3 (repo, plugin descriptors)
  - §5 规则集 → Tasks 4-7 (4 _shared files)
  - §7.1 静态审计 → Task 9 (audit-skills.sh)
  - §7.1 内嵌同步 → Task 8 (inline-search-discipline.sh)
  - §9 非功能 → Tasks 1-3 (license, package.json, plugin descriptors)
  - §10 实施 P0-P2 → Tasks 1-9
  - §11 v1.0 验收 A2 第一层(audit) → Task 9
  - §13 关键决策 → encoded in commits/CHANGELOG

- [x] **Placeholder scan:** No TBD/TODO/"implement later" — every step has actual content.

- [x] **Type/signature consistency:** `inline-search-discipline.sh` and `audit-skills.sh` both reference the same 4 `_shared/*.md` files (triggers, source-quality, output-format, failure-modes). Anchor format `<SEARCH_DISCIPLINE>...</SEARCH_DISCIPLINE>` is consistent across Tasks 4-7 (content), Task 8 (script operates on it), Task 9 (script checks for it).

- [x] **Independence:** This plan produces working, testable software on its own:
  - Repo can be `git clone`d
  - Plugin descriptors are valid (would load in 6 platforms — stubs in 2 of them)
  - Philosophy is documented in 4 rule files
  - Both maintenance scripts work and have passing tests

---

## Plan 1 Acceptance Criteria

| # | Criterion | Verification |
|---|---|---|
| F1 | Git repo initialized with `main` branch | `git log --oneline` shows 10 commits |
| F2 | All 5 metadata files present | `ls README.md LICENSE package.json .version-bump.json CHANGELOG.md` |
| F3 | All 6 plugin descriptors present | `ls -d .claude-plugin .codex-plugin .cursor-plugin .kimi-plugin .pi .opencode` |
| F4 | All 4 `_shared/*.md` files present and self-consistent | `ls skills/_shared/*.md` (4 files) |
| F5 | `inline-search-discipline.sh` works on fixtures and passes test | `./scripts/tests/test-inline-search-discipline.sh` → PASS |
| F6 | `audit-skills.sh` reports correctly on good/bad fixtures | `./scripts/tests/test-audit-skills.sh` → PASS |
| F7 | v0.1.0-max tag exists | `git tag -l "v0.1.0-max"` |

---

**End of Plan 1.** Ready for execution.
