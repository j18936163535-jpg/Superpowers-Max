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

echo "PASS: audit-skills.sh"
