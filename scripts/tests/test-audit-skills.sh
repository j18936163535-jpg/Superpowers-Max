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

<SEARCH_GATE step="do-thing" triggers="T3">
Search for the latest guidance before doing the thing.
</SEARCH_GATE>

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

# no-search-gate fixture: full anchor (from _shared) but no <SEARCH_GATE> blocks.
# The fixture file ships with a FIXTURE_ANCHOR_PLACEHOLDER that the test splits on,
# substituting the current _shared content between the two halves, so the drift
# check still passes for this skill and the only failing reason is check #6.
mkdir -p "$TMPDIR/skills/no-search-gate-skill"
FIXTURE="$REPO_ROOT/scripts/tests/fixtures/audit-no-search-gate/SKILL.md"
{
  awk '/FIXTURE_ANCHOR_PLACEHOLDER/{exit} {print}' "$FIXTURE"
  cat "$REPO_ROOT/skills/_shared/triggers.md" \
      "$REPO_ROOT/skills/_shared/source-quality.md" \
      "$REPO_ROOT/skills/_shared/output-format.md" \
      "$REPO_ROOT/skills/_shared/failure-modes.md"
  awk 'f{print} /FIXTURE_ANCHOR_PLACEHOLDER/{f=1}' "$FIXTURE"
} > "$TMPDIR/skills/no-search-gate-skill/SKILL.md"

# Helper: substitute the shared anchor into a FIXTURE_ANCHOR_PLACEHOLDER fixture.
build_fixture_with_shared_anchor() {
  local src="$1" dst="$2"
  {
    awk '/FIXTURE_ANCHOR_PLACEHOLDER/{exit} {print}' "$src"
    cat "$REPO_ROOT/skills/_shared/triggers.md" \
        "$REPO_ROOT/skills/_shared/source-quality.md" \
        "$REPO_ROOT/skills/_shared/output-format.md" \
        "$REPO_ROOT/skills/_shared/failure-modes.md"
    awk 'f{print} /FIXTURE_ANCHOR_PLACEHOLDER/{f=1}' "$src"
  } > "$dst"
}

# drift-clean fixture: full anchor (from _shared), 1 <SEARCH_GATE>, clean body.
# Exercises BOTH the drift fix (anchor content must hash-match _shared) AND
# the anchor-banned-phrase fix (anchor contains "目前" / "现在主流" / "一般来说"
# as documented examples — the audit must ignore the anchor for banned-phrase).
# Expected: PASS.
mkdir -p "$TMPDIR/skills/drift-clean-skill"
build_fixture_with_shared_anchor \
  "$REPO_ROOT/scripts/tests/fixtures/audit-drift-clean/SKILL.md" \
  "$TMPDIR/skills/drift-clean-skill/SKILL.md"

# body-banned fixture: full anchor (clean per the drift fix), 1 <SEARCH_GATE>,
# body contains the banned phrase "目前". Expected: FAIL with "banned:目前"
# ONLY (no drift, no other banned phrases, no other missing items).
mkdir -p "$TMPDIR/skills/body-banned-skill"
build_fixture_with_shared_anchor \
  "$REPO_ROOT/scripts/tests/fixtures/audit-body-banned/SKILL.md" \
  "$TMPDIR/skills/body-banned-skill/SKILL.md"

# --- DRIFT exit code 2 (Task 2) -----------------------------------------
# Isolated repo: a SINGLE skill with a stale anchor (fixture ships with hard-
# coded content that does NOT hash-match skills/_shared/) and a clean body.
# No banned phrases, valid frontmatter, 1 <SEARCH_GATE>. Expected audit exit
# code: 2 (DRIFT). The main $TMPDIR repo also has skills that fail with FAIL
# (exit 1), so we can't test DRIFT exit code in the combined run — FAIL would
# dominate. Hence the isolated sub-test below.
DRIFT_TMP="$(mktemp -d)"
mkdir -p "$DRIFT_TMP/skills/_shared"
cp "$REPO_ROOT/skills/_shared/"*.md "$DRIFT_TMP/skills/_shared/"
# The fixture's anchor has FIXTURE_ANCHOR_PLACEHOLDER + a stale-marker line.
# We substitute the placeholder with the *current* _shared content (so all
# 9 trigger/source/failure/output rules are present), then the stale-marker
# line stays in the anchor, making its hash diverge from cat _shared/*.md.
mkdir -p "$DRIFT_TMP/skills/drift-skill"
build_fixture_with_shared_anchor \
  "$REPO_ROOT/scripts/tests/fixtures/audit-drift/SKILL.md" \
  "$DRIFT_TMP/skills/drift-skill/SKILL.md"
