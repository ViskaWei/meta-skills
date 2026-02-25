---
name: skill-creator-standard
description: "3-Layer Architecture standard for creating skills. Enforces cap/path/rule naming, controlled verb vocabulary, artifact contracts, path templates, and policy-as-code. Extends the base skill-creator with Layer A (cap-*), Layer B (path-*), and cross-cutting (rule-*) support. Triggers: 'create skill', 'new skill', 'skill standard', 'naming check', 'lint skill'."
---

# Skill Creator Standard — 3-Layer Architecture

在 skill-creator 基础上，增加 **3-Layer Architecture** (step / path / rule) 的标准和治理层。

本 skill 确保所有新建的 skill 符合 3-Layer 命名规范、Artifact Contract、Path Template 配方化、Policy 质检注入。

---

## 3-Layer Architecture

```
Layer C: Workflow Execution (运行日志)
         run-<path-id>-<context>-<yyyymmdd>-<seq>

Layer B: Path Templates (配方库, ~40 templates)
         path-<domain>-<outcome>
         存放: _paths/*.yaml

Layer A: Capabilities (能力积木, 63)
         cap-<verb>-<object>
         verb: verbs.yaml (18个); object: objects.yaml (56个)
         存放: _stages/<stage>/sub/*.md + _tools/<family>/*.md

Cross-cutting: Policies (质检规则)
         rule-<scope>-<intent>
         存放: _policies/*.yaml
```

**A = 怎么做 (能力); B = 怎么编排 (配方); C = 这次跑了什么 (日志)**

完整中文文档: `_resolver/3-layer-architecture.md`

---

## 命名规范

### Layer A: Capabilities (能力)
```
cap-<verb>-<object>
```

**18 个受控动词** (`_resolver/verbs.yaml`):
`intake, extract, map, compare, decide, plan, scaffold, build, render, assemble, check, package, publish, track, triage, review, capture, sync`

**61 个受控对象** (`_resolver/objects.yaml`)

示例:
- `cap-extract-brief`
- `cap-render-eval-harness`
- `cap-assemble-evidence-bundle`

### Layer B: Path Templates (配方)
```
path-<domain>-<outcome>
```

**9 个 domain**: research, paper, repo, webui, docs, data, ops, standards, general

示例:
- `path-paper-15min-brief`
- `path-research-hypothesis-to-evidence`
- `path-webui-build-verify-release`

### Cross-cutting: Policies (质检规则)
```
rule-<scope>-<intent>
```

示例:
- `rule-quality-deliverable-minimum`
- `rule-webui-visual-regression`
- `rule-research-reproducibility`

### Layer C: Workflow Executions (运行记录)
```
run-<path-id>-<context>-<yyyymmdd>-<seq>
```

---

## Lint 规则

1. **kebab-case only** — 不允许 camelCase 或下划线
2. **3-6 tokens** — 含前缀在内
3. **动词必须来自受控表** — 18 个标准动词 (`_resolver/verbs.yaml`)
4. **对象必须来自受控表** — 61 个标准对象 (`_resolver/objects.yaml`)
5. **不含实现细节** — 用 `cap-render-flowchart` 不用 `cap-render-d2-flowchart-svg`
6. **前缀对应 Layer** — `cap-` / `path-` / `rule-` / `run-`

详见 `references/naming-convention.md`

---

## 输入格式

### 调用语法

```
/skill-creator-standard L0 /<name>              → 创建 L0 入口技能
/skill-creator-standard cap <verb> <object>      → 创建 Layer A 原子能力
/skill-creator-standard path <domain> <outcome>  → 创建 Layer B 路径模板
/skill-creator-standard rule <scope> <intent>    → 创建 cross-cutting 质检规则
/skill-creator-standard tool <family> <name>     → 创建域工具
/skill-creator-standard fix <target>             → 修复已有 skill 到达标
/skill-creator-standard lint <target>            → 仅检查命名/合规
```

