# 三层技能架构：Step / Path / Run / Rule

> 版本 3.0 — 2026-02-23
> 作者：Viska Wei

---

## 一、为什么需要三层架构？

原来的技能系统有 **149 个能力**，组织在 2 层：原子 sub-skill（8 大阶段）+ 手写编排器。
三个结构性问题：

| 问题 | 表现 |
|---|---|
| **编排器爆炸** | 每个新的多阶段工作流都要手写 100-170 行编排器。目前只有 3 个，需求在增长 |
| **验证手动接线** | 每个编排器各写一套验证步骤，重复同样的模式（证据包+门禁+类型检查） |
| **无解析器** | 路由完全靠硬编码触发词表。新增能力要手动更新 2-3 个查找表 |

**解决方案**：三层 + 跨切面策略，用行业标准术语（Path Templates、Policy-as-Code）。

---

## 二、架构总览

```
Layer C: 执行记录 (Workflow Execution)
         run-<path-id>-<context>-<yyyymmdd>-<seq>
         存储位置: $PROJECT/runs/<run-id>/

Layer B: 路径模板 (Path Templates)               ← "路径模板库"
         path-<domain>-<outcome>
         存储位置: _paths/*.yaml
         = 阶段骨架 + 能力需求 + 门禁点 + 默认策略

Layer A: 原子能力 (Capabilities)                ← "积木"
         cap-<verb>-<object>
         verb: verbs.yaml (18个); object: objects.yaml (61个)
         存储位置: _stages/<stage>/sub/*.md + _tools/<family>/*.md

跨切面: 策略 (Policies)
         rule-<scope>-<intent>
         存储位置: _policies/*.yaml
         在门禁点自动注入，基于输出物类型
```

**核心分工**：

| 层 | 管什么 | 类比 |
|---|---|---|
| **A — cap** | 怎么做（能力） | 积木块 |
| **B — path** | 怎么串（定义） | 路径模板 |
| **C — run** | 这次跑怎样（执行记录） | 实验日志 |
| **rule** | 必须满足什么（策略） | 质检规则 |

---

## 三、命名规范

所有命名：**kebab-case**，**3-6 token**，不含实现细节。

### 3.1 Layer A：能力 ID

#### 3.1.1 能力 ID（cap-）

**格式**：`cap-<verb>-<object>`

Stage 不再作为 ID 的一部分，而是作为元数据标签。这解决了：
- Stage 在 ID 和目录路径中的冗余
- 跨阶段复用需要重复定义的问题
- 生命周期调整时的大规模重命名风险

| 字段 | 说明 | 可选值 |
|---|---|---|
| `verb` | 来自受控词汇表（见 §3.5） | 18 个规范动词 (`verbs.yaml`) |
| `object` | 操作的产物或概念 | 61 个规范对象 (`objects.yaml`) |

**示例**：
```
cap-extract-requirements     (stage: discover)
cap-decide-adr              (stage: decide)
cap-scaffold-experiment      (stage: build)
cap-assemble-evidence-bundle (stage: verify)
cap-package-output           (stage: deliver)
cap-capture-card             (stage: knowledge)
```

Stage 信息来源（优先级）：
1. Cap contract frontmatter 中的 `stage:` 字段
2. `capability-index.yaml` 中的 `stage:` 元数据
3. 文件所在目录路径 `_stages/<stage>/sub/`

#### 3.1.2 治理文件

- **verbs.yaml**: 18 个规范动词 + 别名（用于 L0 输入解析）
- **objects.yaml**: 61 个规范对象 + 领域标签
- **artifact-types.yaml**: 64 种产物类型（用于契约验证）

新增 verb 或 object 需要先注册，防止命名漂移。

### 3.2 Layer B：路径模板 ID（path-）

**格式**：`path-<domain>-<outcome>`

| 字段 | 说明 | 可选值 |
|---|---|---|
| `domain` | 领域 | `research / paper / repo / webui / docs / data / ops / standards / general` |
| `outcome` | 连字符描述最终结果 | 自由，但要 ≤4 个词 |

**示例**：
```
path-paper-15min-brief
path-research-hypothesis-to-evidence
path-webui-build-verify-release
path-docs-rfc-to-adr
```

### 3.3 Layer C：执行记录 ID（run-）

**格式**：`run-<path-id>-<context>-<yyyymmdd>-<seq>`

