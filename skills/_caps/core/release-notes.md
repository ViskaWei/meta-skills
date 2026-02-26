---
cap_id: cap-publish-release
verb: publish
object: release
stage: deliver
inputs: [delivery-package]
outputs: [release-notes]
preconditions: []
side_effects: []
failure_modes: []
leveling: G2-V1-P1-M1
---

# Release Notes

Document what changed, what's fixed, known issues, and migration impact.

## Template

```markdown
# Release Notes: [Name] v[X.Y.Z]
_Date: [YYYY-MM-DD]_

## Added
- [new feature/capability]

## Changed
- [modification to existing behavior]

## Fixed
- [bug fix with brief description]

## Known Issues
- [issue + workaround if available]

## Migration Guide
[Steps to upgrade from previous version, if applicable]

## Breaking Changes
[Any breaking changes + how to adapt]
```