**关键词解析**:
- `L0` / `entry` / `skill` → 顶层入口技能
- `cap` / `A` / `能力` → Layer A 原子能力
- `path` / `B` / `配方` → Layer B 路径模板
- `rule` / `policy` / `规则` → Cross-cutting 质检规则
- `tool` → 域工具
- `fix` → 修复已有
- `lint` / `check` → 仅检查

---

## 创建流程

### Step 0: Intake & Classify

确定 Object Type:

| Object Type | Layer | Naming | Placement |
|---|---|---|---|
| **入口技能** | **L0** | `<name>/SKILL.md` (YAML frontmatter: `name` + `description`) | `skills/<name>/` (顶层, Claude Code 自动发现) |
| 原子能力 | A | `cap-<verb>-<object>` | `_stages/<stage>/sub/<action>.md` |
| 域工具 | A | 无前缀 | `_tools/<family>/<name>.md` |
| 路径模板 | B | `path-<domain>-<outcome>` | `_paths/<id>.yaml` |
| 质检规则 | cross | `rule-<scope>-<intent>` | `_policies/<id>.yaml` |

### L0 入口技能结构

L0 是用户直接调用的顶层入口 (`/read`, `/pdf`, `/workflow` 等)。

```
skills/<name>/
  SKILL.md          ← 必须有 YAML frontmatter (name + description)
  [references/]     ← 可选: 参考文档
  [sub/]            ← 可选: 子模块
```

**SKILL.md frontmatter**:
```yaml
---
name: <name>
description: "<功能描述>. Triggers: '<alias1>', '<alias2>'."
---
```

**L0 注册清单**:
1. 更新 `workflow/SKILL.md` 路由表 (添加触发词)
2. 更新 `skills-registry.yaml`
3. 运行 `bash tools/setup.sh` 部署
4. 验证: 新 Claude Code 窗口能通过 `/<name>` 调用

### Step 1: Dedup Check

扫描所有注册表:
1. `references/lifecycle-registry.md` — 148+ 能力
2. `_paths/CATALOG.md` — 40+ 模板
3. `_policies/` — 已有规则
4. `skills-registry.yaml` v2.0 — 完整索引

| 重叠度 | 行动 |
|---|---|
| 80%+ | 直接复用 |
| 50-80% | 扩展现有 |
| 可组合 | 创建 `path-*` 配方 |
| <50% | 创建新 skill |

### Step 2: Naming Lint

运行命名检查:
- [ ] kebab-case
- [ ] 3-6 tokens
- [ ] 受控动词
- [ ] 正确 stage/domain
- [ ] 无实现细节
- [ ] 正确前缀

### Step 3: Write Artifact Contract

**所有 skill 必须声明 Artifact Contract**。推荐使用 YAML frontmatter（v2.1 cap contract）:

```yaml
---
cap_id: cap-<verb>-<object>
verb: <verb>
object: <object>
stage: <stage>
inputs: [<artifact-type>, ...]
outputs: [<artifact-type>, ...]
preconditions: [<condition>, ...]
side_effects: ["writes: <path>"]
failure_modes: [<mode>, ...]
leveling: Gx-Vy-Pz-Mk
---
```

产物类型必须在 `_resolver/artifact-types.yaml` 中注册（64 种）。
动词必须在 `_resolver/verbs.yaml` 中注册（18 个规范动词）。
对象必须在 `_resolver/objects.yaml` 中注册（61 个规范对象）。
验证: `bash tools/validate_contracts.sh`

也支持传统 Markdown 表格形式:

```markdown
| Field | Value |
|---|---|
| cap-ID | cap-<verb>-<object> |
| Inputs | <来源> |
| input_types | <类型化输入> |
| Outputs | <产物> |
| output_types | <类型化输出> |
| Done | <可衡量的完成标准> |
| Evidence | <正确性证明> |
| Gates | Pre: <前置>. Post: <后置> |
| Policies | <适用的 rule-* ID> |
| Next-hop | <下游 skill/stage> |
```

