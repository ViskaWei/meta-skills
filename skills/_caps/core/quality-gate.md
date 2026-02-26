---
cap_id: cap-decide-quality-gate
verb: decide
object: quality-gate
stage: verify
inputs: [evidence-bundle]
outputs: [gate-verdict]
preconditions: ["evidence-bundle exists and is non-empty"]
side_effects: ["writes: artifacts/gate-verdict.md"]
failure_modes: [incomplete-evidence, conflicting-verdicts]
leveling: G3-V0-P3-M3
---

# Quality Gate

Render a PASS/FAIL verdict on an evidence bundle. No exceptions. No "good enough."

## Prerequisites
- Evidence bundle must exist (`artifacts/evidence.md`)

## Process

1. **Load Evidence Bundle**: Read all evidence items
2. **Check Completeness**: All required evidence types present?
3. **Check Individual Verdicts**: Any FAIL items?
4. **Render Overall Verdict**: ALL must pass for overall PASS

## Gate Rules

### Mandatory Checks (ALL must pass)
- [ ] Evidence bundle exists and is non-empty
- [ ] All evidence items have command + expected + actual
- [ ] Reproduction steps are complete (no missing steps)
- [ ] No evidence item has verdict FAIL

### Policy-as-Code 质检规则（3-Layer 架构）

类型专项检查已提取为独立的 Policy 文件，位于 `_policies/` 目录：

| 规则 ID | 文件 | 触发条件 |
|---|---|---|
| `rule-quality-deliverable-minimum` | `_policies/rule-quality-deliverable-minimum.yaml` | 所有交付物 (`*`) |
| `rule-webui-visual-regression` | `_policies/rule-webui-visual-regression.yaml` | `web-page`, `html-dashboard` |
| `rule-paper-structure-integrity` | `_policies/rule-paper-structure-integrity.yaml` | `paper-draft`, `latex-report` |
| `rule-research-reproducibility` | `_policies/rule-research-reproducibility.yaml` | `model-checkpoint`, `training-run` |
| `rule-standards-source-trust` | `_policies/rule-standards-source-trust.yaml` | `standards-pack`, `literature-review` |

> 新增质检规则请使用 `/skill-creator` 创建 `rule-<scope>-<intent>` 格式的 Policy 文件。

### Type-Specific Checks

**Code Artifacts:**
- [ ] Tests pass (zero failures)
- [ ] No lint errors in changed files
- [ ] No security vulnerabilities introduced

**Visual Artifacts (Flowcharts/Diagrams):**
- [ ] Rendered screenshot exists
- [ ] Symbols follow standard (per `_tools/flowchart/references/`)
- [ ] Text is readable (no overlap, no truncation)
- [ ] Layout is clean (no crossing edges unless unavoidable)

**Web/UI Artifacts:**
- [ ] Desktop screenshot (1280px) — layout correct
- [ ] Tablet screenshot (768px) — responsive
- [ ] Mobile screenshot (375px) — usable

**Paper/Report Artifacts:**
- [ ] Structure follows venue template
- [ ] Citations valid and complete
- [ ] Figures referenced and captioned

**ML Model Artifacts:**
- [ ] Training converged (loss decreasing)
- [ ] Validation metrics within expected range
- [ ] No data leakage (train/val/test properly split)

## Verdict Template

```markdown
# Quality Gate: [Artifact Name]
_Date: [YYYY-MM-DD]_

## Verdict: **PASS** / **FAIL**

## Checks
| # | Check | Result | Notes |
|---|---|---|---|
| 1 | [check] | PASS/FAIL | [detail] |

## Issues (if FAIL)
| # | Issue | Severity | Rework Action |
|---|---|---|---|
| 1 | [issue] | Critical/Major/Minor | [what to fix] |

## Rework Tasks (auto-generated on FAIL)
1. [ ] [task 1 — specific fix]
2. [ ] [task 2 — specific fix]

_Route back to Build stage with rework tasks._
```

## FAIL Behavior
1. Generate specific rework task list
2. Route back to Build stage
3. After rework, re-run entire Verify stage
4. **Never approve with known failures**
