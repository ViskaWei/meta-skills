---
cap_id: cap-assemble-evidence-bundle
verb: assemble
object: evidence-bundle
stage: verify
inputs: [experiment-log]
outputs: [evidence-bundle]
preconditions: ["artifact to verify exists"]
side_effects: ["writes: artifacts/evidence.md"]
failure_modes: [missing-reproduction-steps, incomplete-environment]
leveling: G3-V0-P2-M3
---

# Evidence Bundle

Produce a comprehensive evidence bundle that proves an artifact is correct. A third person should be able to reproduce from evidence alone.

## Process

1. **Identify Artifact Type**: Code, flowchart, website, paper, model, etc.
2. **Collect Evidence** per type:
   - **Code**: test output, coverage, linting, type-check
   - **Flowchart/Diagram**: rendered screenshot, symbol audit, standard compliance
   - **Website/UI**: 3 viewport screenshots (desktop 1280px, tablet 768px, mobile 375px)
   - **Paper/Report**: structure check, citation validation, figure quality
   - **ML Model**: training logs, validation metrics, loss curves
3. **Document Reproduction Steps**: Exact commands to reproduce
4. **Capture Environment**: versions, config, dependencies

## Evidence Template

```markdown
# Evidence Bundle: [Artifact Name]
_Date: [YYYY-MM-DD]_
_Artifact: [path/to/artifact]_

## Verification Method
[How this artifact was verified]

## Evidence Items

### 1. [Evidence Type]
- **Command**: `[exact command run]`
- **Output**: [screenshot/log/result]
- **Expected**: [what was expected]
- **Actual**: [what was observed]
- **Verdict**: PASS / FAIL

### 2. [Evidence Type]
...

## Environment
- OS: [version]
- Runtime: [version]
- Dependencies: [key versions]
- Config: [relevant settings]

## Reproduction Steps
1. [step 1 — exact command]
2. [step 2 — exact command]
3. [step 3 — verify output matches]

## Summary
- Total checks: [N]
- Passed: [N]
- Failed: [N]
- **Overall: PASS / FAIL**
```

## Done Criteria
- Every evidence item has exact command + expected + actual
- A third person can reproduce from steps alone
- Environment documented (no "works on my machine")
- Screenshots included for visual artifacts
