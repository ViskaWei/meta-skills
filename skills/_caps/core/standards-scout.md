---
cap_id: cap-extract-standards-scout
verb: extract
object: standards-scout
stage: discover
inputs: [goal-statement, domain-description]
outputs: [standards-pack]
preconditions: ["domain identified, no existing standard in local registry"]
side_effects: ["writes: standards-brief.md, options-landscape.md, playbook.md, checklist.md"]
failure_modes: [no-standards-found, paywalled-sources, domain-too-novel]
leveling: G3-V1-P1-M2
---

# discover-standards-scout

Search for industry-standard SOPs, playbooks, and best practices when requirements are vague but mature practices likely exist. Prevents reinventing the wheel by scouting external standards before building from scratch.

## Artifact Contract

| Field | Value |
|---|---|
| Inputs | Vague requirement or domain description; optional existing local skill/knowledge registry |
| Outputs | **Standards Pack**: standards-brief.md, options-landscape.md, playbook.md, checklist.md, templates/, references.md |
| Done | (1) 2+ industry routes identified and compared, (2) one default recommendation with rationale, (3) executable checklist ready for downstream use, (4) local registry checked for existing coverage |
| Evidence | Web search logs showing sources consulted; comparison table with 2+ options; local dedup scan output |
| Gates | Pre: vague requirement or new domain identified (no existing standard in local registry). Post: Standards Pack exists and enables `decide-adr` or `decide-option-matrix` |
| Next-hop | `decide-adr` (adopt/adapt standard) or `decide-option-matrix` (compare options) or `knowledge-standards-update` (absorb into local standards) |
| Leveling | G3-V1-P1-M2 |

## When to Use

- Requirements are vague but the domain is mature (e.g., "we need CI/CD", "set up monitoring", "do code review")
- Before building a custom process — check if an industry playbook already exists
- When onboarding to a new domain and need to find established best practices
- When standardizing a team process and want to benchmark against industry norms
- **NOT** for novel research problems where no standard exists — use `discover-hypothesis-tree` instead

## Steps

### Step 1: Clarify the Domain & Scope

1. Extract the **domain** (e.g., incident response, CI/CD, data governance, security audit)
2. Extract the **scope** — what level of detail is needed?
   - **Process-level**: how to organize a workflow end-to-end
   - **Checklist-level**: what specific checks/steps to follow
   - **Template-level**: reusable document/config templates
3. Identify **constraints**: team size, tooling, compliance requirements, timeline
4. Produce a 3-5 sentence **scope statement** to guide the search

### Step 2: Check Local Registry (Dedup)

Before searching externally, check if existing skills/knowledge already cover this:

1. Scan `references/lifecycle-registry.md` for overlapping capabilities
2. Check `knowledge/` sub-skills (standards-update, template-library, capture) for existing standards
3. Check `_tools/` families for domain-specific tools already in place

**If 80%+ coverage exists**: Stop. Route to existing skill with a note on what triggered the search.
**If 50-80% coverage**: Note the gap. Proceed with targeted search to fill only the gap.
**If <50% coverage**: Proceed with full standards scouting.

### Step 3: Search Industry Standards (Breadth-First)

**Mandatory: Find at least 2 distinct industry routes before going deep on any one.**

Search strategy (use web search tools):
1. `"<domain> SOP"` or `"<domain> standard operating procedure"`
2. `"<domain> playbook"` or `"<domain> best practices guide"`
3. `"<domain> framework"` or `"<domain> maturity model"`
4. `"<domain> checklist"` (ISO, NIST, OWASP, ITIL, etc. as relevant)
5. Check industry bodies: ISO, IEEE, NIST, CNCF, OWASP, Google SRE, AWS Well-Architected, etc.

For each source found, record:
- **Name**: standard/framework name
- **Authority**: who maintains it (ISO, Google, CNCF, etc.)
- **Scope**: what it covers
- **Maturity**: how widely adopted
- **License/Access**: open, paid, restricted

### Step 4: Synthesize Options Landscape

Produce `options-landscape.md`:

```markdown
# Options Landscape: <Domain>

## Scope Statement
<3-5 sentences from Step 1>

## Options

### Option A: <Standard/Framework Name>
- **Authority**: <who maintains it>
- **Coverage**: <what it covers>
- **Adoption**: <how widely used>
- **Fit**: <how well it matches our constraints>
- **Gaps**: <what it doesn't cover>
- **Cost**: <free/paid/effort to adopt>

### Option B: <Standard/Framework Name>
<same structure>

### Option C: <Standard/Framework Name> (if applicable)
<same structure>

## Comparison Matrix

| Dimension | Option A | Option B | Option C |
|---|---|---|---|
| Coverage | | | |
| Adoption | | | |
| Fit | | | |
| Effort to adopt | | | |
| Gaps | | | |

## Recommendation
**Default**: <recommended option with 1-paragraph rationale>
**Alternative**: <when to choose the other option>
```

### Step 5: Produce Standards Pack

Generate the full Standards Pack in a target directory:

1. **`standards-brief.md`** — 1-page executive summary: what standard, why, key decisions
2. **`options-landscape.md`** — from Step 4
3. **`playbook.md`** — step-by-step procedure adapted from the recommended standard, contextualized for our environment
4. **`checklist.md`** — actionable checklist (checkbox format) derived from the playbook, usable as a gate
5. **`templates/`** — any reusable templates referenced by the playbook (config files, document templates, etc.)
6. **`references.md`** — all sources with URLs, access dates, and relevance notes

### Step 6: Store for Reuse

1. If the Standards Pack fills a gap in the local registry, recommend creating a `knowledge-standards-update` or `knowledge-template-library` entry
2. Record the pack location so future searches can find it
3. Link from the relevant `_tools/` family or lifecycle stage if applicable

## Domain Tool References

| Tool | Path | Purpose |
|---|---|---|
| research-lookup | `_tools/research/lookup.md` | Web search for standards and frameworks |
| literature-review | `_tools/paper/sub/literature-review.md` | Systematic review of standard documents |
| knowledge-standards-update | `_caps/core/standards-update.md` | Absorb findings into local standards |
| knowledge-template-library | `_caps/core/template-library.md` | Store reusable templates from pack |

## Edge Cases

- **No industry standard exists**: Document the absence. Switch to `discover-hypothesis-tree` for novel approach design. Produce a minimal brief explaining why custom design is justified.
- **Too many standards**: Cap at 3-4 options in the landscape. Group similar ones and pick the most representative.
- **Standard is paywalled**: Note access restrictions. Summarize from secondary sources. Flag for procurement if adoption is recommended.
- **Standard is too broad**: Extract only the relevant subset. Note which sections apply and which are out of scope.
- **Rapidly evolving domain**: Flag volatility. Recommend review cadence (e.g., re-scout quarterly).

## Anti-Patterns

- **Depth before breadth**: Diving deep into one standard before surveying the landscape. Always find 2+ routes first.
- **Copy without context**: Adopting a standard verbatim without adapting to local constraints. The playbook must be contextualized.
- **Ignoring local registry**: Scouting externally without checking what already exists locally. Always do Step 2 first.
- **Standards hoarding**: Collecting standards without producing an actionable checklist. The pack must be executable.
