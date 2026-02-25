---
name: skill-creator-enhanced
description: Enhanced skill creation workflow with automatic hook setup, trigger detection, and validation. Use when creating new skills to ensure hooks, metadata, and structure are correct from the start.
---

# Skill Creator Enhanced

**Use this skill when creating new Claude Code skills to avoid common mistakes.**

## The Problem

Creating skills without proper setup leads to:
- ❌ Missing hooks → skill never triggers
- ❌ Wrong trigger patterns → skill triggers too often or never
- ❌ Invalid metadata → skill not recognized
- ❌ Poor structure → hard to maintain

## The Solution: Checklist-Driven Creation

### Step 1: Gather Requirements

Ask the user these questions:

1. **What does this skill do?** (1-2 sentences)
2. **When should it trigger?** (specific phrases, tool calls, or always)
3. **What tools/commands does it need?** (bash, API calls, file operations)
4. **Is it rigid (TDD-like) or flexible (patterns)?**

### Step 2: Design Triggers

Based on "when should it trigger", choose the right approach:

#### Option A: User-Invoked Skills (Slash Commands)

For skills the user explicitly calls like `/commit` or `/review`:

```yaml
---
name: my-skill
description: Clear description of what this skill does
---
```

✅ **No hooks needed** - user calls it directly
✅ Add trigger keywords in description (e.g., "Use when user says 'review my code'")

#### Option B: Auto-Triggered Skills

For skills that should activate automatically:

**Trigger Pattern 1: Keyword-based**
```yaml
---
name: auto-skill
description: Use when user mentions "keyword1", "keyword2", or asks "how to..."
---
```

**Trigger Pattern 2: Tool-based (with hooks)**
```yaml
---
name: pre-commit-check
description: Validates code before git commits
hooks:
  - PreToolUse:
      - matcher: "Bash"
        conditions:
          - command_contains: "git commit"
---
```

**Trigger Pattern 3: Always active**
```yaml
---
name: code-standards
description: Apply coding standards to all code. Use this skill when writing any code.
---
```

### Step 3: Create Directory Structure

```bash
~/.claude/skills/my-skill/
├── SKILL.md              # Main skill definition (REQUIRED)
├── examples/             # Example usage (optional)
├── templates/            # Code templates (optional)
└── reference/            # Reference docs (optional)
```

### Step 4: Write SKILL.md with Template

```markdown
---
name: skill-name
description: One-line description of what this skill does and when to use it
version: 1.0.0
hooks:                    # Optional: only if auto-triggered
  - PreToolUse:
      - matcher: "Write"
        hooks:
          - type: "prompt"
            prompt: "Check if file follows skill guidelines: $ARGUMENTS"
---

# Skill Name

Brief overview (2-3 sentences).

## When to Use This Skill

List specific scenarios with examples:

- When the user asks "X"
- Before doing Y
- After completing Z

## How It Works

### Step 1: First Action

Explain what to do first.

```bash
# Example command if applicable
npm test
```

### Step 2: Second Action

Continue the workflow.

### Step 3: Validation

How to verify success.

## Examples

### Example 1: Common Case

```
User: "Do X"
Assistant: [follows skill steps]
```

### Example 2: Edge Case

```
User: "What about Y?"
Assistant: [handles edge case]
```

## Tips

- Tip 1
- Tip 2

## Common Mistakes to Avoid

- Mistake 1
- Mistake 2
```

### Step 5: Validate Before Saving

Run these checks:

#### Check 1: Metadata Valid?
```bash
head -20 ~/.claude/skills/my-skill/SKILL.md | grep -E "^name:|^description:"
```

Expected: Both fields present

#### Check 2: Description Clear?
- ✅ Explains WHAT and WHEN
- ✅ Under 200 characters
- ❌ Vague like "Helper skill"

#### Check 3: Hooks Syntax Correct?
```bash
cat ~/.claude/skills/my-skill/SKILL.md | grep -A 10 "^hooks:"
```

If using hooks, validate JSON-like structure matches schema.

#### Check 4: Examples Included?
- ✅ At least 2 examples showing usage
- ✅ Shows both success and edge cases

### Step 6: Test the Skill

```bash
# Test 1: Skill loads
claude  # Start new session, check if skill appears in system prompt

# Test 2: Skill triggers
# Try trigger phrase/action and verify skill activates

# Test 3: Skill completes
# Verify skill executes all steps successfully
```

### Step 7: Document Triggers

Add to skill's SKILL.md:

```markdown
## Trigger Words

This skill activates when the user says:
- "trigger phrase 1"
- "trigger phrase 2"
- Or uses tool: `ToolName`
```

## Skill Types Reference

### Rigid Skills (TDD, Security, Debugging)

```markdown
## The Rule

**You MUST follow these steps exactly. No shortcuts.**

1. Step 1 (mandatory)
2. Step 2 (mandatory)
3. Step 3 (mandatory)

Skipping steps leads to [specific bad outcome].
```

### Flexible Skills (Patterns, Guidelines)

```markdown
## Principles

Apply these principles based on context:

1. Principle 1 - when applicable
2. Principle 2 - prefer this approach
3. Principle 3 - avoid anti-pattern

Adapt to the specific situation.
```

### Workflow Skills (Multi-step Tasks)

```markdown
## Workflow

### Phase 1: Preparation
- [ ] Task 1
- [ ] Task 2

### Phase 2: Execution
- [ ] Task 3
- [ ] Task 4

### Phase 3: Validation
- [ ] Task 5
- [ ] Task 6
```

## Hook Configuration Guide

