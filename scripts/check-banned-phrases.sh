#!/usr/bin/env bash
# scripts/check-banned-phrases.sh
# Pre-commit check: ensure skills/*/SKILL.md body (outside <SEARCH_DISCIPLINE>
# and <MANDATORY_PREAMBLE>) has no banned phrases.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_DIR="$REPO_ROOT/skills"

fail=0
for skill_dir in "$SKILLS_DIR"/*/; do
  [ "$(basename "$skill_dir")" = "_shared" ] && continue
  skill_md="$skill_dir/SKILL.md"
  [ ! -f "$skill_md" ] && continue
  skill_name="$(basename "$skill_dir")"

  # Extract body (outside both <SEARCH_DISCIPLINE> and <MANDATORY_PREAMBLE> blocks)
  body="$(awk '
    /<SEARCH_DISCIPLINE>/    { in_anchor=1; next }
    /<\/SEARCH_DISCIPLINE>/  { in_anchor=0; next }
    /<MANDATORY_PREAMBLE>/   { in_anchor=1; next }
    /<\/MANDATORY_PREAMBLE>/ { in_anchor=0; next }
    !in_anchor { print }
  ' "$skill_md")"

  # Chinese banned phrases (original L1 set)
  for bp in "目前" "现在主流" "一般来说"; do
    if echo "$body" | grep -qF "$bp"; then
      echo "FAIL: $skill_name contains banned phrase '$bp' in body"
      fail=$((fail+1))
    fi
  done

  # English banned phrases (added in v1.0.0-max L1+ pass)
  # These signal "I'm skipping search" — see skills/_shared/mandatory-preamble.md
  for bp in "based on my training" "as I recall" "from what I know" \
            "in my experience" "the standard approach is" "this is well-known"; do
    if echo "$body" | grep -qiF "$bp"; then
      echo "FAIL: $skill_name contains banned phrase '$bp' in body"
      fail=$((fail+1))
    fi
  done
done

exit $fail
