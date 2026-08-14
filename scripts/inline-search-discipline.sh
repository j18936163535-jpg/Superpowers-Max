#!/usr/bin/env bash
# inline-search-discipline.sh
# Sync skills/_shared/*.md into each skills/*/SKILL.md's <SEARCH_DISCIPLINE> block.
# - If anchor exists: replace its body with concatenated shared content.
# - If anchor missing: insert anchor at top of SKILL.md.
set -euo pipefail

# Use current working directory (allows tests to point script at a temp repo).
# Production: invoke as `cd <project-root> && ./scripts/inline-search-discipline.sh`.
REPO_ROOT="$(pwd)"
SHARED_DIR="$REPO_ROOT/skills/_shared"
SKILLS_DIR="$REPO_ROOT/skills"

if [ ! -d "$SHARED_DIR" ]; then
  echo "ERROR: $SHARED_DIR not found" >&2
  exit 1
fi

# Concatenate shared rules into a temp file
RULES_TMP="$(mktemp)"
trap "rm -f $RULES_TMP" EXIT
cat "$SHARED_DIR/triggers.md" "$SHARED_DIR/source-quality.md" \
    "$SHARED_DIR/output-format.md" "$SHARED_DIR/failure-modes.md" > "$RULES_TMP"

python3 - "$SHARED_DIR" "$SKILLS_DIR" "$RULES_TMP" <<'PYEOF'
import sys, os, re

shared_dir, skills_dir, rules_tmp = sys.argv[1], sys.argv[2], sys.argv[3]
with open(rules_tmp, 'r') as f:
    rules = f.read()

anchor_re = re.compile(r'<SEARCH_DISCIPLINE>.*?</SEARCH_DISCIPLINE>', re.DOTALL)
new_block = f'<SEARCH_DISCIPLINE>\n{rules}\n</SEARCH_DISCIPLINE>'

updated = 0
for entry in sorted(os.listdir(skills_dir)):
    if entry == '_shared':
        continue
    skill_md = os.path.join(skills_dir, entry, 'SKILL.md')
    if not os.path.isfile(skill_md):
        continue
    with open(skill_md, 'r') as f:
        content = f.read()
    if anchor_re.search(content):
        new_content = anchor_re.sub(lambda m: new_block, content, count=1)
        action = 'replaced'
    else:
        new_content = new_block + '\n\n' + content
        action = 'inserted'
    with open(skill_md, 'w') as f:
        f.write(new_content)
    print(f'  {action}: {skill_md}')
    updated += 1

print(f'Done: {updated} skill(s) updated')
PYEOF
