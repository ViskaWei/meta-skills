---
name: skill-init
description: Initialize or sync Claude skills in a new environment. Use when setting up skills on a new machine or syncing updates.
---

# Skill Init - Claude Skills Environment Manager

This skill helps manage the multi-repo skills setup:
- **Public**: `~/claude-skills-public` (fork of awesome-claude-skills)
- **Private**: `~/claude-skills-private` (personal private skills)
- **Scientific**: `~/claude-scientific-writer` (K-Dense-AI scientific writing skills)
- **Active**: `~/.claude/skills/` (symlinks to all repos)

## Commands

### `/skill-init` or `/skill-init setup`
Full setup for a new environment.

### `/skill-init sync`
Sync upstream updates from all repos.

### `/skill-init link`
Rebuild all symlinks (useful after adding new skills).

### `/skill-init status`
Show current setup status.

---

## Configuration

```
GITHUB_USER=ViskaWei
PUBLIC_REPO=awesome-claude-skills
PRIVATE_REPO=claude-skills-private
SCIENTIFIC_REPO=claude-scientific-writer
UPSTREAM_PUBLIC=travisvn/awesome-claude-skills
UPSTREAM_SCIENTIFIC=K-Dense-AI/claude-scientific-writer
```

---

## Instructions

When the user runs this skill, determine which command they want and execute accordingly:

### For `setup` (default):

```bash
# 1. Clone public fork if not exists
if [ ! -d ~/claude-skills-public ]; then
  git clone git@github.com:ViskaWei/awesome-claude-skills.git ~/claude-skills-public
  cd ~/claude-skills-public
  git remote add upstream https://github.com/travisvn/awesome-claude-skills.git
fi

# 2. Clone private repo if not exists
if [ ! -d ~/claude-skills-private ]; then
  git clone git@github.com:ViskaWei/claude-skills-private.git ~/claude-skills-private
fi

# 3. Clone scientific-writer fork if not exists
if [ ! -d ~/claude-scientific-writer ]; then
  git clone git@github.com:ViskaWei/claude-scientific-writer.git ~/claude-scientific-writer
  cd ~/claude-scientific-writer
  git remote add upstream https://github.com/K-Dense-AI/claude-scientific-writer.git
fi

# 4. Create skills directory and symlinks
mkdir -p ~/.claude/skills

# Link public skills (exclude hidden dirs and non-skill files)
for dir in ~/claude-skills-public/*/; do
  dirname=$(basename "$dir")
  [[ ! "$dirname" =~ ^\. ]] && ln -sf "$dir" ~/.claude/skills/"$dirname"
done

# Link private skills
for dir in ~/claude-skills-private/skills/*/; do
  dirname=$(basename "$dir")
  ln -sf "$dir" ~/.claude/skills/"$dirname"
done

# Link scientific-writer skills
for dir in ~/claude-scientific-writer/skills/*/; do
  dirname=$(basename "$dir")
  ln -sf "$dir" ~/.claude/skills/"$dirname"
done

echo "Setup complete! Run '/skill-init status' to verify."
```

### For `sync`:

```bash
echo "=== Syncing all repos ==="

# Sync public fork with upstream
echo -e "\n[Syncing Public]"
cd ~/claude-skills-public
git fetch upstream
git merge upstream/main --no-edit
git push origin main

# Pull latest private
echo -e "\n[Syncing Private]"
cd ~/claude-skills-private
git pull

# Sync scientific-writer fork with upstream
echo -e "\n[Syncing Scientific Writer]"
cd ~/claude-scientific-writer
git fetch upstream
git merge upstream/main --no-edit
git push origin main

# Rebuild symlinks in case new skills were added
echo -e "\n[Rebuilding symlinks]"
# (same linking logic as setup)
```

### For `link`:

```bash
# Clear existing symlinks (preserve non-symlink files)
find ~/.claude/skills -maxdepth 1 -type l -delete

# Recreate all symlinks
for dir in ~/claude-skills-public/*/; do
  dirname=$(basename "$dir")
  [[ ! "$dirname" =~ ^\. ]] && ln -sf "$dir" ~/.claude/skills/"$dirname"
done

for dir in ~/claude-skills-private/skills/*/; do
  dirname=$(basename "$dir")
  ln -sf "$dir" ~/.claude/skills/"$dirname"
done

for dir in ~/claude-scientific-writer/skills/*/; do
  dirname=$(basename "$dir")
  ln -sf "$dir" ~/.claude/skills/"$dirname"
done

echo "Symlinks rebuilt!"
```

### For `status`:

```bash
echo "=== Claude Skills Status ==="

echo -e "\n[Public Repo]"
if [ -d ~/claude-skills-public ]; then
  cd ~/claude-skills-public && git remote -v | head -2
  echo "Skills: $(ls -d */ 2>/dev/null | grep -v '^\.' | wc -l)"
else
  echo "Not found"
fi

echo -e "\n[Private Repo]"
if [ -d ~/claude-skills-private ]; then
  cd ~/claude-skills-private && git remote -v | head -2
  echo "Skills: $(ls -d skills/*/ 2>/dev/null | wc -l)"
else
  echo "Not found"
fi

echo -e "\n[Scientific Writer]"
if [ -d ~/claude-scientific-writer ]; then
  cd ~/claude-scientific-writer && git remote -v | head -2
  echo "Skills: $(ls -d skills/*/ 2>/dev/null | wc -l)"
else
  echo "Not found"
fi

echo -e "\n[Active Skills]"
if [ -d ~/.claude/skills ]; then
  echo "Total: $(ls ~/.claude/skills | wc -l)"
  echo "  Public: $(ls -l ~/.claude/skills | grep claude-skills-public | wc -l)"
  echo "  Private: $(ls -l ~/.claude/skills | grep claude-skills-private | wc -l)"
  echo "  Scientific: $(ls -l ~/.claude/skills | grep claude-scientific-writer | wc -l)"
else
  echo "Not configured"
fi
```

## Output

After running any command, report:
1. What was done
2. Any errors encountered
3. Current status summary

## New Environment Quick Start

```bash
# 1. Clone private repo first (contains skill-init)
git clone git@github.com:ViskaWei/claude-skills-private.git ~/claude-skills-private

# 2. Bootstrap skill-init
mkdir -p ~/.claude/skills
ln -s ~/claude-skills-private/skills/skill-init ~/.claude/skills/

# 3. Run full setup
/skill-init
```
