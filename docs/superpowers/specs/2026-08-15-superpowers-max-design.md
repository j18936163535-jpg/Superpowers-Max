# superpowers-max — Design Spec

**Date:** 2026-08-15
**Status:** Draft v1 (待用户评审)
**Author:** Brainstorming session output
**Audience:** 项目 owner + 任何未来读者

---

## 0. TL;DR

`superpowers-max` 是 `obra/superpowers` 的**完全独立硬分叉**。在保留 upstream 14 个 skill + 6 平台 plugin 能力的同时,核心差异是**为每个 skill 嵌入一套"反 LLM 中心主义"的搜索纪律**——用全流程、多频次、高质量、广范围的网络搜索弥补 LLM 训练数据天然会过期、会编造、会片面的问题。

硬约束由 4 层 system-level review 组成:**静态 audit + 行为 evals + 月度 retro + 真实项目实战**——结构上**强于** upstream 的"单人 + tests"组合。

---

## 1. 背景与动机

### 1.1 upstream superpowers 现状

- 仓库:`https://github.com/obra/superpowers`,v6.2.0(截至 2026-08-15)
- 14 个 skill,跨 6 平台(Claude / Codex / Cursor / Kimi / OpenCode / Pi)
- 工作流:TDD、brainstorming、writing-plans、verification-before-completion、code review 等
- 隐含假设:**LLM 自己就是知识源**,通过纪律性流程保证质量
- 硬约束结构:obra 单人 review + tests + 社区 issue tracker

### 1.2 我们的差异化主张

> **训练数据天然会过期、会编造、会片面。LLM 不是知识源,是需要持续喂养新鲜信息的推理引擎。**

upstream 把 LLM 当作"基本可信 + 流程兜底"。superpowers-max 把 LLM 当作"持续不确定 + 搜索兜底"。

**反命题**:在 skill 流程的每个判断点强制 web search,确保答案来自当下而非训练时。

---

## 2. 目标与非目标

### 2.1 目标
1. 14 个 skill 全部内嵌搜索纪律(不靠"用户记得要搜")
2. 硬约束 ≥ upstream(实际设计为更强)
3. 6 平台 plugin descriptor 全覆盖(能力=upstream)
4. v1.0 可以在 Mavis / Claude / Codex / Cursor / Kimi / OpenCode / Pi 直接加载并使用

### 2.2 非目标
- 不追求与 upstream 版本对齐
- 不向 upstream 推 PR(独立仓库)
- 不替代 upstream(可以并存)
- 不做 UI 改动
- 不新增 skill(15 个 = 14 + using-superpowers-max 重命名)

---

## 3. 哲学核心:反 LLM 中心主义

### 3.1 一句话

**用全流程多频次高质量广范围网络搜索弥补大模型智力不足。**

### 3.2 四个支柱

| 支柱 | 含义 |
|---|---|
| **全流程** | 搜索不是 fallback,是 skill 每个判断点的第一动作 |
| **多频次** | 一次不够,关键事实 ≥2 源交叉;持续累积,不停顿 |
| **高质量** | 优先 T1(官方/RFC/同行评审),谨慎 T2,拒收 T3 营销文 |
| **广范围** | 类型广(官方+社区+学术+用户反馈),不只数量广 |

### 3.3 拒绝接受的隐含假设

upstream 的隐含假设是:
- LLM 训练数据基本可信
- 流程纪律能兜底
- 失败 = skill 写得不够严

我们的隐含假设是:
- LLM 训练数据**不可信**(过期/编造/片面是常态)
- 流程纪律**不够**(需要外部 fresh 信息)
- 失败 = LLM 没搜,不是 skill 写得不够严

---

## 4. 架构总览

### 4.1 Repo 布局

