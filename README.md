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

## Maximum hardness: how the search discipline is enforced

The "hard constraint" question is the most important one to be honest about.
**There is no truly runtime-enforced constraint on MiniMax Code** — every "hard"
rule is enforced by prompting + audit + behavior evals + manual review. Here's
the full ladder, with what we actually deliver:

| Level | Mechanism | superpowers-max on MiniMax Code | superpowers-max on Claude Code |
|---|---|---|---|
| **L1** | Static audit (script checks skill content) | ✅ `scripts/audit-skills.sh` enforces 8 rule groups, drift detection, banned phrases (CN + EN), preamble presence, description suffix, ≥1 SEARCH_GATE per skill | ✅ same |
| **L1+** | Mandatory preamble in every skill (binding contract at the top of every SKILL.md) | ✅ `skills/_shared/mandatory-preamble.md` inlined into all 14 skills; preamble is the FIRST thing the model reads when any skill triggers | ✅ same |
| **L2** | Behavior evals (run real test cases through the model, grade output) | ✅ `tests/evals/` — 42 cases across 14 dirs, runner at `tests/evals/runner.sh` | ✅ same |
| **L3** | Platform-level hooks (SessionStart, PreToolUse that BLOCKS unsearched actions) | ❌ V1 spec forbids hooks | ✅ `hooks/hooks.json` injects `using-superpowers-max` on every session start; ready for PreToolUse blockers if Claude Code's hook API grows |
| **L4** | External wrapper (LiteLLM gateway, fact-check service) | ❌ outside plugin scope | ❌ outside plugin scope |

### What "L1+" actually does

`skills/_shared/mandatory-preamble.md` is a binding contract. It declares:

- **T1–T4 hard gates** — search before any fact, decision, step entry, or self-confident assertion
- **10 banned phrases** — model can be auto-flagged for writing "based on my training" / "as I recall" / etc.
- **3 failure modes (FM1–FM3)** — explicit handling for empty / partial / conflicting search results
- **Citation format** — every fact must be tagged `[T1:url]` or `[T1:url1,T1:url2]`
- **Time-stamping** — facts must be ≤12 months old for current-state claims
- **Recursive obligation** — preamble wins over any conflicting later instruction in the skill body

The preamble is inlined into every SKILL.md via `scripts/inline-preamble.sh`, so the
model sees it on every skill trigger. Audit fails the build if any skill loses it.

### What L3 (Claude Code hooks) actually does

`hooks/hooks.json` is wired up for Claude Code only. On every session start, it
injects the full `using-superpowers-max/SKILL.md` content as
`<EXTREMELY_IMPORTANT>` system context. This means **the model is told about
superpowers-max on every session, not just when a skill triggers** — that's a
real L3 improvement on Claude Code.

On MiniMax Code, this hook is ignored (no hook support), so the user must
either rely on the in-skill preamble (still L1+ strength) or use Claude Code
for L3.

### Honest limits

- The L1+ preamble is a **prompt**, not a runtime check. The model CAN still
  ignore it. The audit ensures the preamble is present; the eval suite tests
  whether the model follows it; but neither is 100% enforcement.
- "The model is honest" is the last 5% of any prompt-based constraint.
  True L4 (gateway-level fact-check) is the only way to close that 5%.
- We do not currently ship an MCP server for L2.5 (a "search-enforcer" tool
  that requires a citation token). It's a future direction — see
  `docs/retro/` for tracking.

## Status

- v0.1.0-max — Plan 1: foundation (this release)
- v1.0.0-max — Plan 4: 14 skills rewritten, evals pass, real project validated

See `docs/superpowers/specs/2026-08-15-superpowers-max-design.md` for the full design.

## Quick start

```bash
git clone https://github.com/<you>/superpowers-max.git
cd superpowers-max
./scripts/audit-skills.sh                # static discipline audit (L1)
./scripts/inline-preamble.sh             # inject mandatory preamble into all skills (L1+)
./scripts/inline-search-discipline.sh    # sync _shared/ to per-skill blocks
bash tests/evals/runner.sh               # behavior eval suite (L2)
```

Plugin descriptors under `.claude-plugin/`, `.codex-plugin/`, etc. let platforms pick this up
automatically.

## MiniMax Code (Desktop) install

MiniMax Code's Plugin V1 spec forbids multi-vendor manifests in one package, so this repo ships
the MiniMax Code plugin as a self-contained sub-package under `minimax/`.

**Recommended path — local install** (auto-detected, no UI steps):

```bash
cd /path/to/superpowers-max
bash scripts/sync-minimax.sh    # mirrors skills/ → minimax/skills/ AND
                                # mirrors minimax/ → ~/.minimax/plugins/superpowers-max
```

After the script finishes, MiniMax Code's automatic local-plugin rescan picks up the package at
`~/.minimax/plugins/superpowers-max/` within a few seconds. Open the "管理" tab to confirm it
appears.

**Optional — GitHub subdir import** (currently flaky in MiniMax Code Desktop's importer, kept here
for future versions that may support it): import URL
`https://github.com/j18936163535-jpg/Superpowers-Max/tree/main/minimax`.

### Ongoing maintenance

After any change to a skill under `skills/`, run **one** command to keep the local install fresh
and the in-repo sub-package in sync:

```bash
bash scripts/sync-minimax.sh && git add . && git commit -m "..." && git push
```

The script will warn if a new skill was added to `skills/` but is not yet listed in
`minimax/.minimax-plugin/plugin.json` — add the new entry to the manifest's `skills` array,
then re-run. Set `SYNC_MINIMAX_LOCAL=0` to skip the local install step (e.g. in CI).
Override the local install path with `SUPERPOWERS_MAX_LOCAL_PLUGIN_DIR=/some/path`.

## License

MIT — see `LICENSE`.
