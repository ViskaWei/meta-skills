---
cap_id: cap-compare-option-matrix
verb: compare
object: option-matrix
stage: decide
inputs: [brief, alternatives-list]
outputs: [option-matrix]
preconditions: ["brief exists with clear decision scope"]
side_effects: ["writes: artifacts/option-matrix.md"]
failure_modes: [fewer-than-2-options, missing-dimensions, inconsistent-scoring]
leveling: G3-V0-P1-M2
---

# Option Matrix

Compare alternatives with explicit trade-offs across multiple dimensions.

## Prerequisites
- `artifacts/brief.md` must exist

## Process

1. **Identify Alternatives**: At least 2 viable options (3+ preferred)
2. **Define Dimensions**: Cost, Risk, Complexity, Maintainability, Performance, Time-to-value
3. **Score Each Option**: Use consistent scale (1-5 or Low/Med/High)
4. **Highlight Trade-offs**: Explicit pro/con for each option
5. **Recommend**: State which option you'd choose and why

## Template

```markdown
# Option Matrix: [Decision Topic]
_Context: [1-sentence from brief]_

## Alternatives

### Option A: [Name]
- **Description**: [2-3 sentences]
- **Pros**: [bullet list]
- **Cons**: [bullet list]

### Option B: [Name]
- **Description**: [2-3 sentences]
- **Pros**: [bullet list]
- **Cons**: [bullet list]

### Option C: [Name] (if applicable)
...

## Comparison Matrix

| Dimension | Option A | Option B | Option C |
|---|---|---|---|
| Cost | | | |
| Risk | | | |
| Complexity | | | |
| Maintainability | | | |
| Performance | | | |
| Time-to-value | | | |
| **Overall** | | | |

## Recommendation
**Recommended:** Option [X]
**Rationale:** [Why this option wins given the brief's constraints and metrics]
**Key Risk:** [Biggest risk of this choice and mitigation]
```

## Done Criteria
- At least 2 alternatives with explicit trade-offs
- Every dimension scored consistently
- Recommendation ties back to brief's success metrics
- Key risk identified with mitigation

## Output
Save to `artifacts/option-matrix.md`
