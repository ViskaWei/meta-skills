---
cap_id: cap-plan-test
verb: plan
object: test
stage: verify
inputs: [requirements]
outputs: [test-plan]
leveling: G3-V1-P2-M3
---
# Test Plan

Create a comprehensive test plan covering all verification levels.

## Process

1. **Read Requirements**: From `artifacts/requirements.md`
2. **Map Test Coverage**: Each requirement → at least one test
3. **Define Test Levels**: Unit, integration, e2e, visual, performance
4. **Identify Failure Modes**: What can go wrong?

## Template

```markdown
# Test Plan: [Project Name]
_Requirements: artifacts/requirements.md_

## Coverage Matrix
| Req ID | Requirement | Test Level | Test Description | Status |
|---|---|---|---|---|
| R-001 | [req] | [unit/integration/e2e] | [what to test] | [pending/pass/fail] |

## Test Levels

### Unit Tests
- [ ] [test 1]
- [ ] [test 2]

### Integration Tests
- [ ] [test 1]

### End-to-End Tests
- [ ] [test 1]

### Visual Tests
- [ ] [screenshot comparison 1]

### Performance Tests
- [ ] [benchmark 1]

## Failure Modes
| # | Failure Mode | Test That Catches It |
|---|---|---|
| 1 | [what could go wrong] | [which test] |

## Environment
- [test environment setup]
```

## Done Criteria
- Every P0 requirement has at least one test
- Critical failure modes identified and covered
- Test plan executable (not just documentation)
