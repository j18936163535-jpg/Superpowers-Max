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
