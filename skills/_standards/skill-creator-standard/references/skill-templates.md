# Skill Templates — Extended Reference

Complete templates for all skill types, including hook patterns, anti-patterns, and examples.

---

## Template 1: Sub-skill (Full)

```markdown
# <stage>-<action>

<!-- Leveling: Gx-Vy-Pz-Mk -->

<One-line description of what this does>

## Artifact Contract

| Field | Value |
|---|---|
| Inputs | <what it receives, from which upstream skill/artifact> |
| Outputs | <what it produces — the primary artifact> |
| Done | <measurable completion criteria> |
| Evidence | <logs/screenshots/commands/versions proving correctness> |
| Gates | Pre: <what must exist>. Post: <what this enables> |
| Next-hop | <default downstream skill/stage> |
| Leveling | <Gx-Vy-Pz-Mk> |

## Steps
1. <First action>
2. <Second action>
3. <Verification>

## Domain Tool References
| Tool | Path | Purpose |
|---|---|---|

## Edge Cases
- <When to skip this skill>
- <Common failure modes>
```

---

## Template 2: Top-level Skill (Full)

```yaml
---
name: <skill-name>
description: "<WHAT it does AND WHEN to use it. Include trigger words. Max 2-3 sentences.>"
---
```

```markdown
# <Skill Name>

<Brief overview: 2-3 sentences.>

## When to Use

- Scenario 1: <trigger condition>
- Scenario 2: <trigger condition>
- Scenario 3: <trigger condition>

## Artifact Contract

| Field | Value |
|---|---|
| Inputs | ... |
| Outputs | ... |
| Done | ... |
| Evidence | ... |
| Gates | Pre: ... Post: ... |
| Next-hop | ... |

## Procedure

### Step 1: <Phase Name>
<Instructions>

### Step 2: <Phase Name>
<Instructions>

### Step 3: Verify
<How to confirm success>

## Examples

### Example 1: Happy Path
<Show typical usage>

### Example 2: Edge Case
<Show non-obvious usage>

## References
- `references/<detail>.md` — <what it covers>
```

---

## Template 3: Orchestrator (Full)

```markdown
# <workflow-name>

<End-to-end workflow description>

## Pipeline

| Step | Skill | Artifact Produced | Gate (Pre-condition) |
|---|---|---|---|
| 1 | discover-xxx | Brief | — |
| 2 | decide-xxx | ADR | Brief exists |
| 3 | build-xxx | Implementation | ADR approved |
| 4 | verify-xxx | Evidence Bundle | Implementation runnable |
| 5 | deliver-xxx | Package | Evidence PASS |

## Routing Logic

- **Skip step N if**: <condition>
- **Loop back to step N if**: <condition>
- **Branch**: <when to take alternative path>

## Error Handling

- If gate fails at step N → return to step N-1 with failure report
- If skill unavailable → surface to user, do not substitute

## Artifact Chain

<Show the data flow between steps — what each step receives and passes>
```

---

## Template 4: Domain Tool (Full)

```markdown
# <tool-name>

<What this tool does and why it exists as cross-stage infrastructure>

## Artifact Contract

| Field | Value |
|---|---|
| Inputs | <what it receives> |
| Outputs | <what it produces> |
| Called by | <list of lifecycle stages/skills that use this> |

## Usage

### From Build Stage
<How build skills invoke this tool>

### From Verify Stage
<How verify skills invoke this tool>

## Steps
1. ...
2. ...

## Configuration
<Any environment setup, dependencies, or prerequisites>
```

---

## Hook Patterns

### Pattern 1: Pre-validation Hook
Validates before a tool executes:

```yaml
hooks:
  - PreToolUse:
      - matcher: "Write"
        hooks:
          - type: "prompt"
            prompt: "Validate: $ARGUMENTS"
```

### Pattern 2: Post-enhancement Hook
Enhances output after a tool executes:

```yaml
hooks:
  - PostToolUse:
      - matcher: "Write"
        hooks:
          - type: "prompt"
            prompt: "Check output quality: $ARGUMENTS"
```

### Pattern 3: Command Hook
Runs a shell command:

```yaml
hooks:
  - PreToolUse:
      - matcher: "Bash"
        hooks:
          - type: "command"
            command: "~/scripts/validate.sh"
            statusMessage: "Validating..."
```

**Hook Variables**: `$ARGUMENTS`, `$TOOL_NAME`, `$SESSION_ID`, `$CWD`

---

## Anti-Patterns

### 1. Vague Description
- BAD: "Helper for coding"
- GOOD: "Applies Python PEP-8 standards when writing .py files"

### 2. Missing Artifact Contract
- BAD: Steps only, no declared I/O
- GOOD: Full artifact contract table before steps

### 3. No Gate Awareness
- BAD: "Produces a package" (no mention of what must be verified first)
- GOOD: "Pre-gate: Evidence Bundle PASS. Produces: Versioned package"

### 4. Reimplementing Existing
- BAD: New skill that does 80% of what `verify-evidence-bundle` already does
- GOOD: Extend existing or create orchestrator that calls it

### 5. Orphan Skill
- BAD: Skill exists but no orchestrator/stage routes to it
- GOOD: Listed in parent SKILL.md table + reachable from at least one entry point

### 6. Mixed Rigid + Flexible
- BAD: "Follow these rules exactly... or adapt as needed"
- GOOD: Clear stance — either mandatory steps or flexible principles

### 7. Oversized SKILL.md
- BAD: 800-line monolith
- GOOD: < 500 lines, details in `references/`, scripts in `scripts/`
