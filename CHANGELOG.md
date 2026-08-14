# Changelog

All notable changes to superpowers-max are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html)
with a `-max` suffix to mark fork identity.

## [Unreleased]

## [1.0.0-max] - 2026-08-15

### Added
- All 14 upstream skills rewritten with embedded search discipline
  (T1-T4 triggers, S1-S4 source rules, FM1-FM3 failure rules, OF1-OF3 output rules)
- `using-superpowers-max` (renamed from upstream `using-superpowers`)
- Per-skill `<SEARCH_GATE>` blocks at major decision points
- Per-skill strength mapping (high/medium/low research density)
- Audit script hardening: check #6 (SEARCH_GATE count) + DRIFT exit 2

### Changed
- `audit-skills.sh`: 8/9 → 9/9 checks; new exit code 2 for DRIFT
- All skill files embed `<SEARCH_DISCIPLINE>` block at top

## [0.1.0-max] - 2026-08-15

### Added
- Initial repository structure (Plan 1: foundation)
- Philosophy: 反 LLM 中心主义 — search-discipline mandatory
- 6-platform plugin descriptors (Claude, Codex, Cursor, Kimi, OpenCode, Pi)
- `skills/_shared/` rule source: triggers, source-quality, output-format, failure-modes
- `scripts/inline-search-discipline.sh` — syncs rules to per-skill blocks
- `scripts/audit-skills.sh` — static discipline audit (9 checks)

[Unreleased]: https://example.com/superpowers-max/compare/v1.0.0-max...HEAD
[1.0.0-max]: https://example.com/superpowers-max/releases/tag/v1.0.0-max
[0.1.0-max]: https://example.com/superpowers-max/releases/tag/v0.1.0-max
