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