| 字段 | 说明 |
|---|---|
| `path-id` | 所用的路径模板 ID |
| `context` | 本次执行的主题（kebab-case，≤30 字符） |
| `yyyymmdd` | 执行日期 |
| `seq` | 当天序号（01, 02, ...） |

**示例**：
```
run-path-paper-15min-brief-arxiv-2506-20430-20260223-01
run-path-research-hypothesis-to-evidence-ips-nn-20260223-01
```

### 3.4 跨切面：策略 ID（rule-）

**格式**：`rule-<scope>-<intent>`

| 字段 | 说明 | 可选值 |
|---|---|---|
| `scope` | 适用范围 | `quality / webui / paper / research / standards / ops` |
| `intent` | 策略意图 | 自由描述 |

**示例**：
```
rule-quality-deliverable-minimum    — 所有交付物的最低质量基线
rule-webui-visual-regression        — Web/UI 视觉回归检查
rule-paper-structure-integrity      — 论文结构完整性
rule-research-reproducibility       — 实验可复现性
rule-standards-source-trust         — 标准来源可信度
```

### 3.5 受控动词表

只允许以下 18 个规范动词出现在 `cap-` ID 中。
完整定义、别名、和语义边界见 `_resolver/verbs.yaml`。

| 动词 | 含义 | 典型阶段 | 易混淆辨析 |
|---|---|---|---|
| `intake` | 接收并验证输入 | discover | |
| `extract` | 从非结构化来源提取结构化信息 | discover | |
| `map` | 创建可视化/结构化表示 | discover, build | map=结构分析, scaffold=可运行骨架 |
| `compare` | 并列评估选项 | decide | |
| `decide` | 记录决策及理由 | decide, verify, review | |
| `plan` | 创建前瞻性计划 | decide | |
| `scaffold` | 创建最小可运行结构 | build | scaffold=骨架, build=完整实现 |
| `build` | 实现完整产物 | build | |
| `render` | 生成可视化/格式化输出 | build | |
| `assemble` | 将多个输入组合为一个产物 | verify | assemble=内部打包, package=交付就绪 |
| `check` | 验证某个质量维度 | verify | check=跑检查, decide=做判定 |
| `package` | 打包交付 | deliver | package=交付就绪, publish=外部发布 |
| `publish` | 对外发布 | deliver | |
| `track` | 记录运行时指标和事件 | operate | |
| `triage` | 分类和优先排序事件 | operate | |
| `review` | 用结构化标准评估质量 | review | |
| `capture` | 创建可复用知识产物 | knowledge | |
| `sync` | 更新已有知识库 | knowledge | |

**已合并为别名的动词**：
- `decompose` → `map` 的别名（结构分析类）
- `define` → `build` 的别名（产物创建类）
- `improve` → `plan` 的别名（前瞻性改进类）

### 3.6 Lint 规则

1. **Token 数量**：3-6 个（以 `-` 分隔），不含前缀
2. **仅 kebab-case**：无 camelCase、无下划线、无空格
3. **无实现细节**：不含工具名、文件扩展名、版本号
4. **动词必须来自受控词汇表**
5. **对象必须来自受控对象表**（`objects.yaml`）
6. **领域必须来自领域词汇表**（path- ID）

---

## 四、Layer A — 原子能力（cap-）

### 4.1 什么是原子能力

原子能力是系统中最小的可执行单元。每个能力：
- 属于且仅属于一个生命周期阶段
- 有明确的 Artifact Contract（输入/输出/完成条件/证据/门禁/下游）
- 有 Leveling 标签（G/V/P/M）

### 4.2 能力索引

所有能力注册在 `_resolver/capability-index.yaml` 中，使用 `cap-*` ID：

```yaml
capabilities:
  cap-intake-brief:
    - { block: "_stages/discover/sub/intake.md", leveling: "G3-V0-P2-M3", stage: discover, cap_contract: true }

  # 多实现能力
  cap-map-hypothesis-tree:  # multi-provider
    - { block: "_stages/discover/sub/hypothesis-tree.md", leveling: "G3-V1-P2-M3", stage: discover }
    - { block: "_tools/paper/sub/hypothesis-generation.md", leveling: "G2-V1-P1-M2", stage: discover, type: tool-adapter }
```

当一个能力有多个实现块时，解析器按 leveling 排序选择最佳的。
`type` 字段区分 `stage-native`（阶段原生实现）和 `tool-adapter`（域工具适配器）。

### 4.2a Cap 契约

高频能力文件的 YAML frontmatter 声明了机器可读的契约：

