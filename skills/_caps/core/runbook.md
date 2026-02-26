---
cap_id: cap-build-runbook
verb: build
object: runbook
stage: operate
inputs: [system-spec]
outputs: [runbook]
leveling: G3-V1-P2-M3
---
# Runbook

Create operational runbooks: alert → diagnose → fix → verify → retro entry.

## Template

```markdown
# Runbook: [Procedure/Alert Name]
_Last updated: [YYYY-MM-DD]_
_Owner: [who maintains this]_

## Trigger
[What alert/event triggers this runbook]

## Prerequisites
- [ ] Access to [system/service]
- [ ] [tool/credential] available

## Steps

### 1. Diagnose
\`\`\`bash
[diagnostic commands]
\`\`\`
Expected output: [what healthy looks like]

### 2. Fix
\`\`\`bash
[remediation commands]
\`\`\`

### 3. Verify
\`\`\`bash
[verification commands]
\`\`\`
Expected output: [what fixed looks like]

### 4. Escalation
If fix doesn't work:
- Contact: [who]
- Escalation path: [what to do]

## Post-Incident
- [ ] Update this runbook with lessons learned
- [ ] Create retro entry if novel failure mode
```
