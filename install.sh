#!/usr/bin/env bash
# install.sh — One-line installer for superpowers-max
#
# Usage:
#   curl -sL https://raw.githubusercontent.com/j18936163535-jpg/Superpowers-Max/main/install.sh | bash
#
# Optional env vars:
#   SUPERPOWERS_MAX_DATA_DIR   override data dir (default: ~/.minimax)
#   SUPERPOWERS_MAX_REF        git ref to install (default: main)
#                             (use a tag like v1.0.0-max to pin a version)
#
# This script is idempotent: re-running it re-installs the latest version.

set -euo pipefail

REPO_URL="https://github.com/j18936163535-jpg/Superpowers-Max.git"
REF="${SUPERPOWERS_MAX_REF:-main}"
DATA_DIR="${SUPERPOWERS_MAX_DATA_DIR:-$HOME/.minimax}"
PLUGIN_NAME="superpowers-max"
PLUGIN_DIR="$DATA_DIR/plugins/$PLUGIN_NAME"

echo "[install] target: $PLUGIN_DIR"
echo "[install] ref:    $REF"

# --- preconditions ---
for cmd in git; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "ERROR: '$cmd' is required but not installed" >&2
    exit 1
  fi
done

# --- clone to a temp dir, sparse-checkout the minimax/ sub-package only ---
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

git clone --depth 1 --filter=blob:none --sparse --branch "$REF" \
  "$REPO_URL" "$TMP/repo" >/dev/null 2>&1

cd "$TMP/repo"
git sparse-checkout set minimax scripts >/dev/null 2>&1

if [ ! -d "minimax" ] || [ ! -f "minimax/.minimax-plugin/plugin.json" ]; then
  echo "ERROR: cloned repo does not contain a valid minimax/ sub-package (ref=$REF)" >&2
  exit 1
fi

# --- validate V1 spec (fail loud, don't install a broken package) ---
echo "[install] validating V1 spec..."
if ! python3 -c "
import json, sys
d=json.load(open('minimax/.minimax-plugin/plugin.json'))
assert d['schemaVersion']==1, 'schemaVersion'
assert d['apps']==[], 'apps'
for s in d['skills']:
    import os
    assert os.path.isfile('minimax/'+s), f'missing: minimax/{s}'
print('  V1 spec OK,', len(d['skills']), 'skills')
"; then
  echo "ERROR: V1 spec validation failed; refusing to install a broken package" >&2
  exit 1
fi

# --- install (overwrite) ---
mkdir -p "$PLUGIN_DIR"
# wipe existing skills/* but keep the rest of the plugin metadata
if [ -d "$PLUGIN_DIR/skills" ]; then
  rm -rf "$PLUGIN_DIR/skills"
fi
cp -R minimax/. "$PLUGIN_DIR/"

echo "[install] ✓ installed $PLUGIN_NAME to $PLUGIN_DIR"
echo ""
echo "Next steps:"
echo "  1. Open MiniMax Code → '管理' tab"
echo "  2. $PLUGIN_NAME should appear (auto-rescan, or click the refresh icon)"
echo "  3. Toggle it ON if not already enabled"
echo ""
echo "To update later, re-run this command."
