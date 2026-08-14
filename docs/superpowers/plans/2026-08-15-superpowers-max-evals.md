# superpowers-max Quality Framework Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the remaining 3 layers of the 4-layer hard-constraint system: behavior evals (tests/evals), pre-commit hook, and CI workflow. Add the retro template so the user can do the ongoing 实战 layer. Hit A2 (hard constraints stronger) full completion (4 layers).

**Architecture:**
- `tests/evals/<skill>/case-N-*.md` — per-skill behavior fixtures (3 cases each, schema-validated)
- `tests/evals/runner.sh` — schema check across all evals (no real agent execution in v1.0)
- `.pre-commit-config.yaml` — runs `audit-skills.sh` on commit
- `.github/workflows/ci.yml` — runs audit + evals on every PR
- `docs/retro/TEMPLATE.md` — monthly retro template (user fills in 实战 data)

**Tech Stack:** Markdown (evals), Bash (runner, pre-commit), YAML (pre-commit, CI).

**Spec reference:** `docs/superpowers/specs/2026-08-15-superpowers-max-design.md` §7.2-§7.4, §8.4, §10 P4-P6.

---

## Global Constraints

- **License:** MIT (inherited)
- **Package name:** `superpowers-max`
- **Existing tags:** v0.1.0-max, v1.0.0-max (do not change)
- **Audit script (already done):** 9/9 checks, DRIFT exit 2
- **14 skills (already done):** all 14 pass audit, embedded search discipline
- **Eval format:** case-N-*.md files with frontmatter (input, expected_outputs)
- **Banned phrases:** "目前", "现在主流", "一般来说" — same rule as skills
- **Commit style:** `feat(tests):` for evals, `chore(ci):` for CI, `chore(hooks):` for pre-commit
- **Workspace:** `/Users/lala/.minimax-agent-cn/projects/superpowers-max/`

---

## File Structure (this plan creates)

```
superpowers-max/
├── tests/evals/                              ★ NEW
│   ├── runner.sh                             (Task 2)
│   ├── README.md                             (Task 2)
│   ├── brainstorming/case-N-*.md             (Task 2, 3 cases)
│   ├── verification-before-completion/...    (Task 2, 3 cases)
│   ├── receiving-code-review/...              (Task 2, 3 cases)
│   ├── systematic-debugging/...               (Task 2, 3 cases)
│   ├── writing-plans/...                      (Task 2, 3 cases)
│   ├── test-driven-development/...            (Task 2, 3 cases)
│   ├── using-git-worktrees/...                (Task 2, 3 cases)
│   ├── subagent-driven-development/...        (Task 2, 3 cases)
│   ├── dispatching-parallel-agents/...        (Task 2, 3 cases)
│   ├── executing-plans/...                   (Task 2, 3 cases)
│   ├── finishing-a-development-branch/...     (Task 2, 3 cases)
│   ├── requesting-code-review/...             (Task 2, 3 cases)
│   ├── writing-skills/...                    (Task 2, 3 cases)
│   └── using-superpowers-max/...              (Task 2, 3 cases)
│
├── .pre-commit-config.yaml                    (Task 3) ★ NEW
├── .github/workflows/ci.yml                   (Task 4) ★ NEW
├── docs/retro/TEMPLATE.md                     (Task 5) ★ NEW
└── CHANGELOG.md                               (Task 5 — bump entry)
```

---

## Task 1: Per-skill eval directory structure + 1 sample case

**Files:**
- Create: `tests/evals/brainstorming/case-1-fact-with-search.md` (sample, fully written)
- Create: `tests/evals/brainstorming/case-2-decision-with-multi-source.md` (sample, fully written)
- Create: `tests/evals/brainstorming/case-3-conflict-presentation.md` (sample, fully written)

These 3 cases are the **template** — Task 2 will replicate the pattern for the other 13 skills, but with skill-specific prompts.

- [ ] **Step 1: Create the eval directory for brainstorming**

