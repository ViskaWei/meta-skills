# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

# meta-skills -- Project Instructions

## Build & Validation Commands

```bash
bash tools/setup.sh                              # Deploy meta-skills to ~/.claude/skills/
bash tools/build_capability_index.sh              # Regenerate capability-index.yaml from block files
bash tools/validate_contracts.sh                  # Validate all YAML frontmatter contracts
bash tools/validate_contracts.sh --file <path>    # Validate a single capability file
bash tools/validate_aliases.sh                    # Validate trigger word aliases
```

## Architecture: 3-Layer Skill System

This repo implements an **8-stage lifecycle skill system** with a 3-layer invocation architecture. Every interaction MUST follow this architecture.

### The 3 Layers

```
L0  Entry Commands (4)       -> /meta, /build, /research, /improve
L1  Path Templates (8)       -> Multi-step recipes (_paths/*.yaml)
L2  Atomic Capabilities (29) -> Building blocks (_stages/<stage>/sub/*.md)
Cross-cutting: Policies (9)  -> Quality gates (_policies/rule-*.yaml)
```

### Directory Layout

```
skills/
  meta/                    <- L0: System maintenance (auto-discovered)
  build/                   <- L0: Create new skills (auto-discovered)
  research/                <- L0: Research pipeline (auto-discovered)
  improve/                 <- L0: Improve artifacts (auto-discovered)
  _stages/                 <- L2: 8 lifecycle stages (HIDDEN from auto-discovery)
    discover/ decide/ build/ verify/ deliver/ operate/ review/ knowledge/
  _paths/                  <- L1: Path template YAML files
  _policies/               <- Cross-cutting quality rules
  _resolver/               <- Resolver + governance files
  _tools/                  <- Domain tool families
  _standards/              <- Governance tools
skills-registry.yaml       <- Master registry
```

**Key rule**: Directories starting with `_` are HIDDEN from Claude Code auto-discovery. 4 L0 commands (meta, build, research, improve) are auto-discovered.

---

## Routing Flow

```
User input -> L0 command match -> Select path-* template (L1)
  -> Resolver expands steps -> capability-index.yaml lookup (L2)
  -> Policy engine injects rule-* checks -> Execute -> Produce run-* record
```

---

## Naming Convention (MANDATORY)

### Capabilities
```
cap-<verb>-<object>
```
- **verb**: MUST be from the 18 controlled verbs (see `_resolver/verbs.yaml`):
  `intake, extract, map, compare, decide, plan, scaffold, build, render, assemble, check, package, publish, track, triage, review, capture, sync`
- **object**: MUST be from `_resolver/objects.yaml`
- Stage is metadata in capability-index, not part of the ID

### Path Templates
```
path-<domain>-<outcome>
```

### Policies
```
rule-<scope>-<intent>
```

### Execution Records
```
run-<path-id>-<context>-<yyyymmdd>-<seq>
```

### Lint Rules
1. kebab-case only (no camelCase, no underscores)
2. 3-6 tokens including prefix
3. Verb from controlled vocabulary only (18 verbs)
4. Object from governed list only
5. No implementation details in names
6. Correct prefix for layer: `cap-` / `path-` / `rule-` / `run-`

---

## Creating New Skills

Follow this decision tree:

| Need | Create | Placement |
|---|---|---|
| Multi-stage workflow | `path-<domain>-<outcome>.yaml` | `_paths/` |
| Quality/verification | `rule-<scope>-<intent>.yaml` | `_policies/` |
| Cross-stage reusable tool | `<name>.md` | `_tools/<family>/` |
| Single-stage atomic capability | `<action>.md` | `_stages/<stage>/sub/` |

### Registration Checklist
After creating any skill, you MUST:
1. Update `skills-registry.yaml` (cap_id, input/output_types, policies, leveling)
2. Update `_resolver/capability-index.yaml` (or run `tools/build_capability_index.sh`)
3. Update L0 SKILL.md routing table (if adding new subcommands)
4. Run `bash tools/setup.sh` to deploy

---

## Leveling System

Every capability gets a `Gx-Vy-Pz-Mk` tag:
- **G**: Generality (G0=ephemeral -> G3=core cross-domain)
- **V**: Volatility (V0=stable -> V3=fast-changing)
- **P**: Proficiency (P0=draft -> P3=hardened)
- **M**: Maturity (M0=stub -> M4=observed)

---

## Key Files Reference

| File | Purpose |
|---|---|
| `skills-registry.yaml` | Master registry (stages, capabilities, paths, policies) |
| `skills/_resolver/capability-index.yaml` | cap-* to block file mapping |
| `skills/_resolver/verbs.yaml` | 18 canonical verbs + aliases |
| `skills/_resolver/objects.yaml` | Canonical objects + domains |
| `skills/_resolver/artifact-types.yaml` | Artifact type definitions |
| `skills/_resolver/resolver.md` | Resolution algorithm |
| `skills/meta/SKILL.md` | L0 system command + routing table |
| `skills/build/SKILL.md` | L0 build command |
| `skills/research/SKILL.md` | L0 research command |
| `skills/improve/SKILL.md` | L0 improve command |
| `tools/setup.sh` | Deploy to ~/.claude/skills/ |
| `tools/build_capability_index.sh` | Regenerate capability index |
| `tools/validate_contracts.sh` | Validate YAML frontmatter contracts |
| `tools/validate_aliases.sh` | Validate trigger word aliases |

---

## Gate Chain

```
Discover --[brief/hypothesis]--> Decide --[ADR/roadmap]--> Build
    --[artifact]--> Verify --[evidence PASS]--> Deliver
    --[package]--> Operate    Review --[retro]--> Knowledge
```

Policies (`rule-*`) auto-inject at gate points by artifact output type.

---

## Deployment

```bash
bash tools/setup.sh    # Deploys to ~/.claude/skills/
```

This copies:
- 4 L0 commands (meta, build, research, improve) -> top-level (auto-discovered)
- 8 lifecycle stages -> `_stages/` (hidden)
- `_paths/`, `_policies/`, `_resolver/`, `_standards/` -> hidden directories
- Symlinks `_tools/` and `skills-registry.yaml`

**Important**: Claude Code cannot discover SKILL.md files through symlinks -- `setup.sh` uses `cp -rL` (dereference copy) for skill directories. Only `_tools/` and `skills-registry.yaml` remain as symlinks.

---

## DO NOT

- Create skills outside the 3-layer architecture
- Use verbs not in the controlled vocabulary
- Use objects not in `_resolver/objects.yaml`
- Put atomic capabilities at top-level (they go in `_stages/<stage>/sub/`)
- Manually wire quality checks (use `rule-*` policies instead)
- Modify `capability-index.yaml` manually without updating `skills-registry.yaml`
- Deploy without running `tools/setup.sh`
