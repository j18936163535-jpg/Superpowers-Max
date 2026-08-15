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
