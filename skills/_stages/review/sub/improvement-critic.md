---
cap_id: cap-review-improvement
verb: review
object: improvement
stage: review
inputs: [patched-artifact, gate-verdict, gap-report]
outputs: [improvement-review]
preconditions: ["verify step completed with gate-verdict"]
side_effects: []
failure_modes: [perfection-bias, moving-goalposts, rubber-stamping]
leveling: G3-V1-P1-M1
---

# review-improvement-critic

Adversarial review of improvements made to any artifact. Acts as a critic agent: assumes the role of a demanding reviewer who identifies what's still missing, inconsistent, or weak.

## Artifact Contract

| Field | Value |
|---|---|
| Inputs | Patched artifact + gate-verdict from verify step + original gap-analysis |
| Outputs | **Improvement Review**: scored gap list with PASS/ITERATE verdict |
| Done | (1) All 6 dimensions scored, (2) actionable gaps listed with priority, (3) clear verdict |
| Evidence | Dimension scores, gap count, comparison with previous round |
| Gates | Pre: verify step completed (gate-verdict exists). Post: verdict is PASS or ITERATE with gap list |
| Next-hop | PASS → `knowledge-capture`. ITERATE → `decide-plan-roadmap` (loop back) |
| Leveling | G3-V1-P1-M1 |

## When to Use

- After improvements have been applied and verified (no regressions)
- As the loop engine in `/improve` — determines whether to continue or stop
- When you need an adversarial second opinion on artifact quality

## 6 Review Dimensions

Score each dimension 1-5 (1=poor, 5=excellent):

| Dimension | Question | Weight |
|---|---|---|
| **Completeness** | Are all expected elements present? Any missing edge cases? | High |
| **Clarity** | Is the artifact easy to understand? Any ambiguity? | High |
| **Consistency** | Does it follow conventions? Any style drift? | Medium |
| **Robustness** | Does it handle errors/edge cases? Any fragile parts? | Medium |
| **Usability** | Is it easy to use/consume? Good UX/DX? | Medium |
| **Performance** | Any unnecessary work? Bottlenecks? | Low |

## Output Template

```markdown
# Improvement Review — Round [N]

## Dimension Scores
| Dimension | Score (1-5) | Notes |
|---|---|---|
| Completeness | | |
| Clarity | | |
| Consistency | | |
| Robustness | | |
| Usability | | |
| Performance | | |

**Average**: [X.X] / 5.0

## Actionable Gaps
| # | Dimension | Gap | Priority | Effort |
|---|---|---|---|---|
| 1 | | | H/M/L | H/M/L |

## Comparison with Previous Round
| Metric | Previous | Current | Delta |
|---|---|---|---|
| Average score | | | |
| Actionable gaps | | | |
| High-priority gaps | | | |

## Verdict
**[PASS / ITERATE]**

Rationale: [1-2 sentences]

PASS criteria: average >= 4.0 AND high-priority gaps == 0 AND actionable gaps < 2
```

## Critic Persona

When executing this review, adopt this stance:
1. **Assume flaws exist** — actively look for what's wrong, not what's right
2. **Be specific** — "naming is unclear" is bad; "function `processData` should be `validateUserInput`" is good
3. **Prioritize ruthlessly** — only flag gaps that actually matter for the artifact's purpose
4. **Compare against best practices** — reference the standards-pack from the research step
5. **No false positives** — don't manufacture issues. If it's genuinely good, say PASS

## Edge Cases

- **First round has many gaps**: Normal. Focus on highest-impact items only.
- **Same gaps persist across rounds**: Flag as potential blocker. May need architectural change.
- **Diminishing returns**: If delta between rounds < 0.3 average score, recommend PASS even with remaining gaps.
- **Subjective dimensions**: Bias toward objective evidence. "I think the naming could be better" < "variable `x` doesn't convey its role as user-count"

## Anti-Patterns

- **Perfection bias**: Demanding 5/5 on all dimensions. Real artifacts have trade-offs.
- **Moving goalposts**: Introducing new criteria in later rounds that weren't in the original gap analysis.
- **Ignoring context**: A quick script doesn't need the robustness of a production service.
- **Rubber-stamping**: Always saying PASS without genuine review. The critic must earn its verdict.
