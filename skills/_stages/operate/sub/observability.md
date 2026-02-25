---
cap_id: cap-build-observability
verb: build
object: observability
stage: operate
inputs: [system-spec]
outputs: [observability-plan]
leveling: G3-V1-P2-M3
---
# Observability Plan

Define metrics, logging, tracing, SLIs/SLOs, and alert thresholds.

## Template

```markdown
# Observability: [System Name]

## SLIs (Service Level Indicators)
| SLI | Measurement | Current | Target |
|---|---|---|---|
| [indicator] | [how measured] | [baseline] | [target] |

## SLOs (Service Level Objectives)
- [SLO 1]: [target] over [window]

## Key Metrics
| Metric | Type | Alert Threshold | Escalation |
|---|---|---|---|
| [metric] | [counter/gauge/histogram] | [threshold] | [who to notify] |

## Logging
- Level: [what level for what component]
- Format: [structured/text]
- Retention: [how long]

## Dashboards
- [dashboard 1]: [what it shows]
```

## Done Criteria
- Can locate root cause category in 5-15 minutes
- Alert thresholds prevent false positives
