#!/usr/bin/env bash
# scripts/check-banned-phrases.sh
# Pre-commit check: ensure skills/*/SKILL.md body (outside <SEARCH_DISCIPLINE>) has no banned phrases.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_DIR="$REPO_ROOT/skills"

fail=0
for skill_dir in "$SKILLS_DIR"/*/; do
  [ "$(basename "$skill_dir")" = "_shared" ] && continue
  skill_md="$skill_dir/SKILL.md"
  [ ! -f "$skill_md" ] && continue
  skill_name="$(basename "$skill_dir")"

  # Extract body (outside <SEARCH_DISCIPLINE>...</SEARCH_DISCIPLINE>)
  body="$(awk '
    /<SEARCH_DISCIPLINE>/ { in_anchor=1; next }
    /<\/SEARCH_DISCIPLINE>/ { in_anchor=0; next }
    !in_anchor { print }
  ' "$skill_md")"

  for bp in "目前" "现在主流" "一般来说"; do
    if echo "$body" | grep -qF "$bp"; then
      echo "FAIL: $skill_name contains banned phrase '$bp' in body"
      fail=$((fail+1))
    fi
  done
done

exit $fail