drift_output="$(cd "$DRIFT_TMP" && SKILLS_DIR="$DRIFT_TMP/skills" "$SCRIPT" 2>&1)" && drift_rc=0 || drift_rc=$?
rm -rf "$DRIFT_TMP"
if [ "$drift_rc" -ne 2 ]; then
  echo "FAIL: drift-only repo should exit 2 (DRIFT), got $drift_rc"
  echo "$drift_output"
  exit 1
fi
# Per-skill output line must mark this skill as DRIFT (not PASS, not FAIL).
if ! echo "$drift_output" | grep -E "drift-skill[[:space:]]+DRIFT" >/dev/null; then
  echo "FAIL: drift-skill should be marked DRIFT (not PASS, not FAIL)"
  echo "$drift_output"
  exit 1
fi
# TOTAL line must print the DRIFT count.
if ! echo "$drift_output" | grep -E "TOTAL:.*DRIFT:[[:space:]]*1" >/dev/null; then
  echo "FAIL: TOTAL line should print 'DRIFT: 1' for a single-drift repo"
  echo "$drift_output"
  exit 1
fi

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

# Check #6: no-search-gate-skill should fail with reason "gates=0"
if ! echo "$output" | grep -E "no-search-gate-skill[[:space:]]+FAIL" >/dev/null; then
  echo "FAIL: no-search-gate-skill not marked FAIL"
  echo "$output"
  exit 1
fi
if ! echo "$output" | grep -E "no-search-gate-skill[[:space:]]+FAIL[[:space:]]+.*gates=0" >/dev/null; then
  echo "FAIL: no-search-gate-skill should fail with reason 'gates=0'"
  echo "$output"
  exit 1
fi

# gates=N should appear in the per-skill output line for every skill
if ! echo "$output" | grep -qE "gates=[0-9]+"; then
  echo "FAIL: per-skill output should include 'gates=N'"
  echo "$output"
  exit 1
fi

# --- Drift + anchor-banned-phrase fix (Task 1.5) -----------------------
# drift-clean-skill has the full shared anchor (substituted at test time
# from _shared/) and a clean body. It MUST pass audit, i.e.
#   1. drift check must pass: anchor content (between tags, no tag lines,
#      no flanking newlines) must hash-equal the cat-concat of _shared/*.md.
#   2. banned-phrase check must ignore the anchor (the anchor contains
#      "目前" / "现在主流" / "一般来说" as documented examples).
# Before the fix, this skill fails with reasons including `drift` and
# `banned:目前` etc.
if ! echo "$output" | grep -E "drift-clean-skill[[:space:]]+PASS" >/dev/null; then
  echo "FAIL: drift-clean-skill should be marked PASS (drift + anchor-banned fixes)"
  echo "$output"
  exit 1
fi

# body-banned-skill has a clean anchor and body containing "目前".
# It MUST fail with "banned:目前" as the reason, and MUST NOT have "drift"
# in the reason (proves the drift fix is also wired up — the anchor DOES
# match _shared, so drift is clean, and the only failure is body banned).
if ! echo "$output" | grep -E "body-banned-skill[[:space:]]+FAIL" >/dev/null; then
  echo "FAIL: body-banned-skill should be marked FAIL"
  echo "$output"
  exit 1
fi
body_banned_line="$(echo "$output" | grep -E "body-banned-skill[[:space:]]+FAIL" || true)"
if ! echo "$body_banned_line" | grep -qE "banned:目前"; then
  echo "FAIL: body-banned-skill should fail with reason 'banned:目前'"
  echo "$body_banned_line"
  exit 1
fi
if echo "$body_banned_line" | grep -qE "(^|[[:space:]])drift([[:space:]]|$)"; then
  echo "FAIL: body-banned-skill should NOT have 'drift' in reason (drift fix not wired up)"
  echo "$body_banned_line"
  exit 1
fi

echo "PASS: audit-skills.sh"
