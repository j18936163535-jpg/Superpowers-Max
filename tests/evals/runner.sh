#!/usr/bin/env bash
# tests/evals/runner.sh
# Schema-only check: every .md file has required frontmatter fields.
# Real agent execution is a future enhancement (v1.1+ per spec §7.3).
set -euo pipefail

EVALS_DIR="$(cd "$(dirname "$0")" && pwd)"
TOTAL=0
PASS=0
FAIL=0

for case_file in "$EVALS_DIR"/*/case-*.md; do
  [ -f "$case_file" ] || continue
  TOTAL=$((TOTAL+1))
  skill="$(basename "$(dirname "$case_file")")"
  case_name="$(basename "$case_file" .md)"

  # Check required frontmatter fields
  missing=()
  head -10 "$case_file" | grep -qE "^name: " || missing+=("name")
  head -10 "$case_file" | grep -qE "^skill: " || missing+=("skill")
  head -10 "$case_file" | grep -qE "^input: " || missing+=("input")
  head -15 "$case_file" | grep -qE "^expected_outputs:" || missing+=("expected_outputs")

  # Check for banned phrases in body (outside frontmatter)
  body="$(awk 'BEGIN{p=0} /^---$/{c++; if(c==2) p=1; next} p{print}' "$case_file")"
  for bp in "目前" "现在主流" "一般来说"; do
    echo "$body" | grep -qF "$bp" && missing+=("banned:$bp")
  done

  if [ ${#missing[@]} -eq 0 ]; then
    echo "PASS  $skill/$case_name"
    PASS=$((PASS+1))
  else
    echo "FAIL  $skill/$case_name  missing=${missing[*]}"
    FAIL=$((FAIL+1))
  fi
done

echo ""
echo "TOTAL: $TOTAL cases, $PASS pass, $FAIL fail"
[ "$FAIL" -eq 0 ]
