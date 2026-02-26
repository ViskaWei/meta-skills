---
cap_id: cap-capture-card
verb: capture
object: card
stage: knowledge
inputs: [experiment-retro, design-principles]
outputs: [knowledge-card]
preconditions: []
side_effects: ["writes: knowledge/<card-id>.md"]
failure_modes: [missing-context, non-actionable-learning]
leveling: G3-V0-P2-M3
---

# Knowledge Capture

Create a searchable, reusable knowledge card from a project or experiment.

## Template

```markdown
# Knowledge Card: [Title]
_Created: [YYYY-MM-DD]_
_Source: [project/experiment that produced this knowledge]_
_Tags: [searchable tags]_

## What
[What was learned — 2-3 sentences]

## Why It Matters
[Why this knowledge is important — when would someone need this?]

## How
[How to apply this knowledge — specific steps or code]

## Example
[Concrete example demonstrating the knowledge]

## Pitfalls
- [common mistake 1]
- [common mistake 2]

## Related
- [link to related cards/docs/experiments]
```

## Done Criteria
- Card is self-contained (no external context needed)
- Tags enable discovery
- Example is concrete and reproducible
- At least 1 pitfall documented

## Integration
- Save to project's `knowledge/` directory
- Update MEMORY.md if cross-project
- Broadcast via `_tools/research/broadcast.md` if relevant to multiple projects
