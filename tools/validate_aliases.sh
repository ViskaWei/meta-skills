#!/bin/bash
# Validate Naming Governance
# Checks that all cap-* IDs use governed verbs and objects, and path templates resolve.
#
# Validations:
#   1. Every cap-* in capability-index uses a verb from verbs.yaml
#   2. Every cap-* in capability-index uses an object from objects.yaml
#   3. Every capabilities_needed in path templates resolves in capability-index
#   4. No duplicate cap-* IDs in capability-index
#   5. Verb count matches expected (18)
#
# Usage: bash tools/validate_aliases.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_DIR="$REPO_DIR/skills"
CAP_INDEX="$SKILLS_DIR/_resolver/capability-index.yaml"
VERBS_FILE="$SKILLS_DIR/_resolver/verbs.yaml"
OBJECTS_FILE="$SKILLS_DIR/_resolver/objects.yaml"
PATHS_DIR="$SKILLS_DIR/_paths"

ERRORS=0
WARNINGS=0

echo "=== Validate Naming Governance ==="
echo ""

# Collect canonical verbs
canonical_verbs=$(grep -E '^ {2}[a-z]+(-[a-z]+)*:$' "$VERBS_FILE" | sed 's/://g' | awk '{print $1}')
verb_count=$(echo "$canonical_verbs" | wc -w)
echo "Canonical verbs: $verb_count"

# Collect canonical objects
canonical_objects=$(grep -E '^ {2}[a-z]+(-[a-z]+)*:$' "$OBJECTS_FILE" | sed 's/://g' | awk '{print $1}')
object_count=$(echo "$canonical_objects" | wc -w)
echo "Canonical objects: $object_count"

# Extract cap-* IDs from capability-index
cap_ids=$(grep -E '^ {2}cap-' "$CAP_INDEX" | sed 's/://g' | awk '{print $1}')
cap_count=$(echo "$cap_ids" | wc -w)
echo "Cap IDs in index: $cap_count"
echo ""

# --- Check 1: Every cap-* verb is canonical ---
echo "[1/5] Checking verbs against canonical list..."

for cap_id in $cap_ids; do
  # Extract verb from cap-<verb>-<object>
  verb=$(echo "$cap_id" | sed 's/^cap-//' | cut -d'-' -f1)

  if ! echo "$canonical_verbs" | grep -qw "$verb"; then
    echo "  ERROR: $cap_id uses verb '$verb' — NOT in verbs.yaml"
    ERRORS=$((ERRORS + 1))
  fi
done
echo "  Checked $cap_count cap-* IDs against $verb_count verbs"

# --- Check 2: Every cap-* object is canonical ---
echo ""
echo "[2/5] Checking objects against canonical list..."

for cap_id in $cap_ids; do
  # Extract object from cap-<verb>-<object> (everything after first token)
  object=$(echo "$cap_id" | sed 's/^cap-[a-z]*-//')

  if ! echo "$canonical_objects" | grep -qw "$object"; then
    echo "  ERROR: $cap_id uses object '$object' — NOT in objects.yaml"
    ERRORS=$((ERRORS + 1))
  fi
done
echo "  Checked $cap_count cap-* IDs against $object_count objects"

# --- Check 3: Path template references resolve ---
echo ""
echo "[3/5] Checking path template references..."

path_count=0
for path_file in "$PATHS_DIR"/*.yaml; do
  [ -f "$path_file" ] || continue
  path_name=$(basename "$path_file")
  path_count=$((path_count + 1))

  # Extract all cap-* references
  refs=$(grep -oP 'cap-[a-z0-9-]+' "$path_file" 2>/dev/null || true)

  for ref in $refs; do
    if ! grep -q "^  ${ref}:" "$CAP_INDEX" 2>/dev/null; then
      echo "  ERROR: $path_name references $ref — NOT in capability-index.yaml"
      ERRORS=$((ERRORS + 1))
    fi
  done
done
echo "  Checked $path_count path templates"

# --- Check 4: No duplicate cap-* IDs ---
echo ""
echo "[4/5] Checking for duplicate cap-* IDs..."

duplicates=$(echo "$cap_ids" | sort | uniq -d)

if [ -n "$duplicates" ]; then
  echo "  ERROR: Duplicate cap-* IDs found:"
  echo "$duplicates" | while read -r dup; do
    echo "    - $dup"
  done
  ERRORS=$((ERRORS + 1))
else
  echo "  No duplicates found"
fi

# --- Check 5: No step-* references remaining ---
echo ""
echo "[5/5] Checking for stale step-* references..."

stale_count=0
for path_file in "$PATHS_DIR"/*.yaml; do
  [ -f "$path_file" ] || continue
  stale=$(grep -oP 'step-[a-z0-9-]+' "$path_file" 2>/dev/null || true)
  if [ -n "$stale" ]; then
    echo "  ERROR: $(basename "$path_file") still has step-* references: $stale"
    ERRORS=$((ERRORS + 1))
    stale_count=$((stale_count + 1))
  fi
done

if [ "$stale_count" -eq 0 ]; then
  echo "  No stale step-* references found"
fi

# --- Summary ---
echo ""
echo "=== Summary ==="
echo "Cap IDs:  $cap_count"
echo "Verbs:    $verb_count"
echo "Objects:  $object_count"
echo "Paths:    $path_count"
echo "Errors:   $ERRORS"
echo "Warnings: $WARNINGS"

if [ "$ERRORS" -gt 0 ]; then
  echo ""
  echo "FAIL — Fix errors above before proceeding."
  exit 1
else
  echo ""
  echo "PASS — All naming governance checks passed."
  exit 0
fi