```
superpowers-max/
├── README.md                              # 哲学宣言 + 跟 upstream 的关系
├── LICENSE                                # MIT
├── package.json                           # name: "superpowers-max", version: "X.Y.Z-max"
├── .version-bump.json
│
├── .claude-plugin/plugin.json
├── .codex-plugin/
├── .cursor-plugin/
├── .kimi-plugin/
├── .pi/extensions/superpowers-max.ts
├── .opencode/plugins/superpowers-max.js
│
├── skills/                                # 14 + 1 meta,每 skill 独立完整
│   ├── using-superpowers-max/             # 重命名自 using-superpowers
│   ├── brainstorming/
│   ├── verification-before-completion/
│   ├── receiving-code-review/
│   ├── systematic-debugging/
│   ├── writing-plans/
│   ├── test-driven-development/
│   ├── using-git-worktrees/
│   ├── subagent-driven-development/
│   ├── dispatching-parallel-agents/
│   ├── executing-plans/
│   ├── finishing-a-development-branch/
│   ├── requesting-code-review/
│   ├── writing-skills/
│   └── _shared/                           # 规则真源(非 skill)
│       ├── triggers.md
│       ├── source-quality.md
│       ├── output-format.md
│       └── failure-modes.md
│
├── hooks/                                 # 平台 hooks
│
├── tests/evals/<skill>/case-N-*.md        # 每 skill 3-5 行为用例
│
├── docs/
│   ├── superpowers/specs/                 # 设计文档
│   ├── upstream-knowledge/                # 读 upstream 的笔记
│   ├── retro/                             # 月度 retro
│   └── CHANGELOG.md
│
└── scripts/
    ├── inline-search-discipline.sh        # 同步 _shared 到各 skill
    ├── audit-skills.sh                    # 静态纪律审计
    ├── check-discipline.py                # log 行为纪律
    └── cleanup-logs.sh                    # 30 天 log 清理
```

### 4.2 15 个 skill(14 改写 + 1 重命名)

| # | Skill | 来源 | 改造强度 |
|---|---|---|---|
| 1 | using-superpowers-max | upstream using-superpowers | 重命名 + 强化 enforce |
| 2 | brainstorming | upstream | T2+T3 极高 |
| 3 | verification-before-completion | upstream | T1+T4 极高 |
| 4 | receiving-code-review | upstream | T1+T4 极高 |
| 5 | systematic-debugging | upstream | T1 极高 |
| 6 | writing-plans | upstream | T2+T3 极高 |
| 7 | test-driven-development | upstream | 平衡 |
| 8 | using-git-worktrees | upstream | 低(机械) |
| 9 | subagent-driven-development | upstream | 平衡 |
| 10 | dispatching-parallel-agents | upstream | 平衡 |
| 11 | executing-plans | upstream | 平衡 |
| 12 | finishing-a-development-branch | upstream | 平衡 |
| 13 | requesting-code-review | upstream | T1+T4 |
| 14 | writing-skills | upstream | 平衡 |

**不新增 skill**。`skill-discipline-auditor` 改用 `scripts/audit-skills.sh` 脚本实现,降低维护成本。

### 4.3 search-discipline 系统:双层结构

| 层 | 角色 | 谁维护 |
|---|---|---|
| **源层** `skills/_shared/*.md` | 4 类规则唯一真源 | 人改 |
| **落地层** 每 skill 的 `<SEARCH_DISCIPLINE>` 块 | 完整复制,自包含 | `inline-search-discipline.sh` 同步 |

每次改 `_shared/`,跑 `inline-search-discipline.sh` 同步到 14 个 skill,确保不漂移。

---

## 5. search-discipline 规则集

### 5.1 触发器(4 个)

```markdown
## T1. 每事实必搜
<HARD-GATE>
LLM 输出任何事实性陈述前(API/最佳实践/库用法/版本/数据点)必先 web search。
</HARD-GATE>

## T2. 每决策必搜
<HARD-GATE>
技术/架构/选型/模式选择前必先 search 当前最佳实践。
</HARD-GATE>

## T3. 每步入口必搜
<HARD-GATE>
skill 流程每步开头先 search 一次"该步骤主题最新进展"。
</HARD-GATE>
(豁免:纯机械步骤)

## T4. 每自信断言必搜
<HARD-GATE>
LLM 表达自信时("肯定..."、"我们知道..."、"明显..."、"应该是..."、"一般来说...")
必先 search 来证伪自己。
</HARD-GATE>
(反幻觉最锐)
```

### 5.2 源质量规则(4 条)

```markdown
## S1. 金字塔分级
T1 权威: 官方文档 / RFC / 同行评审 / 政府数据 → 直接采用
T2 知名: 知名博客 / SO 高赞 / 头部公司工程博客 → 需 ≥1 T1 背书或 ≥2 T2 独立
T3 普通: 论坛 / 个人博客 / AI 生成 / 营销文 → 仅作 hint,不作依据

## S2. 多源交叉为硬规则
<HARD-GATE>
非平凡事实必须 ≥2 独立源确认。单一源不能下定论。
</HARD-GATE>

## S3. 类型广(跨域验证)
<HARD-GATE>
广范围 ≠ 数量广,要类型广: 官方 + 社区 + 学术 + 实际使用者反馈。
</HARD-GATE>

## S4. 时效性硬要求
<HARD-GATE>
依赖时间的主题必须包含年份/月份/显式日期。
禁用: "目前"、"现在"、"现在主流"、"近期"、"通常"。
强制: "2026 年 8 月"、"截至 2026-Q2"、"2025 年 12 月发布"。
</HARD-GATE>
```

