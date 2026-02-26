---
cap_id: cap-plan-experiment-design
verb: plan
object: experiment-design
stage: decide
inputs: [roadmap-mvp]
outputs: [experiment-design]
preconditions: ["roadmap MVP exists"]
side_effects: ["writes: artifacts/experiment-design.md"]
failure_modes: [unfalsifiable-hypothesis, missing-controls]
leveling: G3-V1-P2-M3
---

# Experiment Design

Design a rigorous experiment with variables, controls, metrics, and stop conditions.

## Template

```markdown
# Experiment Design: [Title]
_Research Question: [specific, testable question]_

## Variables
- **Independent**: [what we manipulate]
- **Dependent**: [what we measure]
- **Controlled**: [what we hold constant]

## Hypothesis
[If X, then Y, because Z]

## Method
1. [step-by-step procedure]
2. [data collection method]
3. [analysis approach]

## Data Requirements
- Source: [where data comes from]
- Size: [how much needed]
- Format: [expected format]

## Metrics
| Metric | Baseline | Target | Measurement |
|---|---|---|---|
| [metric] | [current] | [goal] | [how to measure] |

## Stop Conditions
- **Success**: [when to declare success]
- **Failure**: [when to stop and pivot]
- **Resource limit**: [max time/compute/budget]

## Controls
- [control 1 — baseline comparison]
- [control 2 — ablation]
```

## Done Criteria
- Hypothesis is falsifiable
- Stop conditions prevent "ran a bunch but can't explain"
- Metrics have baselines and targets
