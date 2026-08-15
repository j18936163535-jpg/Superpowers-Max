#!/usr/bin/env bash
# sync-minimax.sh — Mirror skills/ into the MiniMax Plugin V1 subdir.
#
# Plugin V1 forbids multi-vendor manifests in one package, so the MiniMax
# plugin lives in its own subdir (minimax/) and is kept in sync via this
# script. Run after any change to skills/ (add/remove/rewrite a skill).
#
# Usage:
#   cd /path/to/superpowers-max
#   bash scripts/sync-minimax.sh
#
# Exit codes:
#   0  sync succeeded, no drift, manifest matches disk
#   1  precondition failed (target dir missing, etc.)
#   2  drift between skills/ and minimax/skills/ (should never happen after a clean run)

set -euo pipefail

REPO_ROOT="$(pwd)"
SOURCE_DIR="$REPO_ROOT/skills"
TARGET_DIR="$REPO_ROOT/minimax/skills"
MANIFEST="$REPO_ROOT/minimax/.minimax-plugin/plugin.json"

# --- preconditions ---
if [ ! -d "$TARGET_DIR" ]; then
  echo "ERROR: $TARGET_DIR not found — has minimax/ subdir been deleted?" >&2
  exit 1
fi
if [ ! -f "$MANIFEST" ]; then
  echo "ERROR: $MANIFEST not found" >&2
  exit 1
fi

# --- mirror skills/ -> minimax/skills/ (skip _shared, not a Skill) ---
copied=0
skipped=0
for skill_dir in "$SOURCE_DIR"/*/; do
  [ -d "$skill_dir" ] || continue
  name="$(basename "$skill_dir")"
  if [ "$name" = "_shared" ]; then
    continue
  fi
  # V1 skill-name pattern (POSIX ERE — bash [[ =~ ]] doesn't support PCRE (?:...) )
  pattern='^[a-z][a-z0-9]*([._-][a-z0-9]+)*$'
  if ! [[ "$name" =~ $pattern ]]; then
    echo "WARN: skill name '$name' fails V1 pattern, skipping" >&2
    skipped=$((skipped + 1))
    continue
  fi
  rm -rf "${TARGET_DIR:?}/$name"
  mkdir -p "$TARGET_DIR/$name"
  cp -R "$skill_dir." "$TARGET_DIR/$name/"
  copied=$((copied + 1))
done

echo "[sync] mirrored $copied skill(s) into minimax/skills/ ($skipped skipped)"

# --- drift check (should be silent after a successful copy) ---
if diff -rq "$SOURCE_DIR" "$TARGET_DIR" --exclude=_shared >/dev/null 2>&1; then
  echo "[sync] no drift: minimax/skills/ matches skills/"
else
  echo "WARN: drift detected between skills/ and minimax/skills/" >&2
  diff -rq "$SOURCE_DIR" "$TARGET_DIR" --exclude=_shared || true
  exit 2
fi

# --- manifest integrity (warn, don't fail) ---
if command -v jq >/dev/null 2>&1; then
  # Listed paths that don't exist on disk
  while IFS= read -r entry; do
    if [ ! -f "$REPO_ROOT/minimax/$entry" ]; then
      echo "WARN: manifest lists minimax/$entry but file is missing" >&2
    fi
  done < <(jq -r '.skills[]' "$MANIFEST")
  # Skills on disk not listed in manifest
  for d in "$TARGET_DIR"/*/; do
    [ -d "$d" ] || continue
    name="$(basename "$d")"
    if ! jq -e --arg p "skills/$name/SKILL.md" '.skills | index($p)' "$MANIFEST" >/dev/null; then
      echo "WARN: minimax/skills/$name/ exists but is NOT listed in $MANIFEST" >&2
      echo "      → add \"skills/$name/SKILL.md\" to the skills array in $MANIFEST" >&2
    fi
  done
  echo "[sync] manifest integrity checked"
else
  echo "[sync] jq not installed, skipping manifest integrity check"
fi

echo "[sync] done."