### 5.3 输出格式(3 条)

```markdown
## OF1. 内联引用(每次输出必须)
- 简单事实: [T1:url] / [T2:url1,url2]
- 决策结论: [DECISION:基于...选 X]
- 自验证后: [T1-VERIFIED-AT:2026-08-15T05:00:00Z]
- 失败/冲突: [UNVERIFIED:原因] / [CONFLICT:T1说X,T2说Y]

## OF2. 结构化搜索日志(每 skill invocation 写一份)
路径: .superpowers-max/search-log/<skill>-<YYYY-MM-DDTHH-MM-SS>.md
包含: session_id, skill, step, queries, decisions, failures, conflicts

## OF3. 日志保留
路径 .superpowers-max/search-log/,30 天自动清理
默认不上传(本地动态)
```

### 5.4 失败处理(3 条)

```markdown
## FM1. 多通道 fallback
<HARD-GATE>
web_search 失败 → firecrawl → MCP 学术/专业 → 仍失败才 [UNVERIFIED]
</HARD-GATE>

## FM2. 降级 + 显式标注
<HARD-GATE>
全失败时,标 [UNVERIFIED:原因] + 原因,可继续推进,事后可审。
</HARD-GATE>

## FM3. 源冲突必须呈现
<HARD-GATE>
多源冲突时,LLM 必须呈现冲突各方观点,不许静默选边。
</HARD-GATE>
```

---

## 6. per-skill 改造模式:双锚点

每个 SKILL.md 采用双锚点:

```
[锚点 A] <SEARCH_DISCIPLINE> 块(顶部)
   - 4 触发器 + 4 源 + 3 失败 + 3 输出全量
   - 本 skill 触发强度映射

原有 skill 流程…

[锚点 B] 每步 <SEARCH_GATE> 块(散布)
   - 该步具体搜什么、什么时候搜
```

锚点 A 由 `inline-search-discipline.sh` 同步;锚点 B 人工写(skill-specific)。

**改造示例 (brainstorming, 节选)**:

```markdown
### Propose 2-3 approaches
<SEARCH_GATE step="propose-approaches" triggers="T2,T3">
Before proposing, you MUST:
1. T2: Web search "best practice <topic> 2026" + 2 source variants
2. T3: 同时搜 "<topic> alternatives 2026"、"<topic> anti-patterns 2026"
3. 验证 working code in last 12 months [S4]
4. 源冲突 → 呈现 [FM3]
</SEARCH_GATE>
- Lead with your recommended option [T2 决策]
- Each approach must include: trade-offs, why you recommend it, YAGNI removals
- 输出要求 [OF1]: 每个 approach 后附 [T1:url] / [T2:url] 标签
- 日志要求 [OF2]: 写到 .superpowers-max/search-log/brainstorming-<ts>.md
```

---

## 7. 审计 / 日志 / 测试

### 7.1 静态审计 `scripts/audit-skills.sh`

**9 项检查**(纯文本/grep,无 LLM 依赖):

| # | 检查 |
|---|---|
| 1 | `<SEARCH_DISCIPLINE>` 块存在 |
| 2 | 含 4 触发器 (T1-T4) |
| 3 | 含 4 源规则 (S1-S4) |
| 4 | 含 3 失败处理 (FM1-FM3) |
| 5 | 含 3 输出格式 (OF1-OF3) |
| 6 | 至少 N 个 `<SEARCH_GATE>` 散布(N = 应有步数 × 50%) |
| 7 | 锚点 A = `_shared/` 内容(防漂移) |
| 8 | 不含禁用词: "目前"、"现在主流"、"一般来说" |
| 9 | frontmatter 完整 (name, description) |

输出: `brainstorming PASS 9/9 gates=4`
退出码: 0 全过, 1 有 fail, 2 漂移(需重跑 inline)

**何时跑**: pre-commit hook + CI + 每月自检日 + `make audit`

### 7.2 搜索日志体系