### Step 4: Write the Skill

按类型选择模板:
- **L0 入口 skill**: 目录 + SKILL.md (frontmatter: name, description)
- **原子 skill**: 见 `references/skill-templates.md`
- **Path Template**: 见 `references/path-template.md`
- **Policy**: 见 `references/policy-template.md`

### Step 5: Assign Leveling

`Gx-Vy-Pz-Mk`:
- G: 通用性 (G0 临时 → G3 核心)
- V: 变化频率 (V0 稳定 → V3 频繁)
- P: 可靠度 (P0 草稿 → P3 强化)
- M: 成熟度 (M0 存根 → M4 可观测)

### Step 6: Register

1. 更新 `references/lifecycle-registry.md`
2. 更新父 `<stage>/SKILL.md` 子表
3. 更新 `workflow/SKILL.md` 路由 (如有别名)
4. 更新 `skills-registry.yaml` v3 (cap_id, input/output_types, policies, leveling)
5. 如 path-*: 添加到 `_paths/CATALOG.md`
6. 如 rule-*: 添加到 registry `policies:` 部分
7. 同步到 repo 并 commit

### Step 7: Verify Checklist

- [ ] Artifact Contract 完整
- [ ] 不是孤立节点 (可从入口到达)
- [ ] 去重清洁 (<70%)
- [ ] 放置正确
- [ ] 命名 lint 通过
- [ ] Frontmatter 存在 (如顶层)
- [ ] 父节点已更新
- [ ] Registry v3 已更新
- [ ] Leveling 已分配
- [ ] Path Template Catalog 已更新 (如 path-*)

---

## 门禁链

| Gate | Rule | Enforced by |
|---|---|---|
| Discover → Decide | Brief or Problem Tree | `decide/SKILL.md` |
| Decide → Build | ADR or Roadmap MVP | `build/SKILL.md` |
| Build → Verify | Runnable artifact | `verify/SKILL.md` |
| Verify → Deliver | Evidence Bundle (PASS) | `deliver/SKILL.md` |
| Deliver → Operate | Package + Handoff | `operate/SKILL.md` |

Policies (`rule-*`) 按 artifact 类型在门禁点自动注入。

---

## 已有资产

### 6 个 Policy
| ID | 触发 | 用途 |
|---|---|---|
| `rule-quality-deliverable-minimum` | `*` | 基线质量 |
| `rule-webui-visual-regression` | web-page | 视觉回归 |
| `rule-webui-dev-server-verify` | web-page | URL 存活验收 |
| `rule-paper-structure-integrity` | paper-draft | 论文结构 |
| `rule-research-reproducibility` | model-checkpoint | 可复现性 |
| `rule-standards-source-trust` | standards-pack | 来源可信 |

### 8 个 Path Template (已实现)
| ID | Domain | 来源 |
|---|---|---|
| `path-paper-15min-brief` | paper | 速读 |
| `path-research-hypothesis-to-evidence` | research | 科研闭环 |
| `path-paper-draft-peer-review-loop` | paper | 写作+审稿 |
| `path-webui-build-verify-release` | webui | Web 发布 |
| `path-standards-scout-and-validate` | standards | 标准探查 |
| `path-repo-onboarding-map` | repo | 入门地图 |
| `path-research-ablation-study` | research | 消融实验 |
| `path-doc-rfc-to-adr` | docs | RFC→ADR |

> 完整 40 模板路线图: `_paths/CATALOG.md`

---

## References

- `references/naming-convention.md` — 命名规则 + lint 规则
- `references/path-template.md` — Path Template YAML schema
- `references/policy-template.md` — Policy YAML schema
- `references/path-catalog.md` — 40 模板路线图 (去重用)
- `_resolver/3-layer-architecture.md` — 完整中文文档
