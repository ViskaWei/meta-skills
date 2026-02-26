---
cap_id: cap-plan-exec-plan
verb: plan
object: exec-plan
stage: decide
inputs: [brief, adr, requirements]
outputs: [exec-plan]
preconditions: ["brief or requirements exist", "scope is well-defined"]
side_effects: ["writes: artifacts/PLANS.md"]
failure_modes: [scope-too-vague, missing-acceptance-criteria, unbounded-complexity]
leveling: G3-V1-P1-M1
---

# ExecPlan — Self-Contained Execution Plan

> Inspired by OpenAI Harness Engineering: "ExecPlans are self-contained design
> documents that an agent can implement with zero additional context."

Create a structured execution plan that an agent (or human) can follow
autonomously for 2-7 hours without needing clarification.

## Why ExecPlans?

From OpenAI's Codex team: agents sustained focus for 7+ hours on single
prompts when given well-structured ExecPlans. Knowledge that lives outside
the repo (Slack, Docs, heads) is invisible to agents.

## Prerequisites

- Brief or requirements document exists
- Scope is bounded (if too large, decompose first via `cap-map-context`)

## Process

1. **State the Goal**: One sentence, measurable outcome
2. **Define Acceptance Criteria**: Concrete, testable conditions for "done"
3. **List Constraints**: Technology, architecture, naming, policies that apply
4. **Break into Steps**: Ordered, atomic tasks with clear inputs/outputs
5. **Identify Dependencies**: What must exist before each step starts
6. **Define Verification**: How to check each step succeeded
7. **Anti-Goals**: What this plan explicitly does NOT cover

## Template

```markdown
# PLANS.md — [Plan Title]

_Created: [YYYY-MM-DD]_
_Status: draft | approved | executing | completed_
_Estimated effort: [hours]_

## Goal
[One sentence: what will be true when this plan is complete]

## Acceptance Criteria
- [ ] [Criterion 1 — testable]
- [ ] [Criterion 2 — testable]
- [ ] [Criterion 3 — testable]

## Constraints
- Architecture: [layers, dependencies, naming rules]
- Technology: [stack, versions, "boring tech" preferences]
- Policies: [which rule-* files apply]

## Steps

### Step 1: [Action verb] [Object]
- **Input**: [what already exists]
- **Output**: [what this step produces]
- **Verify**: [how to check it worked]

### Step 2: [Action verb] [Object]
...

## Anti-Goals
- [What this plan explicitly does NOT do]
- [Boundaries to prevent scope creep]

## Rollback
- [How to undo if plan fails midway]
```

## Quality Checks

- Every step has Input + Output + Verify
- Acceptance criteria are testable (not subjective)
- Anti-goals prevent scope creep
- Plan is self-contained: no external knowledge required
- Total effort estimate is realistic (2-7 hours ideal)

## Integration with Workflow

```
Discover (brief) → Decide (ADR) → Decide (ExecPlan) → Build (execute steps)
                                        ↑ THIS
```

ExecPlan sits between ADR and Build. It transforms a strategic decision
into tactical, executable steps.