- 位置: `.superpowers-max/search-log/`(本地动态,`.gitignore`)
- 保留: 30 天(自动清理)
- 月度 retro: `docs/retro/YYYY-MM.md` 总结搜索行为
- 纪律违反检测: `scripts/check-discipline.py <log>` 自动扫

### 7.3 行为校验 `tests/evals/`

```
tests/evals/<skill>/
├── case-1-fact-with-search.md
├── case-2-decision-with-multi-source.md
├── case-3-conflict-presentation.md
├── case-4-trigger-reminder-active.md
└── runner.sh
```

**case 模板**:
```yaml
input: "<prompt>"
expected_outputs:
  - type: inline-citation
    min_count: 2
    required_tier: [T1, T2]
  - type: search-log-written
    path_pattern: "<skill>-*.md"
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "显然", "一般来说"]
  - type: trigger-evidence
    trigger: T2
    must_have_search: true
```

**v1.0 范围**: case 文件 + schema check,不接真 agent
**v1.1+**: 接真 agent 跑,出 pass/fail 报告

### 7.4 复盘节奏

| 频率 | 动作 |
|---|---|
| 每次 commit | audit-skills.sh (pre-commit) |
| 每次 PR | audit + evals + lint (CI) |
| 每月初 | 读 search-log 写 retro |
| 每季度 | 跑 1 次"我作为用户用 max" 实测 |
| 每年 | 评估搜索纪律有效性,改规则 |

---

## 8. 硬分叉治理 + 内部硬约束系统

### 8.1 Git workflow(完全独立)

- **无 upstream remote**(或保留为只读 reference)
- 主分支: `main`
- 提交规范: `feat:` / `fix:` / `chore(philosophy):` / `chore(skill-X):` / `refactor:`
- 每个 PR 跑 audit + schema + lint

### 8.2 上游知识输入(只读,手工)

- 每月 15 日读 upstream release notes
- 写 `docs/upstream-knowledge/YYYY-MM-DD-<topic>.md` 笔记
- 启发我们改自己的,但**不合并、不 cherry-pick**

### 8.3 版本模型

- `1.0.0-max` → `1.1.0-max` → `2.0.0-max`
- SemVer + `-max` 后缀
- 独立 CHANGELOG,独立 RELEASE-NOTES

### 8.4 内部硬约束系统(4 层)

| 层 | 工具 | 类比 upstream | 何时跑 |
|---|---|---|---|
| 静态审 | audit-skills.sh | linter | pre-commit + CI |
| 行为校验 | tests/evals/ | unit test | CI + 发版前 |
| 过程审 | search-log + retro | 月度自审 | 每月 |
| 实战暴露 | 用 max 跑 1-2 真实项目 | 真实用户 | 持续 |

**这 4 层合起来 = 单人版的 obra + 用户 + 社区 合一**。

### 8.5 硬约束执行链

```
你改 SKILL.md
  ↓
[pre-commit] audit-skills.sh → 失败不让你 commit
  ↓
[commit]
  ↓
[CI] audit + evals + lint → 失败则 PR 不能 merge
  ↓
[merge] 进 main
  ↓
[每月] 你读 search-log, 写 retro
  ↓
[每季] 你用 max 跑真实项目,记 issues
  ↓
[每半年] 你评估纪律,改 search-discipline 规则
```

---

## 9. 非功能(平台/license/命名)

| 维度 | 决策 |
|---|---|
| 平台覆盖 | 6 平台全做(Claude/Codex/Cursor/Kimi/OpenCode/Pi) |
| License | MIT(继承 upstream) |
| 包名 | `superpowers-max`(全平台 plugin descriptor) |
| 仓库名 | `superpowers-max`(独立 GitHub 仓库) |
| README | 开头明写反 LLM 中心主义 + 与 upstream 差异 + 哲学来源 |
| CHANGELOG | Keep a Changelog 风格 |
| RELEASE-NOTES | 每次发版写,含 search-discipline 变更 |
| 版本号 | `X.Y.Z-max` SemVer + 后缀 |
| 依赖 | 无(纯 skills + scripts) |
| CI | GitHub Actions 跑 audit + evals + lint |

---

## 10. 实施计划

