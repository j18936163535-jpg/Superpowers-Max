#!/usr/bin/env bash
# inline-preamble.sh
# Inject the mandatory search-discipline preamble at the top of every SKILL.md.
#
# - If the <MANDATORY_PREAMBLE> anchor exists: replace its body with the
#   canonical content from skills/_shared/mandatory-preamble.md.
# - If the anchor is missing: insert it after the YAML frontmatter, before
#   any other content (including <SEARCH_DISCIPLINE>).
#
# Idempotent. Run after any edit to the shared preamble.

set -euo pipefail

REPO_ROOT="$(pwd)"
SHARED_PREAMBLE="$REPO_ROOT/skills/_shared/mandatory-preamble.md"
SKILLS_DIR="$REPO_ROOT/skills"

if [ ! -f "$SHARED_PREAMBLE" ]; then
  echo "ERROR: $SHARED_PREAMBLE not found" >&2
  exit 1
fi

RULES_TMP="$(mktemp)"
trap "rm -f $RULES_TMP" EXIT
cp "$SHARED_PREAMBLE" "$RULES_TMP"

python3 - "$SHARED_PREAMBLE" "$SKILLS_DIR" "$RULES_TMP" <<'PYEOF'
import sys, os, re

shared_path, skills_dir, rules_tmp = sys.argv[1], sys.argv[2], sys.argv[3]
with open(rules_tmp, 'r') as f:
    preamble = f.read()

anchor_re = re.compile(r'<MANDATORY_PREAMBLE>.*?</MANDATORY_PREAMBLE>', re.DOTALL)
new_block = f'<MANDATORY_PREAMBLE>\n{preamble}\n</MANDATORY_PREAMBLE>'

# Frontmatter regex: matches `---` ... `---` at the very top of the file.
fm_re = re.compile(r'\A---\n(.*?)\n---\n', re.DOTALL)

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
        # Replace existing block
        new_content = anchor_re.sub(lambda m: new_block, content, count=1)
        action = 'replaced'
    else:
        # Insert after frontmatter. If no frontmatter, insert at very top.
        m = fm_re.match(content)
        if m:
            new_content = content[:m.end()] + '\n' + new_block + '\n\n' + content[m.end():]
        else:
            new_content = new_block + '\n\n' + content
        action = 'inserted'

    with open(skill_md, 'w') as f:
        f.write(new_content)
    print(f'  {action}: {skill_md}')
    updated += 1

print(f'Done: {updated} skill(s) updated')
PYEOF
