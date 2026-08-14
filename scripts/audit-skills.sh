#!/usr/bin/env bash
# audit-skills.sh
# Static audit: each skill's SKILL.md has the full <SEARCH_DISCIPLINE> block
# with all 4 triggers, 4 source rules, 3 failure rules, 3 output rules,
# no banned phrases, and complete frontmatter.
set -euo pipefail

# Use current working directory (allows tests to point script at a temp repo).
# Production: invoke as `cd <project-root> && ./scripts/audit-skills.sh`.
REPO_ROOT="$(pwd)"
SKILLS_DIR="${SKILLS_DIR:-$REPO_ROOT/skills}"
SHARED_DIR="$SKILLS_DIR/_shared"

if [ ! -d "$SHARED_DIR" ]; then
  echo "ERROR: $SHARED_DIR not found" >&2
  exit 1
fi

# Concatenated shared content (for drift check)
SHARED_HASH="$(cat "$SHARED_DIR/triggers.md" "$SHARED_DIR/source-quality.md" \
              "$SHARED_DIR/output-format.md" "$SHARED_DIR/failure-modes.md" | shasum -a 256 | awk '{print $1}')"

PASS=0
FAIL=0
DRIFT=0

printf '%-40s %-6s %s\n' "SKILL" "RESULT" "DETAIL"
printf '%-40s %-6s %s\n' "-----" "------" "------"

for skill_dir in "$SKILLS_DIR"/*/; do
  [ "$(basename "$skill_dir")" = "_shared" ] && continue
  skill_md="$skill_dir/SKILL.md"
  [ ! -f "$skill_md" ] && continue
  skill_name="$(basename "$skill_dir")"

  # Extract anchor block
  anchor_content="$(awk '/<SEARCH_DISCIPLINE>/,/<\/SEARCH_DISCIPLINE>/' "$skill_md" || true)"

  if [ -z "$anchor_content" ]; then
    printf '%-40s %-6s %s\n' "$skill_name" "FAIL" "missing <SEARCH_DISCIPLINE>"
    FAIL=$((FAIL+1))
    continue
  fi

  # Check 9 items
  missing=()

  # 1. anchor exists — already checked

  # 2-5. 4 triggers
  for t in "T1. 每事实必搜" "T2. 每决策必搜" "T3. 每步入口必搜" "T4. 每自信断言必搜"; do
    echo "$anchor_content" | grep -qF "$t" || missing+=("trigger:$t")
  done

  # 6-9. 4 source rules
  for s in "S1. 金字塔分级" "S2. 多源交叉为硬规则" "S3. 类型广" "S4. 时效性硬要求"; do
    echo "$anchor_content" | grep -qF "$s" || missing+=("source:$s")
  done

  # 10-12. 3 failure rules
  for f in "FM1. 多通道 fallback" "FM2. 降级 + 显式标注" "FM3. 源冲突必须呈现"; do
    echo "$anchor_content" | grep -qF "$f" || missing+=("failure:$f")
  done

  # 13-15. 3 output rules
  for o in "OF1. 内联引用" "OF2. 结构化搜索日志" "OF3. 日志位置与保留"; do
    echo "$anchor_content" | grep -qF "$o" || missing+=("output:$o")
  done

  # 16. drift check (anchor content matches _shared concat)
  anchor_hash="$(echo "$anchor_content" | shasum -a 256 | awk '{print $1}')"
  if [ "$anchor_hash" != "$SHARED_HASH" ]; then
    missing+=("drift")
  fi

  # 17. banned phrases
  for bp in "目前" "现在主流" "一般来说"; do
    grep -qF "$bp" "$skill_md" && missing+=("banned:$bp")
  done

  # 18. frontmatter complete
  head -5 "$skill_md" | grep -qE "^name: " || missing+=("frontmatter:name")
  head -5 "$skill_md" | grep -qE "^description: " || missing+=("frontmatter:description")

  # Check 6: at least 1 <SEARCH_GATE> block per skill (spec §7.1: N = steps × 50%, ≥1 if any steps)
  gate_count=$(grep -c '<SEARCH_GATE' "$skill_md" || true)
  if [ "$gate_count" -eq 0 ]; then
    missing+=("gates=0")
  fi

  if [ ${#missing[@]} -eq 0 ]; then
    printf '%-40s %-6s %s\n' "$skill_name" "PASS" "gates=$gate_count 9/9"
    PASS=$((PASS+1))
  else
    printf '%-40s %-6s %s\n' "$skill_name" "FAIL" "gates=$gate_count ${missing[*]}"
    FAIL=$((FAIL+1))
  fi
done

echo ""
echo "TOTAL: $((PASS+FAIL)) skills, $PASS pass, $FAIL fail"

# Exit codes
if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
exit 0
