---
name: subagent-driven-development-case-2-trigger-t2-escalation-decision
skill: subagent-driven-development
input: "Should I escalate this fix round?"
expected_outputs:
  - type: inline-citation
    min_count: 3
    required_tier: [T1, T2]
  - type: search-log-written
    path_pattern: "subagent-driven-development-*.md"
  - type: trigger-evidence
    trigger: T2
    must_have_search: true
  - type: source-count
    min_unique_sources: 2
  - type: no-banned-phrases
    banned: ["目前", "现在主流", "一般来说"]
---

# Case 2: subagent-driven-development must trigger T2 search + multi-source for escalation decisions

## Setup
Run subagent-driven-development with input: "Should I escalate this fix round?"

## Expected behavior
The skill MUST trigger a web search (T2) before recommending a sub-agent escalation. The output must cite ≥2 independent sources (per S2 multi-source rule) so the escalation rationale is grounded.

## Pass criteria
- ≥3 inline citations
- ≥2 unique sources (T1 or T2)
- A search-log file exists with T2 trigger
- No banned phrases
