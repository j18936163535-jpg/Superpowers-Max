# superpowers-max Skills Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rewrite all 14 upstream skills with embedded search-discipline (anchor A) + per-skill `<SEARCH_GATE>` blocks, hardening audit-skills.sh to detect drift + SEARCH_GATE counts, and ship v1.0.0-max.

**Architecture:** Each `skills/<name>/SKILL.md` is rewritten by (1) reading the upstream version, (2) preserving its structure and content, (3) adding `<SEARCH_DISCIPLINE>` anchor at the top (auto via `inline-search-discipline.sh`), (4) adding `<SEARCH_GATE>` blocks at major decision points per per-skill strength mapping. Audit script gets 2 hardening items. Final tag: v1.0.0-max.

**Tech Stack:** Markdown (skills), Bash (audit), Python (audit script helpers).

**Spec reference:** `docs/superpowers/specs/2026-08-15-superpowers-max-design.md` §4.2 (per-skill strength), §5 (search-discipline), §6 (per-skill改造模式), §7.1 (audit 9 checks).

**Upstream source:** `/Users/lala/.minimax-agent-cn/projects/superpowers/skills/<name>/SKILL.md`

---

## Global Constraints

- **License:** MIT (inherited)
- **Package name:** `superpowers-max`
- **Target version:** `1.0.0-max` (final tag for this plan)
- **Plugin descriptors:** 6 platforms (already done in Plan 1; do not modify)
- **Search discipline:** 4 triggers (T1-T4) + 4 source rules (S1-S4) + 3 failure rules (FM1-FM3) + 3 output rules (OF1-OF3) — source-of-truth in `skills/_shared/`
- **Per-skill strength mapping** (from spec §4.2):
  - High (T1+T4 emphasis): verification-before-completion, receiving-code-review, systematic-debugging
  - Very high (T2+T3 emphasis): brainstorming, writing-plans
  - Medium: test-driven-development, subagent-driven-development, dispatching-parallel-agents, executing-plans, finishing-a-development-branch, requesting-code-review, writing-skills, using-superpowers-max
  - Low (mechanical): using-git-worktrees
- **Anchor format:** `<SEARCH_DISCIPLINE>...</SEARCH_DISCIPLINE>` block at the top of each skill (auto-populated by `inline-search-discipline.sh` running on the real `_shared/` content)
- **SEARCH_GATE format:** `<SEARCH_GATE step="<name>" triggers="T1,T2,...">` blocks at major decision points
- **Banned phrases:** "目前", "现在主流", "一般来说" — fail audit if present
- **Frontmatter required:** `name:` and `description:` in first 5 lines
- **Commit style:** `chore(skill-<name>): rewrite with search discipline` for new skills; `chore(philosophy):` for audit hardening
- **Workspace:** `/Users/lala/.minimax-agent-cn/projects/superpowers-max/`
- **Upstream skill source (read-only):** `/Users/lala/.minimax-agent-cn/projects/superpowers/skills/`

---

## File Structure (this plan creates/modifies)

```
superpowers-max/
├── skills/                                  ★ 14 new + 1 renamed skill
│   ├── using-superpowers-max/                (Task 4 — renamed from using-superpowers)
│   ├── brainstorming/                        (Task 5)
│   ├── verification-before-completion/       (Task 6)
│   ├── receiving-code-review/                (Task 7)
│   ├── systematic-debugging/                 (Task 8)
│   ├── writing-plans/                        (Task 9)
│   ├── test-driven-development/              (Task 10)
│   ├── using-git-worktrees/                  (Task 11)
│   ├── subagent-driven-development/          (Task 12)
│   ├── dispatching-parallel-agents/          (Task 13)
│   ├── executing-plans/                      (Task 14)
│   ├── finishing-a-development-branch/       (Task 15)
│   ├── requesting-code-review/               (Task 16)
│   └── writing-skills/                       (Task 17)
│
├── scripts/audit-skills.sh                   (Tasks 1-2 — hardening)
├── scripts/tests/test-audit-skills.sh        (Tasks 1-2 — test updates)
└── CHANGELOG.md                              (Task 18 — release notes)
```

---

## Task 1: Add audit check #6 (SEARCH_GATE count) — TDD

**Files:**
- Modify: `scripts/audit-skills.sh`
- Modify: `scripts/tests/test-audit-skills.sh`
- Modify: `scripts/tests/fixtures/...` (add a fixture with <SEARCH_GATE> blocks)

