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

  # Extract anchor block (content BETWEEN <SEARCH_DISCIPLINE> tags, NOT including
  # the tag lines themselves). Use anchored regex so the literal string
  # "<SEARCH_DISCIPLINE>" inside the shared content (e.g. in a code reference
  # like `` `<SEARCH_DISCIPLINE>` ``) does not false-trigger the boundary.
  anchor_content="$(
    awk '
      /^<SEARCH_DISCIPLINE>$/ { flag = 1; next }
      /^<\/SEARCH_DISCIPLINE>$/ { flag = 0; next }
      flag
    ' "$skill_md" || true
  )"

  if [ -z "$anchor_content" ]; then
    printf '%-40s %-6s %s\n' "$skill_name" "FAIL" "missing <SEARCH_DISCIPLINE>"
    FAIL=$((FAIL+1))
    continue
  fi

  # Extract MANDATORY_PREAMBLE block (top, after frontmatter, before everything else).
  preamble_content="$(
    awk '
      /^<MANDATORY_PREAMBLE>$/ { flag = 1; next }
      /^<\/MANDATORY_PREAMBLE>$/ { flag = 0; next }
      flag
    ' "$skill_md" || true
  )"

  if [ -z "$preamble_content" ]; then
    missing+=("mandatory_preamble:missing")
  fi

  # Body = everything OUTSIDE both the SEARCH_DISCIPLINE block AND the
  # MANDATORY_PREAMBLE block. The banned-phrase check must run against the
  # body only, because the shared content and the preamble contain
  # "目前" / "现在主流" / "一般来说" / "based on my training" as documented
  # examples of phrases to avoid.
  body_content="$(
    awk '
      /^<SEARCH_DISCIPLINE>$/    { flag = 1; next }
      /^<\/SEARCH_DISCIPLINE>$/  { flag = 0; next }
      /^<MANDATORY_PREAMBLE>$/   { flag = 1; next }
      /^<\/MANDATORY_PREAMBLE>$/ { flag = 0; next }
      !flag
    ' "$skill_md" || true
  )"

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

  # 16. drift check (anchor content matches _shared concat).
  # Drift is a separate failure mode (spec §7.1 exit code 2), not a generic
  # "missing rule" — track it on its own counter so we can report it
  # distinctly and exit 2 instead of folding it into FAIL/1.
  anchor_hash="$(echo "$anchor_content" | shasum -a 256 | awk '{print $1}')"
  drift_detected=0
  if [ "$anchor_hash" != "$SHARED_HASH" ]; then
    DRIFT=$((DRIFT+1))
    drift_detected=1
  fi

  # 17. preamble contains the 4 hard-gate triggers (T1-T4)
  for pt in "T1. Search before every fact" "T2. Search before every decision" \
            "T3. Search at step entry" "T4. Search before every self-confident"; do
    echo "$preamble_content" | grep -qF "$pt" || missing+=("preamble:$pt")
  done

  # 18. preamble contains the failure modes (FM1-FM3) and citation format
  for pf in "FM1" "FM2" "FM3" "Citation format" "Banned phrases"; do
    echo "$preamble_content" | grep -qF "$pf" || missing+=("preamble:$pf")
  done

  # 19. description has the standard suffix pointing to MANDATORY_PREAMBLE
  skill_desc="$(
    awk '/^---$/{c++; next} c==1 && /^description:/{sub(/^description:[[:space:]]*/,""); print; exit}' "$skill_md"
  )"
  if ! echo "$skill_desc" | grep -qF "MANDATORY_PREAMBLE"; then
    missing+=("description:suffix")
  fi

  # 20. banned phrases — Chinese (body only)
  for bp in "目前" "现在主流" "一般来说"; do
    echo "$body_content" | grep -qF "$bp" && missing+=("banned:$bp")
  done

  # 21. banned phrases — English (body only, preamble-immune via stripping)
  for bp in "based on my training" "as I recall" "from what I know" \
            "in my experience" "the standard approach is" "this is well-known"; do
    if echo "$body_content" | grep -qiF "$bp"; then
      missing+=("banned-en:$bp")
    fi
  done

  # 22. frontmatter complete
  head -5 "$skill_md" | grep -qE "^name: " || missing+=("frontmatter:name")
  head -5 "$skill_md" | grep -qE "^description: " || missing+=("frontmatter:description")

  # Check 6: at least 1 <SEARCH_GATE> block per skill (spec §7.1: N = steps × 50%, ≥1 if any steps)
  gate_count=$(grep -c '<SEARCH_GATE' "$skill_md" || true)
  if [ "$gate_count" -eq 0 ]; then
    missing+=("gates=0")
  fi

  if [ ${#missing[@]} -eq 0 ] && [ "$drift_detected" -eq 0 ]; then
    printf '%-40s %-6s %s\n' "$skill_name" "PASS" "gates=$gate_count 9/9"
    PASS=$((PASS+1))
  elif [ ${#missing[@]} -eq 0 ] && [ "$drift_detected" -eq 1 ]; then
    # Drift is its own status (exit 2), distinct from FAIL.
    printf '%-40s %-6s %s\n' "$skill_name" "DRIFT" "gates=$gate_count"
  else
    # Drift + other issues → still FAIL (the other issues are the real bug);
    # DRIFT counter has already been incremented above.
    printf '%-40s %-6s %s\n' "$skill_name" "FAIL" "gates=$gate_count ${missing[*]}"
    FAIL=$((FAIL+1))
  fi
done

echo ""
echo "TOTAL: $((PASS+FAIL+DRIFT)) skills, $PASS pass, $FAIL fail, DRIFT: $DRIFT"

# Exit codes (spec §7.1): 0 = all pass, 1 = some fail, 2 = DRIFT (no hard fails).
# FAIL takes precedence over DRIFT — a real rule violation must surface as 1.
if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
if [ "$DRIFT" -gt 0 ]; then
  exit 2
fi
exit 0
