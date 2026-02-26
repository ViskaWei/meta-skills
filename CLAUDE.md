# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

# meta-skills -- Project Instructions

## Build & Validation Commands

```bash
bash tools/setup.sh                              # Deploy meta-skills to ~/.claude/skills/
bash tools/build_capability_catalog.sh            # Regenerate capability-catalog.yaml from block files
bash tools/validate_contracts.sh                  # Validate all YAML frontmatter contracts
bash tools/validate_contracts.sh --file <path>    # Validate a single capability file
bash tools/validate_aliases.sh                    # Validate trigger word aliases
```

## Architecture: FDPS v4 — Flat-Domain Progressive Skill

This repo implements **FDPS v4** (Flat-Domain Progressive Skill Architecture) with a 3-layer invocation system. Based on Anthropic Tool Search, ToolGen (ICLR 2025), and industry consensus.

**Core principles**: Flat over hierarchical (ToolGen: 55% vs 45.5%), progressive disclosure (Anthropic TST: -85% tokens), domain-based organization (7/7 frameworks consensus).

### The 3 Layers

```
L0  Entry Commands (4)       -> /meta, /build, /research, /improve
L1  Path Templates (8)       -> Multi-step recipes (_paths/*.yaml)
L2  Atomic Capabilities (29) -> Building blocks (_caps/core/*.md)
Cross-cutting: Policies (10) -> Quality gates (_policies/rule-*.yaml)
```

### Directory Layout

```
skills/
  meta/                    <- L0: System maintenance (auto-discovered)
  build/                   <- L0: Create new skills (auto-discovered)
  research/                <- L0: Research pipeline (auto-discovered)
  improve/                 <- L0: Improve artifacts (auto-discovered)
  _caps/                   <- L2: Atomic capabilities (HIDDEN from auto-discovery)
    core/                  <- 29 core capabilities (all public caps)
  _paths/                  <- L1: Path template YAML files
  _policies/               <- Cross-cutting quality rules
  _resolver/               <- Resolver + governance files
  _tools/                  <- Domain tool families
  _standards/              <- Governance tools
skills-registry.yaml       <- v4 master registry (catalog_file reference)
```

**Key rule**: Directories starting with `_` are HIDDEN from Claude Code auto-discovery. 4 L0 commands (meta, build, research, improve) are auto-discovered.

---

## Routing Flow

```
User input -> L0 command match -> Domain filter (narrows to core)
  -> Catalog multi-signal search (trigger 0.30 + output_type 0.25 + input_chain 0.20 + domain 0.15 + semantic 0.10)
  -> Load selected block files -> Policy injection -> Execute -> Produce run-* record
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
- Stage and domain are metadata in capability-catalog.yaml, not part of the ID

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
| Atomic capability | `<name>.md` with frontmatter | `_caps/core/` |

### Registration Checklist
After creating any capability, you MUST:
1. Update `_resolver/capability-catalog.yaml` (or run `tools/build_capability_catalog.sh`)
2. Update `skills-registry.yaml` if adding new policies or paths
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
| `skills-registry.yaml` | v4 master registry (catalog ref, tools, policies, paths, L0 commands) |
| `skills/_resolver/capability-catalog.yaml` | **Single source of truth** — 29 core caps |
| `skills/_resolver/verbs.yaml` | 18 canonical verbs + aliases |
| `skills/_resolver/objects.yaml` | Canonical objects + domains |
| `skills/_resolver/artifact-types.yaml` | Artifact type definitions |
| `skills/_resolver/resolver.md` | v4 resolution algorithm (multi-signal search) |
| `skills/meta/SKILL.md` | L0 system command + routing table |
| `skills/build/SKILL.md` | L0 build command |
| `skills/research/SKILL.md` | L0 research command |
| `skills/improve/SKILL.md` | L0 improve command |
| `tools/setup.sh` | Deploy to ~/.claude/skills/ |
| `tools/build_capability_catalog.sh` | Regenerate capability catalog |
| `tools/validate_contracts.sh` | Validate YAML frontmatter contracts |
| `tools/validate_aliases.sh` | Validate trigger word aliases |

---

## Token Budget (Progressive Disclosure)

| Tier | What | When loaded | Tokens |
|---|---|---|---|
| T0 | L0 SKILL.md (4 commands) | Always in context | ~1,200 |
| T1 | capability-catalog.yaml | At routing time | ~1,000 (29 × 35) |
| T2 | Block file (capability) | On selection | ~300-500 per block |
| T3 | Reference docs | On explicit demand | Variable |

---

## Gate Chain

```
Discover --[brief/hypothesis]--> Decide --[ADR/roadmap]--> Build
    --[artifact]--> Verify --[evidence PASS]--> Deliver
    --[package]--> Operate    Review --[retro]--> Knowledge
```

Lifecycle preserved as `stage:` metadata tags in catalog entries.
Policies (`rule-*`) auto-inject at gate points by artifact output type.

---

## Deployment

```bash
bash tools/setup.sh    # Deploys to ~/.claude/skills/
```

This copies:
- 4 L0 commands (meta, build, research, improve) -> top-level (auto-discovered)
- `_caps/core/` -> `_caps/core/` (hidden, 29 capabilities)
- `_paths/`, `_policies/`, `_resolver/`, `_standards/` -> hidden directories
- Symlinks `_tools/` and `skills-registry.yaml`

**Important**: Claude Code cannot discover SKILL.md files through symlinks -- `setup.sh` uses `cp -rL` (dereference copy) for skill directories. Only `_tools/` and `skills-registry.yaml` remain as symlinks.

---

## DO NOT

- Create capabilities outside `_caps/core/` (not at top-level, not in old `_stages/`)
- Use verbs not in the controlled vocabulary
- Use objects not in `_resolver/objects.yaml`
- Manually edit `capability-catalog.yaml` without running `build_capability_catalog.sh`
- Deploy without running `tools/setup.sh`