**Interfaces:**
- Consumes: each skill's SKILL.md
- Produces: a count of `<SEARCH_GATE>` blocks per skill; FAIL if count = 0 (since steps×50% requires ≥1 if there are any steps)

**Spec reference:** spec §7.1 check #6: "至少 N 个 <SEARCH_GATE> 散布锚点(N = 该 skill 应有步数 × 50%)"

- [ ] **Step 1: Write the failing test**

Add to `scripts/tests/test-audit-skills.sh`, AFTER the existing audit-bad-missing-trigger fixture test, add a new fixture `scripts/tests/fixtures/audit-no-search-gate/SKILL.md` containing a skill with full anchors but no `<SEARCH_GATE>` block. The audit should FAIL it with reason "gates=0".

- [ ] **Step 2: Run test to verify it fails**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
./scripts/tests/test-audit-skills.sh
```

Expected: FAIL (audit does not yet check gate count)

- [ ] **Step 3: Implement the check**

In `scripts/audit-skills.sh`, after the existing checks, add:

```bash
# Check 6: at least 1 <SEARCH_GATE> block per skill
gate_count=$(grep -c '<SEARCH_GATE' "$skill_md" || true)
if [ "$gate_count" -eq 0 ]; then
  missing+=("gates=0")
fi
```

Also: include `gates=$gate_count` in the per-skill output line so reviewers can see the count.

- [ ] **Step 4: Run test to verify it passes**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
./scripts/tests/test-audit-skills.sh
```

Expected: PASS

- [ ] **Step 5: Commit**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
git add scripts/audit-skills.sh scripts/tests/
git commit -m "chore(philosophy): add audit check #6 (SEARCH_GATE count per skill)"
```

---

## Task 2: Wire DRIFT as exit code 2 — TDD

**Files:**
- Modify: `scripts/audit-skills.sh`
- Modify: `scripts/tests/test-audit-skills.sh`

**Spec reference:** spec §7.1 exit codes: 0 = all pass, 1 = some fail, 2 = DRIFT

- [ ] **Step 1: Write the failing test**

Add a fixture `scripts/tests/fixtures/audit-drift/SKILL.md` with a stale anchor (content not matching current _shared). The test should expect exit code 2.

- [ ] **Step 2: Run test to verify it fails**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
./scripts/tests/test-audit-skills.sh
```

Expected: FAIL (drift currently folded into FAIL/1)

- [ ] **Step 3: Implement**

In `scripts/audit-skills.sh`:
- Replace the line `missing+=("drift")` with `drift_count=$((drift_count+1))` (use a new counter)
- After the loop, exit logic:
  ```bash
  if [ "$FAIL" -gt 0 ]; then exit 1; fi
  if [ "$DRIFT" -gt 0 ]; then exit 2; fi
  exit 0
  ```
- Remove the dead `DRIFT=0` line, add `DRIFT=0` to the counter init block
- Print "DRIFT: $DRIFT" in the TOTAL line

- [ ] **Step 4: Run test to verify it passes**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
./scripts/tests/test-audit-skills.sh
```

Expected: PASS

- [ ] **Step 5: Commit**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
git add scripts/audit-skills.sh scripts/tests/
git commit -m "chore(philosophy): wire DRIFT as exit 2 in audit-skills.sh"
```

---

## Task 3: Snapshot upstream skills for reference

**Files:** none (read-only inspection)

- [ ] **Step 1: Snapshot upstream SKILL.md files**

```bash
mkdir -p /Users/lala/.minimax-agent-cn/projects/superpowers-max/docs/upstream-snapshots
cp -r /Users/lala/.minimax-agent-cn/projects/superpowers/skills/* \
   /Users/lala/.minimax-agent-cn/projects/superpowers-max/docs/upstream-snapshots/
ls /Users/lala/.minimax-agent-cn/projects/superpowers-max/docs/upstream-snapshots/
```

Expected: 14 directories copied

- [ ] **Step 2: Add upstream-snapshots to .gitignore (ephemeral reference, not committed)**

```bash
# Add to .gitignore if not already:
echo "docs/upstream-snapshots/" >> /Users/lala/.minimax-agent-cn/projects/superpowers-max/.gitignore
```