### When to Use Hooks

| Scenario | Hook Type | Event |
|----------|-----------|-------|
| Before file edit | PreToolUse | matcher: "Edit" |
| After command runs | PostToolUse | matcher: "Bash" |
| On command failure | PostToolUseFailure | matcher: "Bash" |
| Every user message | UserPromptSubmit | no matcher |
| Session start | SessionStart | no matcher |

### Hook Types

#### Type 1: Command Hook

```yaml
hooks:
  - PreToolUse:
      - matcher: "Write"
        hooks:
          - type: "command"
            command: "~/scripts/validate-file.sh"
            statusMessage: "Validating file..."
```

#### Type 2: Prompt Hook (LLM)

```yaml
hooks:
  - PreToolUse:
      - matcher: "Bash"
        hooks:
          - type: "prompt"
            prompt: "Check if this command is safe: $ARGUMENTS"
            model: "haiku"
```

#### Type 3: Agent Hook

```yaml
hooks:
  - PostToolUse:
      - matcher: "Write"
        hooks:
          - type: "agent"
            prompt: "Verify the file follows best practices: $ARGUMENTS"
            timeout: 30
```

### Hook Variables

Available in hook commands/prompts:

- `$ARGUMENTS` - Tool call arguments as JSON
- `$TOOL_NAME` - Name of the tool being called
- `$SESSION_ID` - Current session ID
- `$CWD` - Current working directory

## Common Patterns

### Pattern 1: Validation Skill

```markdown
---
name: validate-x
description: Validates X before proceeding
hooks:
  - PreToolUse:
      - matcher: "Write"
        hooks:
          - type: "prompt"
            prompt: "Validate this follows X rules: $ARGUMENTS"
---

# Validation Rules

1. Check A
2. Check B
3. If invalid, stop and explain why
```

### Pattern 2: Enhancement Skill

```markdown
---
name: enhance-x
description: Automatically enhances X when detected
---

# Enhancement Rules

When you see X, automatically add:
- Enhancement 1
- Enhancement 2

Never ask permission for these standard enhancements.
```

### Pattern 3: Reminder Skill

```markdown
---
name: remember-x
description: Reminds to do X in specific contexts
---

# Reminders

## Trigger Conditions

When [condition], remind the user to:
1. Action 1
2. Action 2

## Example Reminder

"⚠️ Don't forget to X before Y!"
```

## Anti-Patterns to Avoid

### ❌ Vague Descriptions

Bad: "Helper for coding"
Good: "Applies Python PEP-8 standards when writing .py files"

### ❌ Missing Trigger Clarity

Bad: "Use when needed"
Good: "Use when user asks 'review my code' or before creating PRs"

### ❌ Over-complicated Hooks

Bad: Hook on every tool, every time
Good: Hook only on specific tools where skill adds value

### ❌ No Examples

Bad: Just theory
Good: 3+ concrete examples showing usage

### ❌ Mixing Rigid + Flexible

Bad: "Follow these rules exactly... or adapt as needed"
Good: Clear stance - either rigid or flexible, not both

## Checklist Summary

Before finalizing any skill:

- [ ] Metadata complete (name, description, version)
- [ ] Description is clear and under 200 chars
- [ ] "When to Use" section with 3+ specific scenarios
- [ ] Hooks configured if auto-triggered (optional)
- [ ] Hook syntax validated against schema
- [ ] Examples included (minimum 2)
- [ ] Structure clear (rigid vs flexible)
- [ ] No anti-patterns present
- [ ] Tested in live session
- [ ] Trigger words documented

## Quick Start Template

```bash
# Create new skill
mkdir -p ~/.claude/skills/my-skill

# Use this template
cat > ~/.claude/skills/my-skill/SKILL.md << 'EOF'
---
name: my-skill
description: What this skill does and when to use it (under 200 chars)
version: 1.0.0
---

# My Skill

Brief overview.

## When to Use This Skill

- Scenario 1
- Scenario 2
- Scenario 3

## How It Works

Step-by-step instructions.

## Examples

### Example 1
[Show usage]

### Example 2
[Show edge case]

## Tips

- Helpful tip 1
- Helpful tip 2
EOF

# Validate
cat ~/.claude/skills/my-skill/SKILL.md
```

## Advanced: Skill Dependencies

If your skill depends on other skills:

```markdown
---
name: my-skill
description: My skill description
dependencies:
  - skill-name-1
  - skill-name-2
---

# My Skill

This skill builds on:
- `skill-name-1` for X
- `skill-name-2` for Y

## Usage

First invoke dependencies, then this skill.
```

## Version Control

```bash
# Initialize git for skills
cd ~/.claude/skills/my-skill
git init
git add SKILL.md
git commit -m "Initial skill creation"

# Tag versions
git tag v1.0.0
```

## Distribution

To share your skill:

1. **Via GitHub**:
```bash
cd ~/.claude/skills/my-skill
gh repo create my-skill --public
git push -u origin main
```

2. **Via skills.sh**:
```bash
# Create package in format skills.sh expects
# See: https://skills.sh/docs/publishing
```

3. **Via symlink**:
```bash
# In another project
ln -s ~/.claude/skills/my-skill /path/to/project/.claude/skills/
```

## Maintenance

Update skills regularly:

```bash
# Check all skills
ls ~/.claude/skills/

# Update skill version
# Edit SKILL.md, increment version: 1.0.0 → 1.1.0

# Document changes
echo "## Changelog\n\n### v1.1.0\n- Change 1\n- Change 2" >> ~/.claude/skills/my-skill/CHANGELOG.md
```