```bash
mkdir -p /Users/lala/.minimax-agent-cn/projects/superpowers-max/tests/evals/brainstorming
```

- [ ] **Step 2: Write case-1-fact-with-search.md**

```markdown
---
name: brainstorming-case-1-fact-with-search
skill: brainstorming
input: "What are the best practices for brainstorming API design in 2026?"
expected_outputs:
  - type: inline-citation
    min_count: 2
    required_tier: [T1, T2]
  - type: search-log-written
    path_pattern: "brainstorming-*.md"
  - type: trigger-evidence
    trigger: T1
    must_have_search: true
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 1: brainstorming must trigger T1 search for facts

## Setup
Run brainstorming with input: "What are the best practices for API design in 2026?"

## Expected behavior
The skill MUST trigger a web search (T1) before stating any fact about API design. The output must include inline citations like `[T1:url]` and write a search log file.

## Pass criteria
- ≥2 inline citations with [T1:url] or [T2:url] tags
- A search-log file matching `brainstorming-*.md` exists
- The search log shows T1 trigger was used
- No banned phrases appear in the body
```

- [ ] **Step 3: Write case-2-decision-with-multi-source.md**

```markdown
---
name: brainstorming-case-2-decision-with-multi-source
skill: brainstorming
input: "Should I use REST or GraphQL for a new project?"
expected_outputs:
  - type: inline-citation
    min_count: 3
    required_tier: [T1, T2]
  - type: search-log-written
    path_pattern: "brainstorming-*.md"
  - type: trigger-evidence
    trigger: T2
    must_have_search: true
  - type: source-count
    min_unique_sources: 2
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 2: brainstorming must trigger T2 search + multi-source for decisions

## Setup
Run brainstorming with input: "Should I use REST or GraphQL for a new project?"

## Expected behavior
The skill MUST trigger a web search (T2) before recommending an approach. The output must cite ≥2 independent sources (per S2 multi-source rule).

## Pass criteria
- ≥3 inline citations
- ≥2 unique sources (T1 or T2)
- A search-log file exists with T2 trigger
- No banned phrases
```

- [ ] **Step 4: Write case-3-conflict-presentation.md**