(Alternatively commit snapshots as `docs/upstream-snapshots/` if you want them tracked — choice is yours. The brief says they're read-only reference; tracking is fine for history.)

- [ ] **Step 3: Commit (only if you chose to track snapshots)**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
# If you tracked snapshots:
# git add docs/upstream-snapshots/
# git commit -m "chore: snapshot upstream skills for reference"
# Otherwise: no commit
```

---

## Tasks 4-17: Per-skill rewrite (14 tasks, one per skill)

**Common pattern for each task (Tasks 4-17):**

Each task creates a new `skills/<name>/SKILL.md` (or rewrites if exists). The shape is:

1. **Read upstream**: `/Users/lala/.minimax-agent-cn/projects/superpowers/skills/<name>/SKILL.md`
2. **Create skills/<name>/ directory** in our repo
3. **Write new SKILL.md**:
   - YAML frontmatter (name + description; copy from upstream)
   - Body: copy from upstream, preserving structure (HARD-GATEs, checklists, process flows)
   - **Insert** `<SEARCH_DISCIPLINE>` placeholder block at the top (real content gets injected by inline script)
   - **Insert** `<SEARCH_GATE>` blocks at major decision points (per per-skill strength mapping)
4. **Run `inline-search-discipline.sh`** to replace the placeholder with real content
5. **Run `audit-skills.sh`** to verify 9+ checks pass for this skill
6. **Commit** with `chore(skill-<name>): rewrite with search discipline`

### Per-skill strength mapping (decides WHERE to add `<SEARCH_GATE>` blocks)

For each skill, identify the major decision/assertion points in the upstream SKILL.md. These are typically:
- "Present design" / "Propose approaches" / "Run verification"
- "X is true" / "X is the right choice"
- Sections that say "you MUST" / "HARD-GATE" / "important" / "verify"

For **high-strength skills** (verification, receiving-code-review, systematic-debugging): add `<SEARCH_GATE>` at every major step, every fact-check section, every confidence assertion. Target: 4-8 gates per skill.

For **very-high-strength skills** (brainstorming, writing-plans): add gates at the design phase entry, approach proposal, decision point, and design-doc save. Target: 3-5 gates per skill.

For **medium skills** (test-driven-development, subagent-driven-development, dispatching-parallel-agents, executing-plans, finishing-a-development-branch, requesting-code-review, writing-skills, using-superpowers-max): add gates at the 2-3 most important decision points. Target: 2-4 gates per skill.

For **low skill** (using-git-worktrees): 0-1 gates. Mechanical steps don't need search.

### Per-skill `<SEARCH_GATE>` template

```markdown
<SEARCH_GATE step="<step-name>" triggers="T1,T2">
Before <action>, you MUST:
1. T1: Web search "<topic> 2026 latest" — verify current best practice
2. T2: Search "<topic> alternatives 2026" — confirm this is the right choice
3. <skill-specific check>
4. If sources conflict, present conflict [FM3]
</SEARCH_GATE>
```

For high-strength skills, add stricter rules. For low-strength, minimal.

### Task 4: Rewrite `using-superpowers-max` (renamed from using-superpowers)

**Upstream:** `/Users/lala/.minimax-agent-cn/projects/superpowers/skills/using-superpowers/SKILL.md`

- [ ] **Step 1: Create the directory and copy upstream**

```bash
mkdir -p /Users/lala/.minimax-agent-cn/projects/superpowers-max/skills/using-superpowers-max
cp /Users/lala/.minimax-agent-cn/projects/superpowers-max/docs/upstream-snapshots/using-superpowers/SKILL.md \
   /Users/lala/.minimax-agent-cn/projects/superpowers-max/skills/using-superpowers-max/SKILL.md
```

- [ ] **Step 2: Update frontmatter**

Change `name: using-superpowers` to `name: using-superpowers-max`. Update description to mention "search discipline mandatory".

- [ ] **Step 3: Insert `<SEARCH_DISCIPLINE>` placeholder at top**

```bash
# Insert after the frontmatter, before the first heading
python3 -c "
import re
with open('skills/using-superpowers-max/SKILL.md', 'r') as f: c = f.read()
m = re.match(r'(---\n.*?\n---\n)', c, re.DOTALL)
if m:
    frontmatter = m.group(1)
    body = c[m.end():]
    placeholder = '<SEARCH_DISCIPLINE>\nPLACEHOLDER - replaced by inline-search-discipline.sh\n</SEARCH_DISCIPLINE>\n\n'
    with open('skills/using-superpowers-max/SKILL.md', 'w') as f:
        f.write(frontmatter + placeholder + body)
"
```

- [ ] **Step 4: Add `<SEARCH_GATE>` blocks at major sections**

The "Skill priority" section is a key decision point. Add a gate:

```markdown
<SEARCH_GATE step="skill-priority" triggers="T2,T4">
Before invoking any skill, you MUST:
1. T2: Web search "<skill-name> best practice 2026" to verify the skill is still relevant
2. T4: If you're about to say "I know how to do this without a skill", STOP — search for current best practice first
3. Apply T1 for any factual claim about what the skill does
</SEARCH_GATE>
```

(Use your judgment based on the upstream content. The meta-skill is the gatekeeper — it should model the discipline.)

- [ ] **Step 5: Run inline script**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
./scripts/inline-search-discipline.sh
```

- [ ] **Step 6: Run audit**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
./scripts/audit-skills.sh
```

Expected: `using-superpowers-max PASS 9/9 gates=N`

- [ ] **Step 7: Commit**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
git add skills/using-superpowers-max/
git commit -m "chore(skill-using-superpowers-max): rewrite with search discipline"
```

### Task 5: Rewrite `brainstorming`

**Upstream:** `/Users/lala/.minimax-agent-cn/projects/superpowers-max/docs/upstream-snapshots/brainstorming/SKILL.md`
**Strength:** Very high (T2+T3 emphasis)
**Target gates:** 3-5

**Suggested gate locations:**
- Before "Propose 2-3 approaches" (T2+T3)
- Before "Present design sections" (T2)
- At the "Spec self-review" step (T1)
- At the "User reviews spec?" gate (T4)

**Steps:** Same 7-step pattern as Task 4. Commit: `chore(skill-brainstorming): rewrite with search discipline`

### Task 6: Rewrite `verification-before-completion`

**Upstream:** `/Users/lala/.minimax-agent-cn/projects/superpowers-max/docs/upstream-snapshots/verification-before-completion/SKILL.md`
**Strength:** High (T1+T4 emphasis)
**Target gates:** 4-8

**Suggested gate locations:** At every "Run verification checks" subsection, every "claim" of completion, every "I verified" assertion.

**Steps:** Same 7-step pattern. Commit: `chore(skill-verification-before-completion): rewrite with search discipline`

### Task 7: Rewrite `receiving-code-review`

**Upstream:** `/Users/lala/.minimax-agent-cn/projects/superpowers-max/docs/upstream-snapshots/receiving-code-review/SKILL.md`
**Strength:** High (T1+T4 emphasis)
**Target gates:** 4-8

**Suggested gate locations:** At every "address review comment" step, every "the reviewer is wrong" judgment, every "this is the right approach" claim.

**Steps:** Same 7-step pattern. Commit: `chore(skill-receiving-code-review): rewrite with search discipline`

### Task 8: Rewrite `systematic-debugging`

**Upstream:** `/Users/lala/.minimax-agent-cn/projects/superpowers-max/docs/upstream-snapshots/systematic-debugging/SKILL.md`
**Strength:** High (T1 emphasis)
**Target gates:** 4-8

**Suggested gate locations:** At every "find root cause" step, every "X is broken because Y" claim, every "the bug is" assertion.

**Steps:** Same 7-step pattern. Commit: `chore(skill-systematic-debugging): rewrite with search discipline`

### Task 9: Rewrite `writing-plans`

**Upstream:** `/Users/lala/.minimax-agent-cn/projects/superpowers-max/docs/upstream-snapshots/writing-plans/SKILL.md`
**Strength:** Very high (T2+T3 emphasis)
**Target gates:** 3-5

**Suggested gate locations:** Before "Propose approaches", before "File Structure" decision, before "Task Right-Sizing", at "Bite-Sized Task Granularity" step.

**Steps:** Same 7-step pattern. Commit: `chore(skill-writing-plans): rewrite with search discipline`

### Task 10: Rewrite `test-driven-development`

**Upstream:** `/Users/lala/.minimax-agent-cn/projects/superpowers-max/docs/upstream-snapshots/test-driven-development/SKILL.md`
**Strength:** Medium
**Target gates:** 2-4

**Suggested gate locations:** At "RED phase" entry, at "GREEN phase" entry, at the "refactor" decision.

**Steps:** Same 7-step pattern. Commit: `chore(skill-test-driven-development): rewrite with search discipline`

### Task 11: Rewrite `using-git-worktrees`

**Upstream:** `/Users/lala/.minimax-agent-cn/projects/superpowers-max/docs/upstream-snapshots/using-git-worktrees/SKILL.md`
**Strength:** Low (mechanical)
**Target gates:** 0-1

**Suggested gate locations:** Only at the "Setup worktree" decision (which remote, which branch).

**Steps:** Same 7-step pattern. Commit: `chore(skill-using-git-worktrees): rewrite with search discipline`

### Task 12: Rewrite `subagent-driven-development`

**Upstream:** `/Users/lala/.minimax-agent-cn/projects/superpowers-max/docs/upstream-snapshots/subagent-driven-development/SKILL.md`
**Strength:** Medium
**Target gates:** 2-4

**Suggested gate locations:** At "model selection" decision, at "fix loop escalation" decision, at "adjudicate at cap" step.

**Steps:** Same 7-step pattern. Commit: `chore(skill-subagent-driven-development): rewrite with search discipline`

### Task 13: Rewrite `dispatching-parallel-agents`

**Upstream:** `/Users/lala/.minimax-agent-cn/projects/superpowers-max/docs/upstream-snapshots/dispatching-parallel-agents/SKILL.md`
**Strength:** Medium
**Target gates:** 2-4

**Suggested gate locations:** At "task decomposition" decision, at "file ownership overlap" check, at "merge conflict" resolution.

**Steps:** Same 7-step pattern. Commit: `chore(skill-dispatching-parallel-agents): rewrite with search discipline`

### Task 14: Rewrite `executing-plans`

**Upstream:** `/Users/lala/.minimax-agent-cn/projects/superpowers-max/docs/upstream-snapshots/executing-plans/SKILL.md`
**Strength:** Medium
**Target gates:** 2-4

**Suggested gate locations:** At "task start" decision, at "blocked" escalation, at "checkpoint" review.

**Steps:** Same 7-step pattern. Commit: `chore(skill-executing-plans): rewrite with search discipline`

### Task 15: Rewrite `finishing-a-development-branch`

**Upstream:** `/Users/lala/.minimax-agent-cn/projects/superpowers-max/docs/upstream-snapshots/finishing-a-development-branch/SKILL.md`
**Strength:** Medium
**Target gates:** 2-4

**Suggested gate locations:** At "merge vs PR" decision, at "discard work" confirmation, at "cleanup" step.

**Steps:** Same 7-step pattern. Commit: `chore(skill-finishing-a-development-branch): rewrite with search discipline`

### Task 16: Rewrite `requesting-code-review`

**Upstream:** `/Users/lala/.minimax-agent-cn/projects/superpowers-max/docs/upstream-snapshots/requesting-code-review/SKILL.md`
**Strength:** High (T1+T4)
**Target gates:** 4-8

**Suggested gate locations:** At every "self-review" step, every "claim about quality" assertion, every "this is ready for review" judgment.

**Steps:** Same 7-step pattern. Commit: `chore(skill-requesting-code-review): rewrite with search discipline`

### Task 17: Rewrite `writing-skills`

**Upstream:** `/Users/lala/.minimax-agent-cn/projects/superpowers-max/docs/upstream-snapshots/writing-skills/SKILL.md`
**Strength:** Medium
**Target gates:** 2-4

**Suggested gate locations:** At "name and frontmatter" step, at "checklist" decision, at "anti-patterns" judgment.

**Steps:** Same 7-step pattern. Commit: `chore(skill-writing-skills): rewrite with search discipline`

---

## Task 18: End-to-end audit + tag v1.0.0-max

**Files:**
- Modify: `CHANGELOG.md` (add v1.0.0-max entry)
- Modify: `package.json` (bump to 1.0.0-max)

- [ ] **Step 1: Run audit on all 14 skills**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
./scripts/audit-skills.sh
```

Expected: `TOTAL: 14 skills, 14 pass, 0 fail`

- [ ] **Step 2: Run inline-search-discipline.sh to confirm sync**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
./scripts/inline-search-discipline.sh
```

Expected: `Done: 14 skill(s) updated` (no-op since anchors are already correct, but confirms sync)

- [ ] **Step 3: Run both test scripts**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
./scripts/tests/test-inline-search-discipline.sh
./scripts/tests/test-audit-skills.sh
```

Expected: Both PASS

- [ ] **Step 4: Update CHANGELOG.md**

Add at top:

```markdown
## [1.0.0-max] - 2026-08-15

### Added
- All 14 upstream skills rewritten with embedded search discipline
  (T1-T4 triggers, S1-S4 source rules, FM1-FM3 failure rules, OF1-OF3 output rules)
- `using-superpowers-max` (renamed from upstream `using-superpowers`)
- Per-skill `<SEARCH_GATE>` blocks at major decision points
- Per-skill strength mapping (high/medium/low research density)
- Audit script hardening: check #6 (SEARCH_GATE count) + DRIFT exit 2

### Changed
- `audit-skills.sh`: 8/9 → 9/9 checks; new exit code 2 for DRIFT
- All skill files embed `<SEARCH_DISCIPLINE>` block at top
```

- [ ] **Step 5: Update package.json version to 1.0.0-max**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
python3 -c "
import json
with open('package.json') as f: p = json.load(f)
p['version'] = '1.0.0-max'
with open('package.json', 'w') as f: json.dump(p, f, indent=2)
"
```

Also update `.version-bump.json`:
```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
python3 -c "
import json
with open('.version-bump.json') as f: p = json.load(f)
p['current_version'] = '1.0.0-max'
p['bump_type'] = 'major'
with open('.version-bump.json', 'w') as f: json.dump(p, f, indent=2)
"
```

- [ ] **Step 6: Commit version bump**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
git add CHANGELOG.md package.json .version-bump.json
git commit -m "chore: bump to 1.0.0-max"
```

- [ ] **Step 7: Tag v1.0.0-max**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
git tag -a v1.0.0-max -m "v1.0.0-max: 14 skills rewritten with search discipline"
```

- [ ] **Step 8: Verify tag**

```bash
cd /Users/lala/.minimax-agent-cn/projects/superpowers-max
git tag -l "v1.0.0-max"
git show v1.0.0-max --stat | head -20
```

Expected: Tag exists, points to HEAD

---

## Self-Review (filled by plan author before handoff)

- [x] **Spec coverage:**
  - Spec §4.2 (per-skill strength) → Tasks 4-17 per-skill strength mapping
  - Spec §5 (search-discipline) → Tasks 1-2 (audit) + every skill's anchor
  - Spec §6 (per-skill改造模式) → Tasks 4-17 SEARCH_GATE pattern
  - Spec §7.1 audit 9 checks → Tasks 1-2 (add #6, wire DRIFT) + verify 9/9
  - Spec §11 v1.0 acceptance A1+A3 → Task 18 (all 14 skills + audit 14/14)
  - Spec §13 (CHANGELOG, RELEASE-NOTES) → Task 18

- [x] **Placeholder scan:** No TBD/TODO/"implement later". Tasks 5-17 reference upstream files and per-skill strength; implementer applies pattern.

- [x] **Type/signature consistency:** All 14 skill tasks use the same 7-step pattern. Anchor format `<SEARCH_DISCIPLINE>...</SEARCH_DISCIPLINE>` is consistent (set in Plan 1). Gate format `<SEARCH_GATE step="..." triggers="...">` is consistent.

- [x] **Independence:** Plan 2 produces working, testable software on its own:
  - All 14 skills have search discipline
  - Audit script is hardened (9/9 checks, exit 2 for drift)
  - Tag v1.0.0-max is shippable
  - Plugin descriptors (from Plan 1) are untouched and still valid

---

## Plan 2 Acceptance Criteria

| # | Criterion | Verification |
|---|---|---|
| P1 | audit-skills.sh has 9/9 checks (including #6 gate count) | `./scripts/audit-skills.sh` reports 9/9 for any complete skill |
| P2 | audit-skills.sh exits 2 on DRIFT | Drift fixture → exit 2 |
| P3 | 14 skills exist with search-discipline | `ls skills/` shows 14 dirs |
| P4 | All 14 skills pass audit (9/9, gates ≥ 1 except using-git-worktrees) | `./scripts/audit-skills.sh` → TOTAL: 14 pass |
| P5 | inline-search-discipline.sh operates on all 14 | `./scripts/inline-search-discipline.sh` → Done: 14 |
| P6 | Both test scripts pass | `./scripts/tests/test-*.sh` → both PASS |
| P7 | v1.0.0-max tag exists | `git tag -l v1.0.0-max` |
| P8 | CHANGELOG / package.json / version-bump updated | all show 1.0.0-max |

---

**End of Plan 2.** Ready for execution.
