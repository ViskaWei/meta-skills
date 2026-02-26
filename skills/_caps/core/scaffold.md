---
cap_id: cap-scaffold-experiment
verb: scaffold
object: experiment
stage: build
inputs: [adr, roadmap-mvp]
outputs: [experiment-scaffold]
preconditions: ["ADR or plan exists"]
side_effects: ["creates: project directory structure"]
failure_modes: [missing-tech-stack, incomplete-stubs]
leveling: G3-V1-P2-M3
---

# Build Scaffold

Create implementation scaffolding: directory structure, entry points, configuration, and a minimal running demo.

## Prerequisites
- ADR or plan exists with clear deliverables

## Process

1. **Analyze ADR**: Extract deliverables, tech stack, interfaces
2. **Create Directory Structure**: Standard project layout for the tech stack
3. **Write Entry Points**: Main files with skeleton implementations
4. **Add Configuration**: Config files, environment setup, dependencies
5. **Create Minimal Demo**: One command runs the happy path

## Scaffold Checklist

```markdown
## Scaffold: [Project Name]

### Directory Structure
[tree output of created directories]

### Entry Points
- [ ] Main entry: [file] — runs with `[command]`
- [ ] Config: [file] — environment/settings
- [ ] Tests: [directory] — test structure

### Dependencies
- [ ] `requirements.txt` / `package.json` / etc.
- [ ] Environment: [python version, node version, etc.]

### Quick Start
\`\`\`bash
# One command to run the happy path:
[command]
\`\`\`

### Interface Stubs
- [ ] [interface 1]: input → output (stub)
- [ ] [interface 2]: input → output (stub)
```

## Done Criteria
- One command runs the happy path end-to-end
- All interfaces have stubs (not empty files, actual stub implementations)
- Dependencies are pinned (versions specified)
- README has quick-start instructions

## Output
The scaffold is created directly in the project directory.
