---
cap_id: cap-extract-requirements
verb: extract
object: requirements
stage: discover
inputs: [brief, context-map]
outputs: [requirements-list]
preconditions: ["brief exists"]
side_effects: ["writes: artifacts/requirements.md"]
failure_modes: [ambiguous-brief, missing-acceptance-criteria]
leveling: G3-V0-P2-M3
---

# Requirements Extraction

Extract structured requirements from a Brief using MoSCoW prioritization.

## Prerequisites
- `artifacts/brief.md` must exist

## Process

1. **Read Brief**: Load the project brief
2. **Extract Requirements**: From problem statement, users, constraints, and metrics
3. **Categorize**: MoSCoW (Must/Should/Could/Won't)
4. **Add Acceptance Criteria**: Each requirement gets "how to verify"

## Requirements Template

```markdown
# Requirements: [Project Title]
_Derived from: artifacts/brief.md_

## Must Have (P0)
| ID | Requirement | Acceptance Criteria | Verification Method |
|---|---|---|---|
| R-001 | [requirement] | [what "done" looks like] | [how to test] |

## Should Have (P1)
| ID | Requirement | Acceptance Criteria | Verification Method |
|---|---|---|---|

## Could Have (P2)
| ID | Requirement | Acceptance Criteria | Verification Method |
|---|---|---|---|

## Won't Have (P3 — explicit exclusions)
| ID | Requirement | Reason for Exclusion |
|---|---|---|

## Dependencies
- [external dependency or prerequisite]

## Assumptions
- [assumption that, if wrong, changes requirements]
```

## Done Criteria
- Every requirement has a verification method
- P0 requirements map directly to success metrics in Brief
- At least 2 explicit Won't Have items
- No requirement is ambiguous (a third person can verify independently)

## Output
Save to `artifacts/requirements.md` in the project directory.
