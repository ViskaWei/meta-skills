# meta-skills

A self-maintaining, self-improving skill framework for AI coding agents.

## What is this?

meta-skills is a **3-layer architecture** for organizing AI agent capabilities into a composable, evolvable system. It provides:

- **L0 Entry Commands** -- User-facing skill invocations (e.g., `/meta health`)
- **L1 Path Templates** -- Multi-step recipes that chain atomic capabilities
- **L2 Atomic Capabilities** -- Building blocks with standardized interfaces

The framework is designed to be a **seed** -- clone it, grow your own skill tree, and use the built-in meta commands to maintain quality as it evolves.

## Architecture

```
User Input --> L0 Command --> L1 Path Template --> L2 Capabilities
                   |                |                     |
              /meta health    path-general-        cap-intake-brief
                              skill-health         cap-decide-quality-gate
                                                   cap-build-implementation
```

### Layer 0: Entry Commands

The single L0 entry point is `/meta` with subcommands:

| Sub-command | What it does |
|---|---|
| `health` | 6-dimension health dashboard (naming, contracts, registry, deploy, coverage, dedup) |
| `scout` | Discover + evaluate + integrate external skills into the 3-layer architecture |
| `quality` | Quality audit against skill-creator-standard |
| `cleanup` | Entropy cleanup (9-point consistency check + auto-fix) |
| `gaps` | Capability gap diagnosis (tool, guardrail, abstraction, documentation gaps) |
| `lifecycle` | Version upgrade / deprecate / promote / archive |
| `annotate` | Batch-annotate missing frontmatter on L2 blocks |
| `rule` | Extract rules/policies from session patterns |
| `all` | Full sweep: context + harden + gaps + cleanup |

### Layer 1: Path Templates

9 multi-step recipes that orchestrate L2 capabilities:

| Path | Sub-command | Steps | Description |
|---|---|---|---|
| `path-general-skill-health` | `health` | 12 | Full-system inventory + 6-dimension scoring + auto-fix |
| `path-general-skill-scout-integrate` | `scout` | 6 | External skill discovery + 5-dim evaluation + adaptation |
| `path-general-skill-quality` | `quality` | 11 | Standards audit + critic loop + deployment verification |
| `path-general-entropy-cleanup` | `cleanup` | 11 | 9-point consistency check + structural fixes |
| `path-general-capability-gap` | `gaps` | 9 | Failure signal collection + gap classification + auto-build |
| `path-general-skill-lifecycle` | `lifecycle` | 7 | Maturity classification + batch lifecycle actions |
| `path-general-skill-annotate` | `annotate` | 7 | Scan unannotated blocks + classify + batch apply |
| `path-standards-session-to-rule` | `rule` | 6 | Extract session patterns into rule-*.yaml policies |
| `path-general-improve-loop` | (internal) | -- | Shared improve-verify-critic loop |

### Layer 2: Atomic Capabilities

21 core building blocks organized by lifecycle stage:

| Stage | Capabilities | Count |
|---|---|---|
| **Discover** | `brief`, `intake`, `standards-scout` | 3 |
| **Decide** | `adr`, `option-matrix`, `roadmap-mvp` | 3 |
| **Build** | `implementation`, `scaffold`, `results-table` | 3 |
| **Verify** | `quality-gate`, `evidence-bundle`, `deliverable-check` | 3 |
| **Deliver** | `package`, `handoff-guide` | 2 |
| **Operate** | `telemetry`, `experiment-tracker` | 2 |
| **Review** | `improvement-critic`, `exp-retro` | 2 |
| **Knowledge** | `capture`, `index`, `hub-sync` | 3 |

Each capability has a standardized interface defined in YAML frontmatter:
- `cap_id`: Unique identifier (`cap-<verb>-<object>`)
- `verb`: From 18 controlled verbs
- `object`: From canonical object vocabulary
- `inputs` / `outputs`: Typed artifact contracts
- `leveling`: `Gx-Vy-Pz-Mk` maturity tag

### Cross-cutting: Policies

8 quality gate policies that auto-inject at verification points:

| Policy | When it fires |
|---|---|
| `rule-completion-guard` | Every path -- ensures all steps complete |
| `rule-quality-deliverable-minimum` | Build/deliver -- minimum quality bar |
| `rule-improve-verify-result` | Verify -- before/after evidence required |
| `rule-skill-build-gate` | Build stage -- naming + contract + registry checks |
| `rule-skill-health-gate` | Health check -- 6-dimension pass criteria |
| `rule-entropy-cleanup-gate` | Cleanup -- 9-point consistency pass criteria |
| `rule-capability-gap-detection` | Gap analysis -- gap classification standards |
| `rule-layer-dependency` | All -- enforces layer separation (L0/L1/L2) |

### 8-Stage Lifecycle

```
Discover --> Decide --> Build --> Verify --> Deliver --> Operate --> Review --> Knowledge
   |            |         |         |          |           |          |           |
 brief        ADR     artifact   evidence   package    telemetry   retro     capture
hypothesis  roadmap              PASS                                        knowledge
```

Each stage has a gate that produces/requires specific artifact types. Policies auto-inject at gate boundaries.