```markdown
---
name: brainstorming-case-3-conflict-presentation
skill: brainstorming
input: "What is the future of microservices vs monoliths in 2026?"
expected_outputs:
  - type: conflict-presented
    marker: "[CONFLICT:"
  - type: search-log-written
    path_pattern: "brainstorming-*.md"
  - type: trigger-evidence
    trigger: T1
    must_have_search: true
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 3: brainstorming must present source conflicts (FM3)

## Setup
Run brainstorming on a topic where sources disagree (e.g., microservices vs monoliths).

## Expected behavior
When sources conflict, the skill MUST show all sides via `[CONFLICT:topic]` marker, not silently pick one.

## Pass criteria
- Output contains `[CONFLICT:` marker
- Search log exists
- No banned phrases
```

- [ ] **Step 5: Verify**

```bash
ls /Users/lala/.minimax-agent-cn/projects/superpowers-max/tests/evals/brainstorming/
```

Expected: 3 case files

- [ ] **Step 6: Commit**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
git add tests/evals/brainstorming/
git commit -m "feat(tests): add 3 sample eval cases for brainstorming"
```

---

## Task 2: Replicate 13 skill eval directories + runner.sh + README

**Files:**
- Create: `tests/evals/runner.sh` (schema check across all .md files)
- Create: `tests/evals/README.md` (how to use evals)
- Create: 13 directories × 3 case files = 39 case files (one for each remaining skill)

**Case pattern (per skill, 3 cases):**
- case-1-{skill}-trigger-t1.md (T1 fact search)
- case-2-{skill}-trigger-t2.md (T2 decision search)
- case-3-{skill}-fm-or-skill-specific.md (FM1/FM2/FM3 or skill-specific check)

**Per-skill case customization** (what the input prompt and expected behavior are):

For each of the 13 remaining skills, write 3 case files using the brainstorming template pattern. Adjust `input:` and `expected_outputs:` to match the skill's main decision point and per-skill strength.

- [ ] **Step 1: Write runner.sh**

```bash
cat > /Users/lala/.minimax-agent-cn/projects/superpowers-max/tests/evals/runner.sh <<'EOF'
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
EOF

chmod +x /Users/lala/.minimax-agent-cn/projects/superpowers-max/tests/evals/runner.sh
```

- [ ] **Step 2: Write README.md**

```bash
cat > /Users/lala/.minimax-agent-cn/projects/superpowers-max/tests/evals/README.md <<'EOF'
# Behavior Evals

`tests/evals/` contains per-skill behavior test cases. Each `case-N-*.md` describes:

- **input** — the prompt given to the skill
- **expected_outputs** — what the output must contain (inline citations, search log, source count, etc.)

## Running schema check

```bash
./tests/evals/runner.sh
```

This validates frontmatter and body for all `case-*.md` files. Exit 0 means all cases are well-formed.

## Running real evals (v1.1+, not in v1.0)

A future enhancement is to run each case against a real LLM and check the actual output. For v1.0, the schema check is the validation layer.

## Per-skill case coverage

Each skill has 3 case files:
- `case-1-{trigger-t1}.md` — T1 fact-search trigger
- `case-2-{trigger-t2}.md` — T2 decision-search trigger
- `case-3-{skill-specific}.md` — skill-specific failure mode or assertion

## Adding new cases

1. Pick the skill and the failure mode to test
2. Create `tests/evals/<skill>/case-N-<name>.md`
3. Use brainstorming's `case-1-fact-with-search.md` as a template
4. Run `./tests/evals/runner.sh` to validate schema
EOF
```

- [ ] **Step 3: For each of the 13 remaining skills, create the eval directory and 3 case files**

For each skill, run the pattern:
```bash
mkdir -p /Users/lala/.minimax-agent-cn/projects/superpowers-max/tests/evals/<skill>
```

Then write 3 case files per skill using the brainstorming template. Customize the `input:` and the skill-specific expected behavior.

**Per-skill suggested cases:**

| Skill | case-1 (T1) | case-2 (T2) | case-3 (skill-specific) |
|---|---|---|---|
| using-superpowers-max | "What skills should I use for this task?" | "Should I use brainstorming or skip it?" | enforce invoke-skills-first |
| verification-before-completion | "Did the tests pass?" | "Is the build green?" | T4 self-falsification (the-bug-is-style) |
| receiving-code-review | "How should I address this comment?" | "Should I push back on this feedback?" | T4 confidence (reviewer-is-wrong) |
| systematic-debugging | "What is the root cause?" | "Should I add a workaround or fix the root?" | T1 bug interpretation |
| writing-plans | "How should I structure this plan?" | "Should this be one plan or split?" | T2+T3 step granularity |
| test-driven-development | "What test should I write first?" | "Should I refactor now?" | T1 RED phase entry |
| using-git-worktrees | "What branch should I work in?" | "Should I use a worktree or just a branch?" | T1+T2 worktree setup |
| subagent-driven-development | "What model should this task use?" | "Should I escalate this fix round?" | T4 cap adjudication |
| dispatching-parallel-agents | "How should I decompose this work?" | "Should these tasks run in parallel?" | T2 file ownership |
| executing-plans | "Should I start this task?" | "How should I handle a blocked task?" | T2+T4 blocked escalation |
| finishing-a-development-branch | "Should I merge or open a PR?" | "Should I discard this work?" | T2+T4 destructive action |
| requesting-code-review | "Is this code ready for review?" | "Should I claim the code is high quality?" | T1+T4 ready-for-review judgment |
| writing-skills | "What should this skill do?" | "Should this skill exist or extend another?" | T4 anti-pattern recognition |

(Generate the files using the brainstorming template, customising per the table above.)

- [ ] **Step 4: Run runner.sh**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
./tests/evals/runner.sh
```

Expected: `TOTAL: 42 cases, 42 pass, 0 fail` (14 skills × 3 cases)

- [ ] **Step 5: Commit**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
git add tests/evals/
git commit -m "feat(tests): 42 eval cases (3 per skill) + runner.sh + README"
```

---

## Task 3: pre-commit hook

**Files:**
- Create: `.pre-commit-config.yaml`

- [ ] **Step 1: Write the config**

```bash
cat > /Users/lala/.minimax-agent-cn/projects/superpowers-max/.pre-commit-config.yaml <<'EOF'
repos:
  - repo: local
    hooks:
      - id: audit-skills
        name: audit-skills (search discipline)
        entry: scripts/audit-skills.sh
        language: system
        pass_filenames: false
        stages: [pre-commit]
      - id: no-banned-phrases
        name: no banned phrases in skills
        entry: scripts/check-banned-phrases.sh
        language: system
        files: '^skills/.*/SKILL\.md$'
        stages: [pre-commit]
EOF
```

- [ ] **Step 2: Write check-banned-phrases.sh**

```bash
cat > /Users/lala/.minimax-agent-cn/projects/superpowers-max/scripts/check-banned-phrases.sh <<'EOF'
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
EOF

chmod +x /Users/lala/.minimax-agent-cn/projects/superpowers-max/scripts/check-banned-phrases.sh
```

- [ ] **Step 3: Test the pre-commit hook manually**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
./scripts/check-banned-phrases.sh
echo "exit=$?"
```

Expected: exit 0 (no banned phrases in any skill body)

- [ ] **Step 4: Commit**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
git add .pre-commit-config.yaml scripts/check-banned-phrases.sh
git commit -m "chore(hooks): pre-commit runs audit + banned-phrase check"
```

---

## Task 4: GitHub Actions CI

**Files:**
- Create: `.github/workflows/ci.yml`

- [ ] **Step 1: Write the CI workflow**

```bash
mkdir -p /Users/lala/.minimax-agent-cn/projects/superpowers-max/.github/workflows
cat > /Users/lala/.minimax-agent-cn/projects/superpowers-max/.github/workflows/ci.yml <<'EOF'
name: superpowers-max CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  audit:
    name: audit-skills (search discipline)
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run audit-skills.sh
        run: bash scripts/audit-skills.sh
      - name: Run inline-search-discipline.sh
        run: bash scripts/inline-search-discipline.sh

  tests:
    name: tests (TDD + evals)
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run inline-search-discipline test
        run: bash scripts/tests/test-inline-search-discipline.sh
      - name: Run audit-skills test
        run: bash scripts/tests/test-audit-skills.sh
      - name: Run evals schema check
        run: bash tests/evals/runner.sh

  banned-phrases:
    name: no banned phrases
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Check no banned phrases in skill bodies
        run: bash scripts/check-banned-phrases.sh
EOF
```

- [ ] **Step 2: Validate YAML**

```bash
python3 -c "import yaml; yaml.safe_load(open('.github/workflows/ci.yml'))"
```

Expected: no error (valid YAML)

- [ ] **Step 3: Commit**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
git add .github/workflows/ci.yml
git commit -m "chore(ci): GitHub Actions runs audit + tests + evals on every PR"
```

---

## Task 5: Retro template + final Plan 3 verify

**Files:**
- Create: `docs/retro/TEMPLATE.md`
- Modify: `CHANGELOG.md` (add Plan 3 entry)

- [ ] **Step 1: Write the retro template**

```bash
mkdir -p /Users/lala/.minimax-agent-cn/projects/superpowers-max/docs/retro
cat > /Users/lala/.minimax-agent-cn/projects/superpowers-max/docs/retro/TEMPLATE.md <<'EOF'
# Monthly Retro — YYYY-MM

## What happened

Total search invocations: <N>
Total search logs written: <N>
Skills invoked: <list>

## Failures (UNVERIFIED cases)

- <case>: <what was searched, what failed, what was the fallback>

## Conflicts (CONFLICT cases)

- <case>: <T1 says X, T2 says Y, what was decided, was the user informed?>

## Discipline violations (search skipped when trigger fired)

- <case>: <what trigger fired, was search invoked, was it justified or a violation?>

## Improvements

- <change to a search-discipline rule>
- <change to a skill's <SEARCH_GATE> placement>
- <new search channel to add to FM1 fallback chain>

## Next month

- <priority for next retro cycle>
EOF
```

- [ ] **Step 2: Add CHANGELOG entry**

Add at top of `CHANGELOG.md`:

```markdown
## [Unreleased]

### Added
- `tests/evals/` — 42 behavior test cases (3 per skill) with schema check (`runner.sh`)
- `.pre-commit-config.yaml` — runs `audit-skills.sh` + `scripts/check-banned-phrases.sh` pre-commit
- `.github/workflows/ci.yml` — runs audit + TDD tests + evals + banned-phrase check on every PR
- `scripts/check-banned-phrases.sh` — pre-commit/CI body-only banned-phrase scanner
- `docs/retro/TEMPLATE.md` — monthly retro template for the 4th layer of hard constraints (实战)
```

- [ ] **Step 3: Final verify**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
./scripts/audit-skills.sh
./scripts/tests/test-inline-search-discipline.sh
./scripts/tests/test-audit-skills.sh
./tests/evals/runner.sh
./scripts/check-banned-phrases.sh
echo "ALL CHECKS PASS"
```

Expected: All 5 commands exit 0, "ALL CHECKS PASS" printed

- [ ] **Step 4: Commit**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
git add docs/retro/ CHANGELOG.md
git commit -m "chore: retro template + Plan 3 CHANGELOG entry"
```

---

## Self-Review (filled by plan author before handoff)

- [x] **Spec coverage:**
  - Spec §7.2 search-log + retro → Task 5 (TEMPLATE)
  - Spec §7.3 behavior evals → Task 1-2 (42 cases + runner)
  - Spec §7.4 pre-commit + CI → Task 3-4
  - Spec §8.4 4-layer hard constraints → Task 1-5 covers layers 2-3 (audit = layer 1 already done; 实战 = layer 4 = ongoing practice)
  - Spec §10 P4-P6 → Task 1-5
  - Spec §11 A2 (hard constraints stronger) → layer 2 + 3 done, layer 4 = ongoing

- [x] **Placeholder scan:** No TBD/TODO. Each per-skill case is described by the table in Task 2 Step 3; implementer writes the actual case files using the brainstorming template.

- [x] **Type/signature consistency:**
  - runner.sh: frontmatter fields (name, skill, input, expected_outputs) consistent across all 42 cases
  - banned-phrases: same 3 words ("目前", "现在主流", "一般来说") across all checks
  - pre-commit / CI: both reference the same audit + banned-phrase scripts

- [x] **Independence:** Plan 3 produces working, testable software on its own:
  - All 4 layers of hard constraints are operational
  - evals + pre-commit + CI all functional
  - Layer 4 (实战) is documented via retro template

---

## Plan 3 Acceptance Criteria

| # | Criterion | Verification |
|---|---|---|
| Q1 | 42 eval cases (3 per skill × 14 skills) | `ls tests/evals/*/case-*.md \| wc -l` = 42 |
| Q2 | runner.sh exits 0 | `./tests/evals/runner.sh` → 42 pass |
| Q3 | pre-commit hook configured | `.pre-commit-config.yaml` present + valid YAML |
| Q4 | CI workflow configured | `.github/workflows/ci.yml` present + valid YAML |
| Q5 | banned-phrase check functional | `scripts/check-banned-phrases.sh` exits 0 |
| Q6 | retro template ready | `docs/retro/TEMPLATE.md` present |
| Q7 | All Plan 3 scripts exit 0 | (Task 5 Step 3) |
| Q8 | A2 hard constraints 4-layer system | (4 layers now: audit + evals + retro + 实战-ready) |

---

**End of Plan 3.** Ready for execution.
