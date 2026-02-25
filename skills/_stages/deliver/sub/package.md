---
cap_id: cap-package-output
verb: package
object: output
stage: deliver
inputs: [gate-verdict]
outputs: [delivery-package]
preconditions: ["quality gate PASS"]
side_effects: ["writes: artifacts/package/"]
failure_modes: [missing-dependencies, broken-quick-start]
leveling: G3-V0-P2-M3
---

# Package

Create a versioned, publishable artifact with complete metadata.

## Prerequisites
- Evidence Bundle with Quality Gate PASS

## Process

1. **Identify Artifact Type**: code release, website, model, paper, report
2. **Version**: Assign semantic version (or date-based)
3. **Bundle**: Collect all deliverable files
4. **Document**: Dependencies, run instructions, known issues

## Package Template

```markdown
# Package: [Name] v[X.Y.Z]
_Date: [YYYY-MM-DD]_
_Type: [code/website/model/paper/report]_

## Contents
- [list of files/directories included]

## Dependencies
- [runtime dependencies with versions]

## Quick Start
\`\`\`bash
[exact commands to run/use the package]
\`\`\`

## Configuration
- [configurable settings and defaults]

## Known Issues
- [any known limitations or caveats]

## Changelog
- [what changed since last version]
```

## Done Criteria
- Version number assigned
- Dependencies with versions listed
- Quick start commands work end-to-end
- Known issues documented (even if "none")
