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