```yaml
---
cap_id: cap-intake-brief
verb: intake
object: brief
stage: discover
inputs: [url, file-path, goal-statement]
outputs: [intake-manifest]
preconditions: []
side_effects: ["writes: artifacts/intake-manifest.md"]
failure_modes: [source-inaccessible, ambiguous-goal]
leveling: G3-V0-P2-M3
---
```

契约字段说明：
| 字段 | 用途 |
|---|---|
| `cap_id` | 规范能力 ID |
| `verb` / `object` | 拆分的动词和宾语 |
| `stage` | 默认所属阶段 |
| `inputs` / `outputs` | 类型化的输入输出（见 `artifact-types.yaml`） |
| `preconditions` | 前置条件 |
| `side_effects` | 副作用（写入哪些文件） |
| `failure_modes` | 已知失败模式 |
| `leveling` | Gx-Vy-Pz-Mk 标签 |

目前 Top-20 高频能力已加上契约。所有类型名在 `_resolver/artifact-types.yaml` 注册（64 种）。

验证工具：`bash tools/validate_contracts.sh`

### 4.3 Leveling 系统

每个能力有 4 轴标签：`Gx-Vy-Pz-Mk`

| 轴 | 含义 | 等级 |
|---|---|---|
| **G（通用性）** | 谁用？ | G3=跨项目跨域, G2=跨项目特定域, G1=单项目, G0=临时 |
| **V（易变性）** | 多久变一次？ | V0=稳定, V1=慢, V2=中, V3=快 |
| **P（熟练度）** | 有多可靠？ | P0=草稿, P1=可用, P2=可靠, P3=硬化 |
| **M（成熟度）** | 多完整？ | M0=桩, M1=规格, M2=已实现, M3=已门禁, M4=已观测 |

**示例**：`G3-V1-P2-M3` = 核心能力、慢变、可靠、已门禁

### 4.4 当前能力统计

| 阶段 | 数量 | 核心能力 |
|---|---|---|
| discover | 10 | brief, hypothesis-tree, metrics-contract, problem-tree, literature-skim, standards-scout |
| decide | 6 | adr, option-matrix, roadmap-mvp, experiment-design, resource-budget |
| build | 11 | scaffold, paper-outline, paper-draft, data-pipeline, model-loss, eval-harness |
| verify | 10 | quality-gate, evidence-bundle, metric-sanity, reproducibility, paper-structure |
| deliver | 4 | package, handoff-guide, release-notes, demo-script |
| operate | 5 | experiment-tracker, runbook, observability, incident-triage, cost-performance |
| review | 9 | exp-retro, decision-gate, paper-peer, paper-editorial, design-principles-extract |
| knowledge | 6 | capture, hub-sync, index, template-library, standards-update, learning-loop |
| **总计** | **61** | |

加上 12 个域工具家族（43+ 工具），总能力 **100+**。

---

## 五、Layer B — 路径模板（path-）

### 5.1 什么是路径模板

路径模板是预定义的多阶段工作流模板。它不包含实现代码，只定义：
- **阶段骨架**：哪些步骤，什么顺序
- **能力需求**：每步需要哪些 `cap-*` 能力
- **门禁点**：步骤之间的依赖关系
- **分支条件**：何时跳转或循环
- **策略绑定**：必须/推荐注入哪些 `rule-*` 策略

### 5.2 YAML 结构

```yaml
id: path-<domain>-<outcome>
name: "人类可读名称"
domain: <domain>
version: 1
outcome: "这个路径产出什么"

steps:
  - id: <step-name>
    stage: <lifecycle-stage>
    capabilities_needed: [cap-<verb>-<object>]
    output_type: <artifact-type>
    gate_requires: [<prior-output-type>]
    description: "这步做什么"

branches:
  - from: <step-id>
    condition: "何时分支"
    goto: <step-id>           # 跳转到本模板内某步
    goto_path: path-<id>      # 或跳转到另一个路径模板

applicable_policies:
  required: [rule-quality-deliverable-minimum]
  recommended: [rule-research-reproducibility]

stop_rules:
  consecutive_failures: 3
  budget_exhausted: "walk to decision-gate"
```

### 5.3 已实现的 8 个种子路径模板

