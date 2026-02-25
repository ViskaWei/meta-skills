#!/bin/bash
# meta-skills Setup Script (Standalone)
# Deploys the meta-skills framework to ~/.claude/skills/
#
# Usage: bash tools/setup.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_DIR="$HOME/.claude/skills"

echo "=== meta-skills Setup ==="
echo "Source: $REPO_DIR"
echo "Target: $SKILLS_DIR"
echo ""

mkdir -p "$SKILLS_DIR"

# --- Step 1: Deploy L0 commands ---
echo "Step 1: Deploying L0 commands..."
L0_COMMANDS=(meta build research improve)
for cmd in "${L0_COMMANDS[@]}"; do
  if [ -d "$REPO_DIR/skills/$cmd" ]; then
    rm -rf "$SKILLS_DIR/$cmd" 2>/dev/null || true
    cp -rL "$REPO_DIR/skills/$cmd" "$SKILLS_DIR/$cmd"
    echo "  OK: $cmd"
  else
    echo "  SKIP: $cmd (not found)"
  fi
done

# --- Step 2: Deploy lifecycle stages ---
echo ""
echo "Step 2: Deploying lifecycle stages..."
STAGES=(discover decide build verify deliver operate review knowledge)
mkdir -p "$SKILLS_DIR/_stages"
for stage in "${STAGES[@]}"; do
  rm -rf "$SKILLS_DIR/_stages/$stage" 2>/dev/null || true
  cp -rL "$REPO_DIR/skills/_stages/$stage" "$SKILLS_DIR/_stages/$stage"
  echo "  OK: _stages/$stage"
done

# --- Step 3: Deploy architecture layers ---
echo ""
echo "Step 3: Deploying architecture..."
for dir in _paths _policies _resolver _standards; do
  if [ -d "$REPO_DIR/skills/$dir" ]; then
    rm -rf "$SKILLS_DIR/$dir" 2>/dev/null || true
    cp -rL "$REPO_DIR/skills/$dir" "$SKILLS_DIR/$dir"
    echo "  OK: $dir"
  fi
done

# --- Step 4: Link tools ---
echo ""
echo "Step 4: Linking tools..."
rm -rf "$SKILLS_DIR/_tools" 2>/dev/null || true
ln -sf "$REPO_DIR/skills/_tools" "$SKILLS_DIR/_tools"
echo "  OK: _tools"

# --- Step 5: Link registry ---
echo ""
echo "Step 5: Linking registry..."
ln -sf "$REPO_DIR/skills-registry.yaml" "$SKILLS_DIR/skills-registry.yaml"
echo "  OK: skills-registry.yaml"

# --- Step 6: Verify ---
echo ""
echo "=== Verification ==="
FAIL=0

# Check L0 commands
L0_COMMANDS=(meta build research improve)
for cmd in "${L0_COMMANDS[@]}"; do
  if [ -f "$SKILLS_DIR/$cmd/SKILL.md" ]; then
    echo "  OK: $cmd/SKILL.md"
  else
    echo "  FAIL: $cmd/SKILL.md missing!"
    FAIL=1
  fi
done

# Check stages
for stage in "${STAGES[@]}"; do
  if [ -d "$SKILLS_DIR/_stages/$stage" ]; then
    echo "  OK: _stages/$stage"
  else
    echo "  FAIL: _stages/$stage missing!"
    FAIL=1
  fi
done

# Check architecture dirs
for dir in _paths _policies _resolver _standards _tools; do
  if [ -d "$SKILLS_DIR/$dir" ]; then
    count=$(find "$SKILLS_DIR/$dir" -name "*.yaml" -o -name "*.md" 2>/dev/null | wc -l)
    echo "  OK: $dir ($count files)"
  else
    echo "  MISSING: $dir"
    FAIL=1
  fi
done

# Check registry
if [ -f "$SKILLS_DIR/skills-registry.yaml" ] || [ -L "$SKILLS_DIR/skills-registry.yaml" ]; then
  echo "  OK: skills-registry.yaml"
else
  echo "  FAIL: skills-registry.yaml missing!"
  FAIL=1
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  echo "=== Setup complete! ==="
  echo "4 L0 commands available: /meta, /build, /research, /improve"
  echo "Use '/meta health' to check framework health."
else
  echo "=== Setup completed with warnings ==="
  echo "Some components may be missing. Check the FAIL messages above."
fi
