---
cap_id: cap-extract-brief
verb: extract
object: brief
stage: discover
inputs: [goal-statement]
outputs: [brief]
preconditions: []
side_effects: ["writes: artifacts/brief.md"]
failure_modes: [vague-goal, missing-metrics, no-non-goals]
leveling: G3-V0-P2-M3
---

# Discovery Brief

Create a structured project brief that turns a vague goal into clear boundaries.

## Process

1. **Gather Input**: Collect the user's goal statement, any existing materials (repos, docs, screenshots, papers)
2. **Analyze Context**: Use repo-explorer or literature-review if applicable
3. **Draft Brief**: Fill in all template sections
4. **Validate**: Ensure every field has a clear sentence, metrics are measurable, non-goals explicit

## Brief Template

```markdown
# Project Brief: [Title]

## Problem Statement
What problem are we solving? Who has this problem? Why does it matter now?

## Users / Stakeholders
Who will use the output? Who cares about the outcome?

## Context
What exists today? What prior work is relevant? What constraints exist (time/budget/tech)?

## Constraints
- Technical: [language, framework, infrastructure limits]
- Time: [deadlines, milestones]
- Resources: [team, compute, data]
- Domain: [regulatory, compatibility, standards]

## Success Metrics
| Metric | Target | How to Measure |
|---|---|---|
| [metric 1] | [target] | [measurement method] |

## Non-Goals (Explicit)
What are we NOT doing? What's out of scope?

## Open Questions
What do we still need to figure out?

## References
- [link to relevant docs/repos/papers]
```

## Done Criteria
- Every field has a clear, specific sentence (no placeholders)
- Metrics are measurable with defined targets
- Non-goals section has at least 2 items
- Open questions are actionable (not vague)

## Output
Save to `artifacts/brief.md` in the project directory.