| ID | 领域 | 来源 | 阶段链 |
|---|---|---|---|
| `path-paper-15min-brief` | paper | 迁移自 paper-15m.md | D→D→Del→K (线性) |
| `path-research-hypothesis-to-evidence` | research | 迁移自 research-loop.md | D→D→B→O→V→R→K (循环) |
| `path-paper-draft-peer-review-loop` | paper | 迁移自 paper-peerreview.md | D→D→B→V+R 循环→Del→K |
| `path-webui-build-verify-release` | webui | 新建 | B→V→Del |
| `path-standards-scout-and-validate` | standards | 基于 standards-scout.md | D→D→K |
| `path-repo-onboarding-map` | repo | 新建 | D→D→Del→K |
| `path-research-ablation-study` | research | 新建 | D→B→V→R→K |
| `path-docs-rfc-to-adr` | docs | 新建 | D→D→K |

完整 40+ 模板路线图见 `_paths/CATALOG.md`。

### 5.4 关键设计原则

1. **路径指定能力 ID，不指定文件路径**。解析器负责将 `cap-intake-brief` 映射到 `_stages/discover/sub/intake.md`。
2. **一步一能力**：每步映射到恰好一个原子能力（或紧密相关的一小组）。
3. **门禁显式声明**：除第一步外，每步都必须声明 `gate_requires`。
4. **策略是声明式的**：模板声明"哪些策略适用"，不负责"如何检查"。
5. **向后兼容**：旧编排器（`workflow/sub/*.md`）保留，标注迁移头。

---

## 六、Layer C — 执行记录（run-）

### 6.1 什么是执行记录

每次运行路径模板时，创建一个 `run-` 记录，保存：
- 解析后的执行计划
- 当前步骤和进度
- 每步的产物（链接或拷贝）
- 策略检查结果

### 6.2 存储结构

```
$PROJECT/runs/<run-id>/
  plan.yaml          # 解析后的执行计划
  status.yaml        # 当前步骤, pass/fail 历史
  artifacts/         # 步骤输出（symlink 或 copy）
  evidence/          # 策略检查结果
```

### 6.3 Run ID 示例

```
run-path-paper-15min-brief-arxiv-2506-20430-20260223-01
run-path-research-hypothesis-to-evidence-ips-nn-20260223-01
run-path-webui-build-verify-release-blade-web-20260223-02
```

---

## 七、跨切面 — 策略（rule-）

### 7.1 什么是策略

策略是提取自 `quality-gate.md` 中"类型特定检查"的独立 YAML 文件。
它们在门禁点基于产物类型**自动注入**——不需要编排器手动接线。

### 7.2 YAML 结构

```yaml
id: rule-<scope>-<intent>
name: "人类可读名称"
version: 1
triggers:
  output_types: [web-page, html-dashboard]   # 当产物类型匹配时激活
evidence_requirements:
  - type: screenshot-desktop
    command: "playwright screenshot --viewport 1280x800"
    required: true
gate_criteria:
  - "布局在所有视口正确"
  - "文字可读，无重叠"
injection_point:
  before_step: quality-gate
  verify_capabilities: [cap-check-visual-regression]
```

### 7.3 已实现的 5 个策略

| ID | 触发产物类型 | 检查内容 |
|---|---|---|
| `rule-quality-deliverable-minimum` | `*` (所有) | 证据包完整性、复现步骤 |
| `rule-webui-visual-regression` | web-page, html-dashboard | 桌面/平板/手机截图 |
| `rule-paper-structure-integrity` | paper-draft, latex-report | 结构、引用、图表 |
| `rule-research-reproducibility` | model-checkpoint, training-run | 收敛、指标、数据分割 |
| `rule-standards-source-trust` | standards-pack, literature-review | 来源可信、版本当前、可追溯 |

### 7.4 策略注入规则

1. `output_types: ["*"]` 的策略适用于**所有**有门禁的步骤
2. 特定 `output_types` 的策略仅当 `step.output_type` 匹配时适用
3. 多个策略可以同时适用于同一步骤——检查是累加的
4. 策略检查在 `quality-gate` 步骤**之前**运行（证据收集阶段）

---

## 八、解析器（Resolver）

### 8.1 解析流程

```
RESOLVE(path_id, context_params):

  1. 加载路径模板 path_id
  2. 对每一步:
     a. 查找能力 ID:
        - cap-* → 直接查 capability-index
        - 验证动词在 verbs.yaml、对象在 objects.yaml 规范列表中
        - 如果找不到，使用模糊搜索（按 verb/object/output_type）
     b. 匹配 capabilities_needed → capability-index 条目
     c. 如果多个匹配, 按 leveling 排序（优先高 P & M）
     d. 解析到具体的 block 文件路径
     e. 契约验证（如果 block 有 YAML frontmatter）:
        - 验证输入类型从前序步骤输出可获得
        - 验证前置条件满足
  3. 加载策略:
     a. 模板的 required 策略 → 必须注入
     b. 模板的 recommended 策略 → 条件注入
  4. 在门禁点插入策略检查能力
  5. 生成 run_id
  6. 返回解析后的执行计划
```