## Quickstart

```bash
# 1. Clone
git clone https://github.com/ViskaWei/meta-skills.git

# 2. Deploy to Claude Code
cd meta-skills
bash tools/setup.sh

# 3. Use in any project
/meta health          # Check framework health
/meta gaps            # Find capability gaps
/meta scout           # Discover external skills
/meta quality <skill> # Audit a specific skill
```

## Growing Your Skill Tree

The framework is designed as a seed. To add domain-specific capabilities:

1. **Create L2 capabilities** in `skills/_stages/<stage>/sub/` with YAML frontmatter
2. **Create L1 path templates** in `skills/_paths/` to orchestrate them
3. **Add policies** in `skills/_policies/` for quality gates
4. **Register** in `skills-registry.yaml`
5. **Deploy** with `bash tools/setup.sh`
6. **Maintain** with `/meta quality` and `/meta health`

### Naming Conventions

All identifiers follow strict naming governance:

- **Capabilities**: `cap-<verb>-<object>` (18 controlled verbs, see `skills/_resolver/verbs.yaml`)
- **Paths**: `path-<domain>-<outcome>`
- **Policies**: `rule-<scope>-<intent>`
- **Execution records**: `run-<path-id>-<context>-<yyyymmdd>-<seq>`

Lint rules:
1. kebab-case only (no camelCase, no underscores)
2. 3-6 tokens including prefix
3. Verb from controlled vocabulary only
4. Object from governed list only
5. No implementation details in names

### Leveling System

Every capability gets a `Gx-Vy-Pz-Mk` maturity tag:

| Dimension | Range | Meaning |
|---|---|---|
| **G** (Generality) | G0-G3 | G0=ephemeral, G3=core cross-domain |
| **V** (Volatility) | V0-V3 | V0=stable, V3=fast-changing |
| **P** (Proficiency) | P0-P3 | P0=draft, P3=hardened |
| **M** (Maturity) | M0-M4 | M0=stub, M4=observed in production |

## File Structure

```
meta-skills/
  skills/
    meta/                    # L0: Entry command (auto-discovered by Claude Code)
      SKILL.md               # Skill definition with routing table
    _stages/                 # L2: 8 lifecycle stages (hidden)
      discover/sub/          #   3 capabilities
      decide/sub/            #   3 capabilities
      build/sub/             #   3 capabilities
      verify/sub/            #   3 capabilities
      deliver/sub/           #   2 capabilities
      operate/sub/           #   2 capabilities
      review/sub/            #   2 capabilities
      knowledge/sub/         #   3 capabilities
    _paths/                  # L1: 9 path templates (hidden)
    _policies/               # Cross-cutting: 8 quality policies (hidden)
    _resolver/               # Resolver + governance files
      capability-index.yaml  #   cap-* to block file mapping
      verbs.yaml             #   18 canonical verbs + aliases
      objects.yaml           #   Canonical objects vocabulary
      artifact-types.yaml    #   Artifact type definitions
      resolver.md            #   Resolution algorithm
    _tools/                  # Domain tool families
    _standards/              # Governance tools
  skills-registry.yaml       # Master registry
  tools/
    setup.sh                 # Deploy to ~/.claude/skills/
    build_capability_index.sh
    validate_contracts.sh
    validate_aliases.sh
  CLAUDE.md                  # Project instructions for Claude Code
  LICENSE
```

**Key rule**: Directories starting with `_` are hidden from Claude Code auto-discovery. Only the `meta/` directory (containing `SKILL.md`) is auto-discovered as a skill.

## Validation

```bash
bash tools/validate_contracts.sh        # Validate YAML frontmatter on all capabilities
bash tools/validate_contracts.sh --file skills/_stages/build/sub/implementation.md
bash tools/validate_aliases.sh          # Validate naming governance (verbs, objects, refs)
bash tools/build_capability_index.sh    # Rebuild capability-index.yaml from block files
```

## Submodule Integration

To use meta-skills as a foundation for a larger skill system:

```bash
# Add as submodule
cd your-skills-repo
git submodule add https://github.com/ViskaWei/meta-skills.git meta-skills

# Your setup.sh should:
# 1. Deploy core from submodule first
# 2. Overlay your domain-specific extensions (additional L0 commands, paths, capabilities)
# 3. Use your extended resolver (superset of verbs/objects)
```

This pattern lets you maintain the meta-skills core separately while building domain-specific skill trees on top.

## How It Works

### Routing Flow

```
User input --> /meta <subcommand>
  --> Match to path-* template (L1)
  --> Resolver expands steps --> capability-index.yaml lookup (L2)
  --> Policy engine injects rule-* checks at gate points
  --> Execute with PAUSE points for user confirmation
  --> Produce run-* execution record
```

### Quality Guarantees

Every meta command execution follows these invariants:

1. **PAUSE before action** -- Analysis completes, user confirms direction before changes
2. **Critic loop** -- Quality gate must pass (max 3 iterations)
3. **No regression** -- Verify step must PASS before completion
4. **Knowledge capture** -- Final step captures improvement log

## License

MIT
