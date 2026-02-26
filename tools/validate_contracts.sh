#!/bin/bash
# Validate Cap Contracts (FDPS v4)
# Checks YAML frontmatter in capability .md files for correctness.
#
# Validations:
#   1. Required frontmatter fields present: cap_id, verb, object, stage, inputs, outputs, leveling
#   2. cap_id exists in capability-catalog.yaml
#   3. verb is in verbs.yaml canonical list
#   4. object is in objects.yaml canonical list
#   5. input/output types are in artifact-types.yaml
#   6. leveling format is Gx-Vy-Pz-Mk
#
# Usage: bash tools/validate_contracts.sh [--all | --file <path>]

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_DIR="$REPO_DIR/skills"
CAP_CATALOG="$SKILLS_DIR/_resolver/capability-catalog.yaml"
VERBS_FILE="$SKILLS_DIR/_resolver/verbs.yaml"
OBJECTS_FILE="$SKILLS_DIR/_resolver/objects.yaml"
ARTIFACT_TYPES="$SKILLS_DIR/_resolver/artifact-types.yaml"

ERRORS=0
WARNINGS=0
CHECKED=0
SKIPPED=0

REQUIRED_FIELDS="cap_id verb object stage inputs outputs leveling"

echo "=== Validate Cap Contracts ==="
echo ""

# Collect all artifact type IDs
all_artifact_types=$(grep -E '^ {4}- id: ' "$ARTIFACT_TYPES" | awk '{print $3}')

# Collect canonical verbs
canonical_verbs=$(grep -E '^ {2}[a-z]+(-[a-z]+)*:$' "$VERBS_FILE" | sed 's/://g' | awk '{print $1}')

# Collect canonical objects
canonical_objects=$(grep -E '^ {2}[a-z]+(-[a-z]+)*:$' "$OBJECTS_FILE" | sed 's/://g' | awk '{print $1}')

# Determine which files to check
files_to_check=()
if [ "${1:-}" = "--file" ] && [ -n "${2:-}" ]; then
  files_to_check=("$2")
elif [ "${1:-}" = "--all" ]; then
  while IFS= read -r -d '' f; do
    files_to_check+=("$f")
  done < <(find "$SKILLS_DIR/_caps" -name "*.md" -type f -print0 2>/dev/null)
else
  # Default: only check files that have frontmatter
  while IFS= read -r -d '' f; do
    if head -1 "$f" | grep -q '^---$'; then
      files_to_check+=("$f")
    fi
  done < <(find "$SKILLS_DIR/_caps" -name "*.md" -type f -print0 2>/dev/null)
fi

for md_file in "${files_to_check[@]}"; do
  rel_path="${md_file#$SKILLS_DIR/}"

  # Check if file has YAML frontmatter
  if ! head -1 "$md_file" | grep -q '^---$'; then
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  CHECKED=$((CHECKED + 1))

  # Extract frontmatter (between first --- and second ---)
  frontmatter=$(sed -n '/^---$/,/^---$/p' "$md_file" | sed '1d;$d')

  if [ -z "$frontmatter" ]; then
    echo "  ERROR: $rel_path — empty frontmatter"
    ERRORS=$((ERRORS + 1))
    continue
  fi

  # Check required fields
  for field in $REQUIRED_FIELDS; do
    if ! echo "$frontmatter" | grep -q "^${field}:"; then
      echo "  ERROR: $rel_path — missing required field: $field"
      ERRORS=$((ERRORS + 1))
    fi
  done

  # Extract values
  cap_id=$(echo "$frontmatter" | grep '^cap_id:' | awk '{print $2}' | tr -d '"')
  verb=$(echo "$frontmatter" | grep '^verb:' | awk '{print $2}' | tr -d '"')
  object=$(echo "$frontmatter" | grep '^object:' | awk '{print $2}' | tr -d '"')
  leveling=$(echo "$frontmatter" | grep '^leveling:' | awk '{print $2}' | tr -d '"')

  # Check cap_id exists in capability-catalog
  if [ -n "$cap_id" ]; then
    if ! grep -q "^  ${cap_id}:" "$CAP_CATALOG" 2>/dev/null; then
      echo "  ERROR: $rel_path — cap_id '$cap_id' NOT in capability-catalog.yaml"
      ERRORS=$((ERRORS + 1))
    fi
  fi

  # Check verb is canonical
  if [ -n "$verb" ]; then
    if ! echo "$canonical_verbs" | grep -qw "$verb"; then
      echo "  ERROR: $rel_path — verb '$verb' NOT in canonical verb list"
      ERRORS=$((ERRORS + 1))
    fi
  fi

  # Check object is canonical
  if [ -n "$object" ]; then
    if ! echo "$canonical_objects" | grep -qw "$object"; then
      echo "  ERROR: $rel_path — object '$object' NOT in canonical object list"
      ERRORS=$((ERRORS + 1))
    fi
  fi

  # Check leveling format
  if [ -n "$leveling" ]; then
    if ! echo "$leveling" | grep -qP '^G[0-3]-V[0-3]-P[0-3]-M[0-4]$'; then
      echo "  ERROR: $rel_path — leveling '$leveling' doesn't match Gx-Vy-Pz-Mk format"
      ERRORS=$((ERRORS + 1))
    fi
  fi

  # Check input types are valid artifact types
  inputs=$(echo "$frontmatter" | grep -oP 'inputs: \[\K[^\]]+' | tr ',' '\n' | tr -d ' ')
  for input_type in $inputs; do
    if ! echo "$all_artifact_types" | grep -qw "$input_type"; then
      echo "  WARNING: $rel_path — input type '$input_type' NOT in artifact-types.yaml"
      WARNINGS=$((WARNINGS + 1))
    fi
  done

  # Check output types are valid artifact types
  outputs=$(echo "$frontmatter" | grep -oP 'outputs: \[\K[^\]]+' | tr ',' '\n' | tr -d ' ')
  for output_type in $outputs; do
    if ! echo "$all_artifact_types" | grep -qw "$output_type"; then
      echo "  WARNING: $rel_path — output type '$output_type' NOT in artifact-types.yaml"
      WARNINGS=$((WARNINGS + 1))
    fi
  done
done

# --- Summary ---
echo ""
echo "=== Summary ==="
echo "Checked:  $CHECKED files with frontmatter"
echo "Skipped:  $SKIPPED files without frontmatter"
echo "Errors:   $ERRORS"
echo "Warnings: $WARNINGS"

if [ "$ERRORS" -gt 0 ]; then
  echo ""
  echo "FAIL — Fix errors above before proceeding."
  exit 1
else
  echo ""
  echo "PASS — All contract validations passed."
  exit 0
fi
