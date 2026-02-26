---
cap_id: cap-decide-adr
verb: decide
object: adr
stage: decide
inputs: [option-matrix]
outputs: [adr]
preconditions: ["option-matrix exists or alternatives discussed"]
side_effects: ["writes: artifacts/adr.md"]
failure_modes: [no-alternatives-considered, missing-rollback]
leveling: G3-V0-P2-M3
---

# Architecture Decision Record (ADR)

Record an architecture decision with full context, alternatives, and rollback strategy.

## Prerequisites
- `artifacts/option-matrix.md` should exist (or alternatives must be discussed)

## Process

1. **State Decision**: Clear, unambiguous statement
2. **Document Context**: Why this decision is needed now
3. **List Alternatives**: What was considered (reference option matrix)
4. **State Consequences**: Both positive and negative
5. **Define Rollback**: How to undo if decision proves wrong

## Template

```markdown
# ADR-[NNN]: [Decision Title]
_Status: Accepted | Proposed | Superseded_
_Date: [YYYY-MM-DD]_

## Decision
[Clear statement: "We will use X to do Y"]

## Context
[Why this decision is needed. What forces are at play. Reference brief.]

## Alternatives Considered
1. **[Option A]** — [1-line summary + why rejected]
2. **[Option B]** — [1-line summary + why rejected]
3. **[Chosen Option]** — [1-line summary + why chosen]

## Consequences

### Positive
- [benefit 1]
- [benefit 2]

### Negative
- [trade-off 1]
- [trade-off 2]

### Risks
- [risk + mitigation]

## Rollback Strategy
If this decision proves wrong, here's how to reverse it:
1. [step 1]
2. [step 2]
3. [estimated effort to rollback]

## References
- [link to option matrix, brief, or external docs]
```

## Done Criteria
- A third person can retell the decision and rationale
- Has explicit rollback strategy with effort estimate
- Consequences include both positive and negative
- Links to option matrix or brief

## Output
Save to `artifacts/adr.md` (or `artifacts/adr-NNN.md` for multiple decisions)
