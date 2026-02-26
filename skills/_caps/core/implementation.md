---
cap_id: cap-build-implementation
verb: build
object: implementation
stage: build
inputs: [roadmap, brief]
outputs: [patched-artifact]
preconditions: ["plan/roadmap exists with prioritized items"]
side_effects: ["modifies target files"]
failure_modes: [scope-creep, regression, incomplete-implementation]
leveling: G3-V0-P2-M3
---

# build-implementation

Execute a planned set of changes on an artifact. The workhorse capability — takes a roadmap and applies changes one by one.

## When to Use

- After `plan-roadmap` has produced a prioritized list of changes
- When improvements, fixes, or features need to be applied to code, docs, or configs
- As the "apply" step in any improve/fix/build loop

## Process

1. **Load Plan**: Read the roadmap/plan with prioritized items
2. **For Each Item** (in priority order):
   a. Understand the change scope (which files, which sections)
   b. Read current state of target files
   c. Apply the change with minimal blast radius
   d. Verify the change doesn't break existing functionality
3. **Track Progress**: Log each change applied (file, what changed, why)
4. **Produce Artifact**: The modified files + a change log

## Principles

- **Minimal diff**: Change only what's needed. Don't refactor adjacent code.
- **One item at a time**: Apply changes sequentially, not all at once.
- **Verify after each**: Quick sanity check after each change.
- **Respect conventions**: Follow existing code/doc style, don't impose new patterns.
- **Log everything**: Every change gets a one-line summary in the change log.

## Output

The patched artifact (modified files) + change log summarizing what was done.
