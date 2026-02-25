---
name: smart-router
description: "Shared routing algorithm for all L0 entry commands. Parses unified flags, matches path templates, injects policies."
---

# Smart Router

All L0 commands share this routing algorithm. It resolves user intent to the correct L1 path template or L2 capability sequence.

## Unified Flags

| Flag | Short | Description | Default |
|---|---|---|---|
| `--goal "..."` | `-g` | One-line objective | Extracted from natural language |
| `--input <url\|file\|repo\|text>` | `-i` | Input source | Auto-detect |
| `--kind standards\|papers\|systems\|tools\|people` | `-k` | Search type (/search only) | — |
| `--output <artifact_type>` | `-o` | Target artifact type | router_profile.default_output |
| `--depth fast\|standard\|deep` | `-d` | Depth of execution | standard |
| `--time 15m\|1h\|halfday` | `-t` | Time budget | 1h |
| `--viz on\|off` | | Enable visualization | on |
| `--strict on\|off` | | Strict mode (fail on any warning) | off (/fix forces on) |
| `--path <path-id>` | `-p` | Direct path override (advanced) | — |
| `--team on\|off\|auto` | | Team dispatch mode | auto |

## Routing Algorithm

### Step 1: Direct Override
If `--path <path-id>` (or `-p <path-id>`) is provided, skip routing — use that path directly.

### Step 2: Load Router Profile
Each L0 command has a `router_profile` (defined in skills-registry.yaml L0 section):
- `candidate_paths`: list of path-ids this L0 can route to
- `default_output`: default artifact type
- `default_rules`: policies always injected

### Step 3: Detect Input Type
Parse `--input` (or `-i`) flag or infer from natural language:
- URL (http/https) → `url` type
- File path → `file-path` type
- Repository → `repo` type
- Free text → `goal-statement` type

### Step 4: Detect Target Artifact
Parse `--output` (or `-o`) flag or infer from `--goal`:
- Explicit `--output <type>` → use that type
- Keywords in goal → map to artifact type (e.g., "report" → `paper-draft`, "web" → `web-page`)
- Fallback → `router_profile.default_output`

### Step 5: Score Candidate Paths
For each path in `candidate_paths`:
1. Check input type compatibility (path.input_types ∩ detected_input)
2. Check output type compatibility (path.output_types ∩ target_output)
3. Check keyword overlap (path.triggers ∩ user_keywords)
4. Compute confidence = weighted sum (input: 0.3, output: 0.4, keywords: 0.3)

### Step 6: Route Decision
- **confidence ≥ 0.8** → Auto-execute top path
- **0.5 ≤ confidence < 0.8** → Show top path, ask user to confirm
- **confidence < 0.5** → List all candidate paths, ask user to choose

### Step 7: Execute

#### Step 7a: Direct Execute (execution_mode: direct)
1. Load selected path template from `_paths/`
2. Inject `default_rules` from router_profile
3. Call `_resolver/resolver.md` to expand steps to L2 capabilities
4. Execute step by step with gate checks

#### Step 7b: Team Dispatch (execution_mode: team)
When selected path has `execution_mode: team` AND team execution is enabled:

**Team enabled when**: `--team on`, OR (`--team auto` AND `--depth` is `standard` or `deep`)
**Team disabled when**: `--team off`, OR (`--team auto` AND `--depth` is `fast`)

Execution flow:
1. **Analyze** — Read path's `parallel_groups` field
2. **Plan** — Classify steps into sequential (leader) and parallel (workers)
3. **Spawn** — Create agent team via Claude Code Team/Task system:
   - `TeamCreate` with `run-<path-id>-<timestamp>` as team name
   - `TaskCreate` per parallel group
   - `Task` tool spawns worker agents (one per parallel group)
4. **Execute sequential steps** — Leader handles all non-parallel steps directly
5. **Execute parallel groups** — Workers run their assigned steps concurrently
6. **Merge** — At `merge_at` step, leader waits for all workers, collects artifacts
7. **Resume** — Leader continues sequential execution after merge point
8. **Cleanup** — Send shutdown to workers, `TeamDelete`

**PAUSE gates**: Only the team leader handles user confirmation steps (PAUSE/ADR). Workers never interact with the user directly.

**Artifact handoff**: Workers write artifacts to `$PROJECT/runs/<run-id>/artifacts/<step-id>/`. Leader reads from these paths at merge points.

#### Execution Mode Decision
```
if --team == on:       always team (if path has ≥2 steps)
if --team == off:      always direct
if --team == auto:     use path's execution_mode field
  execution_mode: direct → direct
  execution_mode: team   → team (unless --depth fast → downgrade to direct)
  execution_mode: auto   → step_count > 8 AND parallel_groups? team : direct
```

## Execution Modes

Each L1 path template declares an `execution_mode` field:

| Mode | Description | When Used |
|---|---|---|
| `direct` | Single agent, sequential steps | ≤6 steps, linear dependency chain |
| `team` | Multi-agent with parallel groups | ≥7 steps with parallelizable work |
| `auto` | Router decides based on depth + step count | Borderline complexity |

See `_resolver/execution-modes.yaml` for full classification criteria.

## Depth Mapping

| `--depth` / `-d` | Behavior |
|---|---|
| `fast` | Skip optional steps, minimal output, 15min budget |
| `standard` | Normal execution, all required steps |
| `deep` | All steps including optional, extra validation, thorough output |

## Fallback: Direct Capability Assembly

If no path template matches (confidence < 0.3 for all candidates), the router:
1. Identifies the most relevant L2 capabilities via `capability-index.yaml`
2. Assembles an ad-hoc sequence based on input→output type chain
3. Injects default_rules
4. Executes the assembled sequence

This avoids the need to create a path template for every possible use case.

## Flag Parsing Rules

1. Flags can appear anywhere after the command name
2. Quoted values: `--goal "my objective"` or `--goal 'my objective'`
3. Boolean flags: `--strict` = `--strict on`, `--no-strict` = `--strict off`
4. Short aliases: `-g` = `--goal`, `-i` = `--input`, `-o` = `--output`, `-d` = `--depth`, `-t` = `--time`, `-k` = `--kind`, `-p` = `--path`
5. Unknown flags are ignored with a warning