### 8.2 回退行为

如果解析在任一步骤失败：
1. 检查旧编排器文件是否存在（如 `workflow/sub/research-loop.md`）
2. 如果存在 → 回退到旧编排器，带弃用警告
3. 如果不存在 → 报错

---

## 九、注册表（skills-registry.yaml）

### 9.1 v3 字段

```yaml
version: "3.0.0"

naming_convention:
  layer_a: "cap-<verb>-<object>"
  layer_b: "path-<domain>-<outcome>"
  layer_c: "run-<path-id>-<context>-<yyyymmdd>-<seq>"
  policies: "rule-<scope>-<intent>"

verb_governance: "_resolver/verbs.yaml"    # 18 个规范动词
object_governance: "_resolver/objects.yaml"  # 61 个规范对象

skills:
  - id: brief
    cap_id: cap-extract-brief
    input_types: [goal-statement]
    output_types: [brief]
    policies: [rule-quality-deliverable-minimum]
    leveling: G3-V0-P2-M3

# 新增索引段
policies: [...]
paths: [...]
```

### 9.2 当前统计

| 项目 | 数量 |
|---|---|
| 生命周期阶段 | 10 |
| 原子能力 (cap-*) | 63 |
| 域工具 | 12 家族 |
| 策略 | 5 |
| 路径模板 | 8 |

---

## 十、文件目录结构

```
skills/
  _paths/                 ← Layer B: 路径模板
    CATALOG.md            ← 40+ 模板路线图
    path-paper-15min-brief.yaml
    path-research-hypothesis-to-evidence.yaml
    path-paper-draft-peer-review-loop.yaml
    path-webui-build-verify-release.yaml
    path-standards-scout-and-validate.yaml
    path-repo-onboarding-map.yaml
    path-research-ablation-study.yaml
    path-docs-rfc-to-adr.yaml

  _policies/              ← 跨切面: 策略
    rule-quality-deliverable-minimum.yaml
    rule-webui-visual-regression.yaml
    rule-paper-structure-integrity.yaml
    rule-research-reproducibility.yaml
    rule-standards-source-trust.yaml

  _resolver/              ← 解析器
    resolver.md           ← 解析算法
    capability-index.yaml ← cap-* → 文件映射 (63 entries)
    verbs.yaml            ← 18 个规范动词 + 别名
    objects.yaml          ← 61 个规范对象 + 领域标签
    artifact-types.yaml   ← 64 种产物类型注册表
    3-layer-architecture.md ← 本文档

  _stages/                ← Layer A: 原子能力（8 阶段，隐藏）
    discover/
    decide/
    build/
    verify/
    deliver/
    operate/
    review/
    knowledge/

  _tools/                 ← 域工具（12 家族，43+ 工具）
  workflow/               ← L0 路由器 + 旧编排器（可发现）
  office/                 ← 文档工具聚合（可发现）
  skill-creator-standard/ ← 治理工具（可发现）

skills-registry.yaml      ← v3 注册表
tools/
  setup.sh                ← 部署脚本
  build_capability_index.sh ← 能力索引生成器
```

---

## 十一、工作流程：创建新技能

使用 `/skill-creator` 时，遵循以下决策树：

```
用户需求
  │
  ├─ 是多阶段工作流？
  │    ├─ 是 → 检查 _paths/CATALOG.md
  │    │    ├─ 有匹配的 path-* → 配置参数，直接用
  │    │    └─ 无匹配 → 创建新 path-<domain>-<outcome>.yaml
  │    └─ 否 ↓
  │
  ├─ 是验证/检查关注点？
  │    ├─ 是 → 创建 rule-<scope>-<intent>.yaml
  │    └─ 否 ↓
  │
  ├─ 是跨阶段可复用工具？
  │    ├─ 是 → 放入 _tools/<family>/
  │    └─ 否 ↓
  │
  ├─ 是单阶段原子能力？
  │    ├─ 是 → 创建 _stages/<stage>/sub/<action>.md
  │    │       注册 cap-<verb>-<object>
  │    └─ 否 ↓
  │
  └─ 是独立用户调用能力？
       └─ 是 → 创建 <name>/SKILL.md（带 YAML frontmatter）
```

