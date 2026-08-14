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
