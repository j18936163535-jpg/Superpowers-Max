#!/usr/bin/env bash
# sync-minimax.sh — Mirror skills/ into the MiniMax Plugin V1 subdir AND the
# local install dir.
#
# Plugin V1 forbids multi-vendor manifests in one package, so the MiniMax
# plugin lives in its own subdir (minimax/) and is kept in sync via this
# script. Run after any change to skills/ (add/remove/rewrite a skill).
#
# One-shot workflow:
#   bash scripts/sync-minimax.sh       # sync repo subdir + local install
#   git add . && git commit && git push
#
# Local install target (overridable via env):
#   SUPERPOWERS_MAX_LOCAL_PLUGIN_DIR
#     default: $DATA_DIR/plugins/superpowers-max
#              (DATA_DIR resolves to /Users/lala/.minimax by default)
#
# Skip local install with:  SYNC_MINIMAX_LOCAL=0 bash scripts/sync-minimax.sh
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

# Default local install dir follows MiniMax Code's data dir convention.
# Allow override via env for users with non-default data dirs.
if [ -n "${SUPERPOWERS_MAX_LOCAL_PLUGIN_DIR:-}" ]; then
  LOCAL_DIR="$SUPERPOWERS_MAX_LOCAL_PLUGIN_DIR"
else
  # MiniMax Code's active data dir (matches runtime-data-context: activeDataDir).
  # Fall back to ~/.minimax if the env var isn't set (e.g. in CI).
  DATA_DIR="${Mavis_DATA_DIR:-$HOME/.minimax}"
  LOCAL_DIR="$DATA_DIR/plugins/superpowers-max"
fi

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

# --- mirror minimax/ -> local install (Plugin V1 official path) ---
if [ "${SYNC_MINIMAX_LOCAL:-1}" = "0" ]; then
  echo "[sync] local install sync skipped (SYNC_MINIMAX_LOCAL=0)"
else
  # Make sure parent dir exists, then copy CONTENTS of minimax/ into LOCAL_DIR
  # (not minimax/ as a wrapper — LOCAL_DIR IS the plugin root per V1 spec).
  mkdir -p "$LOCAL_DIR"
  # Wipe stale skills/* dirs from the local install before re-copying
  # (handles the case where a skill was removed from the canonical tree).
  if [ -d "$LOCAL_DIR/skills" ]; then
    for d in "$LOCAL_DIR/skills"/*/; do
      [ -d "$d" ] || continue
      name="$(basename "$d")"
      [ "$name" = "_shared" ] && continue
      if [ ! -d "$SOURCE_DIR/$name" ]; then
        rm -rf "$d"
        echo "[sync] removed stale local skill: $name"
      fi
    done
  fi
  cp -R "$REPO_ROOT/minimax/." "$LOCAL_DIR/"
  echo "[sync] pushed to local install: $LOCAL_DIR"
fi

echo "[sync] done."