| 阶段 | 内容 | 验收 |
|---|---|---|
| **P0 仓库初始化** | README / LICENSE / package.json / 6 plugin descriptor / .gitignore | 仓库可被 Mavis / Claude / Codex 加载 |
| **P1 哲学基础** | `skills/_shared/{triggers,source-quality,output-format,failure-modes}.md` | 4 个文件齐,被 LLM 读得懂 |
| **P2 改造工具** | `scripts/inline-search-discipline.sh` + `scripts/audit-skills.sh` | 跑得动,空跑不报错 |
| **P3 14 skill 改写** | 先 using-superpowers-max + 4 高强度(verification/receiving-code-review/systematic-debugging/writing-plans),再 9 个 | 每改一个 audit 通过 |
| **P4 tests/evals** | 每 skill 3-5 case 文件 + runner.sh | schema 全过 |
| **P5 pre-commit + CI** | `.pre-commit-config.yaml` + `.github/workflows/ci.yml` | PR 跑得过 audit |
| **P6 实战验证** | 用 max 跑 1-2 个真实项目,跑完写 retro | 真实项目能用 |
| **P7 v1.0.0-max 发版** | CHANGELOG / RELEASE-NOTES / git tag | 标签可拉 |

---

## 11. v1.0 验收标准

**三条都过才能发版**:

| # | 标准 | 测法 |
|---|---|---|
| **A1 能力=upstream** | 14 skill + 6 plugin descriptor 全在 | 加载 + 跑 `using-superpowers-max` |
| **A2 硬约束更强** | 4 层全建好(audit + evals + retro 模板 + 实战过 1 项目) | 4 项各跑一次有产出 |
| **A3 搜索特色** | 4 触发器 + 4 源 + 3 失败 + 内联 + 日志全在每 skill | `audit-skills.sh` 14/14 PASS |

---

## 12. 风险与开放问题

### 12.1 已知风险
- **token 消耗高**:每事实必搜会显著增加 token 用量(预期 2-3x)
- **首次响应慢**:web search 串行调用会增加 latency
- **纪律衰减**:LLM 可能在长对话中忘记纪律,需要锚点 B 在每步提醒

### 12.2 缓解
- token 高:接受成本,质量优先
- 慢:接受 latency,正确性优先
- 衰减:锚点 B + audit + retro 三道防线

### 12.3 开放问题(可后续决定)
- 是否要单独的 `superpowers-max-plugin` 描述文件供 Mavis 一键加载?
- 是否要把 search-discipline 抽成 npm package 让其他项目复用?
- v2 是否考虑加 source 缓存层?

---

## 13. 附录

### 13.1 与 upstream 的差异清单

| 维度 | upstream | superpowers-max |
|---|---|---|
| 哲学 | LLM 是知识源 | LLM 是不确定推理引擎,需 fresh 搜索 |
| 搜索纪律 | 隐含(用户记得要搜) | 显式硬触发(4 触发器) |
| 源质量 | 隐含(LLM 自己判断) | 显式分级 + 交叉 + 类型广 + 时效 |
| 失败处理 | 未明确 | 多通道 fallback + 显式标注 + 冲突呈现 |
| 输出格式 | 自由 | 内联引用 + 结构化日志(强制) |
| 硬约束 | 1 层(obra 审) | 4 层(audit + evals + retro + 实战) |
| 上游同步 | N/A | 完全独立,只读不合并 |
| 版本号 | 6.2.0 | 1.0.0-max |

### 13.2 关键决策一览(20 项)

1. 核心方向 = D 全面重构(开源分叉)
2. 哲学 = 反 LLM 中心主义 + 4 支柱(全流程/多频次/高质量/广范围)
3. 落地 = B 内嵌到每个 skill
4. 触发器 = T1 事实 + T2 决策 + T3 步入口 + T4 自信断言
5. 源质量 = S1 金字塔 + S2 多源 + S3 类型广 + S4 时效
6. 输出 = OF1 内联 + OF2 日志 + OF3 30 天
7. 失败 = FM1 fallback + FM2 降级 + FM3 冲突呈现
8. v1.0 范围 = 14 skill 全部改写
9. 上游 = A 完全独立硬分叉
10. 硬约束 = 4 层自建
11. skill 数 = 15(14 改写 + 1 重命名)
12. 触发强度 = 按"研究密度"不平均
13. 锚点结构 = 双锚点(顶部规则全量 + 步骤级提醒)
14. 同步方式 = 脚本同步(锚点 A)+ 人工(锚点 B)
15. 平台 = 6 平台全做
16. License = MIT
17. 版本 = X.Y.Z-max
18. audit = 9 项静态检查
19. 复盘 = 月 retro + 季实测 + 年评估
20. 验收 = A1 能力 + A2 硬约束更强 + A3 搜索特色

---

**End of spec.** 等待用户评审。评审通过后转 writing-plans skill 写实施计划。
