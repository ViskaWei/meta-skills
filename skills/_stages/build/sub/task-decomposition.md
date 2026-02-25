---
cap_id: cap-map-tasks
verb: map
object: tasks
stage: build
inputs: [adr]
outputs: [task-tree]
leveling: G3-V1-P2-M3
---

# Task Decomposition

Break an ADR/plan into a task tree with modules, interfaces, dependencies, and test points.

## Process

1. **Read ADR**: Extract deliverables and technical approach
2. **Identify Modules**: Logical units of work
3. **Define Interfaces**: How modules communicate
4. **Map Dependencies**: What must happen before what
5. **Add Test Points**: Where to verify correctness

## Template

```markdown
# Task Tree: [Project Name]

## Module Map
| Module | Responsibility | Input | Output | Dependencies |
|---|---|---|---|---|
| [module] | [what it does] | [input] | [output] | [depends on] |

## Task List
| # | Task | Module | Effort | Dependencies | Test Point |
|---|---|---|---|---|---|
| 1 | [task] | [module] | [0.5-2 days] | [none/task#] | [how to verify] |

## Critical Path
[sequence of tasks that determines minimum completion time]
```

## Done Criteria
- Each task is 0.5-2 days of effort
- Dependencies are explicit (no hidden assumptions)
- Every task has a test point
