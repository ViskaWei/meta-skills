# FDPS v4 — Flat-Domain Progressive Skill Architecture

> 版本 4.0 — 2026-02-27
> 作者：Viska Wei
> 迁移自 v3（8-Stage Lifecycle → Flat-Domain）

---

## 一、为什么需要 FDPS v4？

v3 系统有 **29 个核心能力**，组织在 8 个生命周期阶段（_stages/）。
三个结构性问题推动了架构升级：

| 问题 | 表现 | v4 解决方案 |
|---|---|---|
| **阶段目录冗余** | 能力文件 path 包含 stage 名，重命名代价大 | Flat domain: `_caps/core/` |
| **索引 vs 注册表分裂** | capability-index 和 stages: section 重复维护 | 单一 catalog 文件 |
| **Token 开销** | 加载 stages: section 需 ~3K tokens | Catalog 按需加载 |

**核心原则**（来自 Anthropic TST + ToolGen ICLR 2025）：
- **Flat over hierarchical**: ToolGen 证明 flat 组织 55% vs 45.5% 准确率
- **Progressive disclosure**: Anthropic TST 实现 -85% token 开销
- **Domain-based organization**: 7/7 框架共识

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
         verb: verbs.yaml (18个); object: objects.yaml (89个)
         存储位置: _caps/core/*.md + _tools/<family>/*.md

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

Stage 不再作为 ID 的一部分，而是作为元数据标签（`stage:` field in catalog）。

| 字段 | 说明 | 可选值 |
|---|---|---|
| `verb` | 来自受控词汇表（见 §3.5） | 18 个规范动词 (`verbs.yaml`) |
| `object` | 操作的产物或概念 | 89 个规范对象 (`objects.yaml`) |

**示例**：
```
cap-extract-requirements     (stage: discover, domain: core)
cap-decide-adr              (stage: decide, domain: core)
cap-scaffold-experiment      (stage: build, domain: core)
cap-assemble-evidence-bundle (stage: verify, domain: core)
cap-package-output           (stage: deliver, domain: core)
cap-capture-card             (stage: knowledge, domain: core)
```

Stage 信息来源（优先级）：
1. `capability-catalog.yaml` 中的 `stage:` 元数据
2. Cap contract frontmatter 中的 `stage:` 字段

#### 3.1.2 治理文件

- **verbs.yaml**: 18 个规范动词 + 别名（用于 L0 输入解析）
- **objects.yaml**: 89 个规范对象 + 领域标签
- **artifact-types.yaml**: 98 种产物类型（用于契约验证）

新增 verb 或 object 需要先注册，防止命名漂移。

### 3.2 Layer B：路径模板 ID（path-）

**格式**：`path-<domain>-<outcome>`

| 字段 | 说明 | 可选值 |
|---|---|---|
| `domain` | 领域 | `research / paper / repo / webui / docs / data / ops / standards / general` |
| `outcome` | 连字符描述最终结果 | 自由，但要 ≤4 个词 |

### 3.3 Layer C：执行记录 ID（run-）

**格式**：`run-<path-id>-<context>-<yyyymmdd>-<seq>`

### 3.4 跨切面：策略 ID（rule-）

**格式**：`rule-<scope>-<intent>`

### 3.5 受控动词表

只允许以下 18 个规范动词出现在 `cap-` ID 中。
完整定义、别名、和语义边界见 `_resolver/verbs.yaml`。

| 动词 | 含义 | 典型阶段 |
|---|---|---|
| `intake` | 接收并验证输入 | discover |
| `extract` | 从非结构化来源提取结构化信息 | discover |
| `map` | 创建可视化/结构化表示 | discover, build |
| `compare` | 并列评估选项 | decide |
| `decide` | 记录决策及理由 | decide, verify, review |
| `plan` | 创建前瞻性计划 | decide |
| `scaffold` | 创建最小可运行结构 | build |
| `build` | 实现完整产物 | build |
| `render` | 生成可视化/格式化输出 | build |
| `assemble` | 将多个输入组合为一个产物 | verify |
| `check` | 验证某个质量维度 | verify |
| `package` | 打包交付 | deliver |
| `publish` | 对外发布 | deliver |
| `track` | 记录运行时指标和事件 | operate |
| `triage` | 分类和优先排序事件 | operate |
| `review` | 用结构化标准评估质量 | review |
| `capture` | 创建可复用知识产物 | knowledge |
| `sync` | 更新已有知识库 | knowledge |

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
- 属于一个 domain（public core 全部是 `core`）
- 有 `stage:` 元数据标签（lifecycle 信息保留但不影响目录结构）
- 有明确的 Artifact Contract（输入/输出/完成条件/证据/门禁/下游）
- 有 Leveling 标签（G/V/P/M）

### 4.2 能力目录（Capability Catalog）

所有能力注册在 `_resolver/capability-catalog.yaml` 中：

```yaml
version: '4.0.0'

capabilities:
  cap-intake-brief:
    title: "Input Manifest"
    domain: core
    stage: discover
    verb: intake
    object: brief
    triggers: ["intake", "input"]
    input_types: [url, file-path]
    output_types: [intake-manifest]
    leveling: G3-V0-P2-M3
    summary: "Input manifest"
    block: "_caps/core/intake.md"
    cap_contract: true
```

每条 ~35 tokens，29 条核心 = ~1K tokens（vs v3 stages: section ~3K）。

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

验证工具：`bash tools/validate_contracts.sh`

### 4.3 Leveling 系统

每个能力有 4 轴标签：`Gx-Vy-Pz-Mk`

| 轴 | 含义 | 等级 |
|---|---|---|
| **G（通用性）** | 谁用？ | G3=跨项目跨域, G2=跨项目特定域, G1=单项目, G0=临时 |
| **V（易变性）** | 多久变一次？ | V0=稳定, V1=慢, V2=中, V3=快 |
| **P（熟练度）** | 有多可靠？ | P0=草稿, P1=可用, P2=可靠, P3=硬化 |
| **M（成熟度）** | 多完整？ | M0=桩, M1=规格, M2=已实现, M3=已门禁, M4=已观测 |

### 4.4 当前能力统计

| Domain | Stage | 数量 |
|---|---|---|
| core | discover | 7 |
| core | decide | 5 |
| core | build | 3 |
| core | verify | 3 |
| core | deliver | 2 |
| core | operate | 2 |
| core | review | 4 |
| core | knowledge | 3 |
| **总计** | | **29** |

Private overlay 扩展至 12 domains、157+ capabilities。

---

## 五、Layer B — 路径模板（path-）

### 5.1 什么是路径模板

路径模板是预定义的多阶段工作流模板。它不包含实现代码，只定义：
- **阶段骨架**：哪些步骤，什么顺序
- **能力需求**：每步需要哪些 `cap-*` 能力
- **门禁点**：步骤之间的依赖关系
- **分支条件**：何时跳转或循环
- **策略绑定**：必须/推荐注入哪些 `rule-*` 策略

### 5.2 已实现的路径模板

| ID | 领域 | 阶段链 |
|---|---|---|
| `path-general-skill-health` | general | 健康检查 |
| `path-general-skill-quality` | general | 质量审计 |
| `path-general-entropy-cleanup` | general | 熵清理 |
| `path-general-capability-gap` | general | 缺口诊断 |
| `path-research-new-experiment` | research | 新实验 |
| `path-research-hypothesis-to-evidence` | research | 假设→证据 |

### 5.3 关键设计原则

1. **路径指定能力 ID，不指定文件路径**。解析器负责将 `cap-intake-brief` 映射到 `_caps/core/intake.md`。
2. **一步一能力**：每步映射到恰好一个原子能力。
3. **门禁显式声明**：除第一步外，每步都必须声明 `gate_requires`。
4. **策略是声明式的**：模板声明"哪些策略适用"，不负责"如何检查"。

---

## 六、Layer C — 执行记录（run-）

每次运行路径模板时，创建一个 `run-` 记录。

存储结构：
```
$PROJECT/runs/<run-id>/
  plan.yaml          # 解析后的执行计划
  status.yaml        # 当前步骤, pass/fail 历史
  artifacts/         # 步骤输出
  evidence/          # 策略检查结果
```

---

## 七、跨切面 — 策略（rule-）

策略在门禁点基于产物类型**自动注入**。

### 7.1 策略注入规则

1. `output_types: ["*"]` 的策略适用于**所有**有门禁的步骤
2. 特定 `output_types` 的策略仅当 `step.output_type` 匹配时适用
3. 多个策略可以同时适用于同一步骤——检查是累加的
4. 策略检查在 `quality-gate` 步骤**之前**运行

---

## 八、解析器（Resolver）

### 8.1 解析流程

```
RESOLVE(path_id, context_params):

  1. 加载路径模板 path_id
  2. 对每一步:
     a. 查找能力 ID → capability-catalog.yaml
     b. Multi-signal search (trigger 0.30 + output_type 0.25 + input_chain 0.20 + domain 0.15 + semantic 0.10)
     c. 如果多个匹配, 按 leveling 排序
     d. 解析到 block 文件路径 (_caps/core/*.md)
     e. 契约验证
  3. 加载策略 → 注入门禁
  4. 生成 run_id
  5. 返回执行计划
```

---

## 九、文件目录结构

```
skills/
  _caps/                  ← Layer A: 原子能力（FDPS v4，flat domain）
    core/                 ← 29 core capabilities
  _paths/                 ← Layer B: 路径模板
  _policies/              ← 跨切面: 策略
  _resolver/              ← 解析器
    resolver.md           ← 解析算法
    capability-catalog.yaml ← cap-* → 文件映射 (29 entries)
    verbs.yaml            ← 18 个规范动词 + 别名
    objects.yaml          ← 89 个规范对象 + 领域标签
    artifact-types.yaml   ← 98 种产物类型注册表
  _tools/                 ← 域工具
  _standards/             ← 治理工具
  meta/                   ← L0: 系统维护（可发现）
  build/                  ← L0: 构建命令（可发现）
  research/               ← L0: 科研命令（可发现）
  improve/                ← L0: 改进命令（可发现）

skills-registry.yaml      ← v4 注册表
tools/
  setup.sh                ← 部署脚本
  build_capability_catalog.sh ← 能力目录生成器
```

---

## 十、与 v3 的关系

| v3 | v4 | 状态 |
|---|---|---|
| `_stages/<stage>/sub/*.md` | `_caps/core/*.md` | 已迁移 |
| `_stages/<stage>/SKILL.md` | 删除（stage 为 metadata） | 已删除 |
| `capability-index.yaml` | `capability-catalog.yaml` | 已替换（旧文件保留 DEPRECATED） |
| `skills-registry.yaml` stages: section | `catalog_file` reference | 已简化 |
| `build_capability_index.sh` | `build_capability_catalog.sh` | 已重命名 |

---

## 十一、部署

```bash
# 从 repo 部署到 ~/.claude/skills/
bash tools/setup.sh

# 重新生成能力目录
bash tools/build_capability_catalog.sh
```

`setup.sh` 会自动拷贝：
- 4 个 L0 command 目录（meta, build, research, improve）到顶层
- `_caps/core/` 到 `_caps/core/`（隐藏，不被自动发现）
- `_paths/`, `_policies/`, `_resolver/`, `_standards/` 到隐藏目录
- 链接 `_tools/` 和 `skills-registry.yaml`