### 注册检查清单

创建完后必须：
- [ ] 命名通过 Lint（kebab-case, 3-6 token, 受控动词, 正确阶段/领域）
- [ ] Artifact Contract 完整（I/O/Done/Evidence/Gates/Next-hop/Downstream）
- [ ] Dedup 通过（无 70%+ 重叠）
- [ ] Leveling 已赋值（G/V/P/M）
- [ ] `skills-registry.yaml` 已更新（cap_id + input/output types + policies）
- [ ] `capability-index.yaml` 已更新（或运行 `build_capability_index.sh`）
- [ ] 父级 SKILL.md 已更新（如果是 sub-skill）
- [ ] workflow 路由已更新（如果有触发词别名）

---

## 十二、三层调用面

用户不需要面对 100+ 原子能力。系统通过三层调用面逐步聚焦：

### L0: 入口命令（Command Palette）

日常只需 ~15 个入口命令。系统自动选 path → resolve steps → 注入 rules → 执行。

| 入口命令 | 路由到 | 说明 |
|---|---|---|
| `paper` / `paper-15m` | path-paper-15min-brief | 15 分钟速读 |
| `research` / `research-loop` | path-research-hypothesis-to-evidence | 科研闭环 |
| `write paper` / `paper-peerreview` | path-paper-draft-peer-review-loop | 写作+审稿 |
| `web build` | path-webui-build-verify-release | Web 发布 |
| `standards` / `standards scout` | path-standards-scout-and-validate | 标准探查 |
| `onboarding` / `repo map` | path-repo-onboarding-map | 入门地图 |
| `ablation` | path-research-ablation-study | 消融实验 |
| `rfc` / `adr` | path-docs-rfc-to-adr | RFC→ADR |
| `brief` / `intake` | → Discover 阶段 | 单步 |
| `scaffold` | → Build 阶段 | 单步 |
| `gate` / `verify` | → Verify 阶段 | 单步 |
| `ship` / `deliver` | → Deliver 阶段 | 单步 |
| `retro` / `review` | → Review 阶段 | 单步 |
| `capture` / `knowledge` | → Knowledge 阶段 | 单步 |

### L1: 路径模板库（Path Library）— 用户可见

~40 个路径模板，按 domain 分面浏览。用户日常操作层。

选择方式: domain → outcome → quality bar

### L2: Step Registry — 默认隐藏

100+ 原子能力。由 Resolver 自动选择，用户无需关心。

仅在以下场景可见:
- skill-creator 创建/修改 step
- Resolver 找不到匹配的 step
- 调试/优化

### Router 流程

```
用户输入 → L0 入口命令匹配
  ↓
选择 path-* 模板 (L1)
  ↓
展开步骤骨架 → Resolver 选择 cap-* 实现 (L2, 自动)
  ↓
Policy Engine 注入 rule-* 检查 (自动)
  ↓
执行 → 产出 run-* 记录
```

---

## 十三、部署

```bash
# 从 repo 部署到 ~/.claude/skills/
bash tools/setup.sh

# 重新生成能力索引
bash tools/build_capability_index.sh
```

`setup.sh` 会自动拷贝：
- 3 个可见 skill 目录（workflow, office, skill-creator-standard）到顶层
- 8 个生命周期阶段目录到 `_stages/`（隐藏，不被自动发现）
- `_paths/`, `_policies/`, `_resolver/` 三个新目录
- 链接 `_tools/` 和 `skills-registry.yaml`

---

## 十四、与旧系统的关系

| 旧 | 新 | 状态 |
|---|---|---|
| `workflow/sub/paper-15m.md` | `path-paper-15min-brief` | 已迁移，旧文件保留备用 |
| `workflow/sub/research-loop.md` | `path-research-hypothesis-to-evidence` | 已迁移，旧文件保留备用 |
| `workflow/sub/paper-peerreview.md` | `path-paper-draft-peer-review-loop` | 已迁移，旧文件保留备用 |
| quality-gate.md 类型检查 | `rule-*.yaml` 策略文件 | 已提取，quality-gate.md 引用策略 |
| `<stage>-<action>` 命名 | `cap-<verb>-<object>` | v3: stage 为元数据，不在 ID 中 |

**零破坏**：所有旧的触发词、路由表、编排器仍然有效。解析器失败时自动回退到旧编排器。
