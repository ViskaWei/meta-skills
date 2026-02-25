# Leveling System — G/V/P/M

Every skill gets a 4-axis tag: `Gx-Vy-Pz-Mk`

## Axis 1: Generality (G) — Who uses it?

| Level | Scope | Examples |
|---|---|---|
| **G3 Core** | Cross-project, cross-domain, universally useful | `verify-quality-gate`, `discover-brief`, `knowledge-capture` |
| **G2 Platform** | Cross-project but domain-specific | `build-paper-draft` (scientific), `review-paper-peer` (academic) |
| **G1 Project** | Single repo or project | `vit-experiment` (astro-specific), `blade` (blade-agent specific) |
| **G0 Ephemeral** | One-time experiment or temporary | Prototype scripts, one-off data converters |

## Axis 2: Volatility (V) — How often does it change?

| Level | Frequency | Examples |
|---|---|---|
| **V0 Stable** | Rarely changes | Naming conventions, template structures, symbol standards |
| **V1 Slow** | Quarterly updates | Acceptance checklists, quality criteria, gate rules |
| **V2 Medium** | Monthly adjustments | Orchestrator routing logic, workflow compositions |
| **V3 Fast** | Weekly/per-project | Project-specific indexers, repo-specific tools |

## Axis 3: Proficiency (P) — How reliable is the automation?

| Level | Reliability | Indicators |
|---|---|---|
| **P0 Draft** | Works but brittle | No evidence trail, manual intervention often needed |
| **P1 Usable** | Repeatable with minor fixes | Has basic I/O contract, occasional manual correction |
| **P2 Reliable** | Passes gates consistently | Complete evidence chain, artifact contract fulfilled |
| **P3 Hardened** | Regression-tested, template-locked | Visual regression, automated checks, documented edge cases |

## Axis 4: Maturity (M) — How complete is the skill?

| Level | Completeness | Criteria |
|---|---|---|
| **M0 Stub** | Title only | Name and one-line description exist |
| **M1 Spec** | Has I/O and Done | Artifact contract defined (inputs, outputs, done criteria) |
| **M2 Implemented** | Has working output | Examples, steps, produces real artifacts |
| **M3 Gated** | Wired to verify | Connected to verify gate + produces evidence bundle |
| **M4 Observed** | Continuously improved | Usage records, failure retros, iterated improvements |

## Leveling Examples

| Skill | Tag | Reasoning |
|---|---|---|
| `verify-quality-gate` | G3-V1-P2-M3 | Universal, slow-changing, reliable, gated |
| `discover-brief` | G3-V0-P2-M3 | Universal, stable template, reliable |
| `build-paper-draft` | G2-V1-P1-M2 | Scientific domain, slow updates, needs manual review |
| `vit-experiment` | G1-V3-P1-M2 | Astro-specific, fast-changing, usable but manual |
| `operate-experiment-tracker` | G2-V2-P1-M2 | Cross-project ML, medium changes, implemented |
| `review-paper-peer` | G2-V1-P2-M3 | Academic domain, stable checklist, gated |

## Usage

When creating a new skill, assign its tag at Step 5 of the creation process.
Record the tag in the skill's artifact contract or as a comment at the top of the file.

Suggested format in skill files:

```markdown
<!-- Leveling: G2-V1-P1-M2 -->
```

Or in the artifact contract table:

```markdown
| Leveling | G2-V1-P1-M2 |
```
