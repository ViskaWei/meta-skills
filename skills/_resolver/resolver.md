# Resolver — Path Template to Execution Plan

Resolves a Path Template ID into a concrete execution plan by mapping capability IDs to block files.

## Algorithm

```
RESOLVE(path_id, context_params):

  1. LOAD Path Template
     - Read `_paths/<path_id>.yaml`
     - Validate: id, steps, applicable_policies exist
     - If not found: FAIL with "Unknown path template: <path_id>"

  2. FOR EACH step IN template.steps:
     a. RESOLVE capability IDs
        - For each cap_id in step.capabilities_needed:
          - Look up cap_id in `_resolver/capability-index.yaml`
          - Validate verb from cap_id against `_resolver/verbs.yaml`
          - Validate object from cap_id against `_resolver/objects.yaml`
          - If no match: try FUZZY SEARCH (see §3 below)
     b. SELECT block file
        - If multiple blocks match (multi-provider):
          - Rank by leveling (prefer higher P & M scores)
          - Use context_params to break ties (e.g., domain preference)
        - If no match: WARN "Unresolved capability: <cap_id>"
     c. CHECK gate_requires: all required outputs from prior steps exist
     d. CONTRACT VALIDATION (if block has YAML frontmatter):
        - Validate inputs available from prior step outputs
        - Validate preconditions met

  3. FUZZY SEARCH (when exact cap_id not in index)
     a. BY VERB + OBJECT PATTERN:
        - Parse cap_id → verb, object
        - Search capability-index for entries matching verb or object
        - Return ranked candidates
     b. BY OUTPUT TYPE:
        - Query: "I need a capability that produces <output-type>"
        - Scan capability-index entries with cap_contract: true
        - Read frontmatter from each block file
        - Match against outputs field in contract
        - Return matching cap_ids
     c. BY INPUT TYPE:
        - Query: "I have <input-type>, what capabilities can use it?"
        - Same scan as output-type but matching inputs field
     d. BY STAGE:
        - Query: "What capabilities are in <stage>?"
        - Filter capability-index by stage field

  4. LOAD POLICIES
     a. template.applicable_policies.required → always inject
     b. template.applicable_policies.recommended → inject if context matches
     c. Context overrides: context_params.extra_policies → also inject
     - Read each `_policies/<rule-id>.yaml`
     - Validate: id, triggers, evidence_requirements exist

  5. INSERT POLICY CHECKS at gate points
     - For each policy:
       - Match policy.triggers.output_types against step.output_type
       - If match: insert policy.verify_capabilities BEFORE the step's gate
       - If policy.injection_point.before_step matches: insert there

  6. GENERATE run_id
     - Format: run-<path_id>-<context>-<yyyymmdd>-<seq>
     - <context>: sanitized from context_params.name (kebab-case, max 30 chars)
     - <yyyymmdd>: today's date
     - <seq>: auto-increment within same day+context (01, 02, ...)

  7. RETURN resolved execution plan:
     {
       run_id: "run-path-paper-15min-brief-arxiv-2506-20430-20260223-01",
       path_id: "path-paper-15min-brief",
       steps: [
         { id: "intake", block: "discover/sub/intake.md", cap_id: "cap-intake-brief" },
         { id: "skim", block: "discover/sub/literature-skim.md", cap_id: "cap-extract-literature-skim" },
         ...
       ],
       policies: [ "rule-quality-deliverable-minimum" ],
       branches: [ ... ],
       stop_rules: { ... }
     }
```

## Capability Matching Rules

1. **Direct lookup**: `cap-intake-brief` → capability-index → `_stages/discover/sub/intake.md`
2. **Multi-provider**: If multiple blocks implement the same capability, use leveling to rank
3. **Domain tools**: Some capabilities resolve to `_tools/<family>/<name>.md`
4. **Composite**: A step.capabilities_needed may list multiple cap_ids — ALL must resolve
5. **Contract validation**: If block has YAML frontmatter, validate input/output type compatibility
6. **Fuzzy search**: When exact ID not found, search by verb, object, or output type

## Fuzzy Search Examples

```
# Find by output type
SEARCH(output_type="evidence-bundle")
→ cap-assemble-evidence-bundle (block: verify/sub/evidence-bundle.md)

# Find by verb
SEARCH(verb="check")
→ cap-check-metric-sanity, cap-check-reproducibility, cap-check-paper-structure, ...

# Find by object pattern
SEARCH(object="paper*")
→ cap-check-paper-structure, cap-build-paper-outline, cap-build-paper-draft, ...

# Find by stage
SEARCH(stage="discover")
→ cap-intake-brief, cap-extract-brief, cap-map-context, ...
```

## Fallback Behavior

If resolution fails at any step:
1. Log the failure with step ID and missing capability
2. Check if the old orchestrator file exists (e.g., `workflow/sub/research-loop.md`)
3. If old orchestrator exists: fall back to it with a deprecation warning
4. If no fallback: FAIL with clear error message

## Policy Injection Rules

1. Policies with `output_types: ["*"]` apply to ALL steps that have a gate
2. Policies with specific output_types apply only when step.output_type matches
3. Multiple policies can apply to the same step — checks are cumulative
4. Policy checks run BEFORE the quality-gate step (evidence collection phase)

## Run ID Format

```
run-<path-id>-<context>-<yyyymmdd>-<seq>
```

Examples:
- `run-path-paper-15min-brief-arxiv-2506-20430-20260223-01`
- `run-path-research-hypothesis-to-evidence-ips-nn-20260223-01`
- `run-path-webui-build-verify-release-blade-web-20260223-02`

## Execution Record Storage

```
$PROJECT/runs/<run-id>/
  plan.yaml          # Resolved execution plan
  status.yaml        # Current step, pass/fail history
  artifacts/         # Step outputs (symlinked or copied)
  evidence/          # Policy check results
```

## Governance Files

| File | Purpose |
|---|---|
| `_resolver/verbs.yaml` | 18 canonical verbs + aliases |
| `_resolver/objects.yaml` | 89 canonical objects + domains |
| `_resolver/artifact-types.yaml` | 98 artifact type definitions |
| `_resolver/capability-index.yaml` | cap-* → block file mapping (91 entries) |
