# Skill Decompose — 技能分类决策树

> 元工具：将任意 skill / tool / plugin 分类为 3-layer 框架中的 8 种类型之一

---

## 决策树

对每个待分类的 skill，从 Q1 开始，顺序回答。**第一个命中的分支即为最终分类。**

```
Q1: 仅做质检 pass/fail？
  └─ YES → policy (rule-<scope>-<intent>)
     放置: _policies/rule-*.yaml

Q2: 编排 3+ 能力的多步流程？
  ├─ YES + 用户直接调用 → orchestrator (L0)
  │  放置: workflow/SKILL.md 路由表 或 独立 <name>/SKILL.md
  └─ YES + 内部编排 → path-template (L1)
     放置: _paths/path-<domain>-<outcome>.yaml

Q3: 外部 marketplace 插件？
  └─ YES → external (仅引用，不复制代码)
     放置: skills-registry.yaml 中 source: "marketplace"

Q4: 仅影响输出格式/样式/主题？
  └─ YES → style (非能力，不需 cap-*)
     放置: _tools/<family>/ 作为参考文件

Q5: ★关键测试★ 是否产出参与门禁链的 artifact？
  ├─ YES + 已有 cap-* 覆盖同 artifact → tool-adapter (multi-provider)
  │  放置: _tools/<family>/sub/*.md
  │  注册: capability-catalog.yaml 中作为已有 cap-* 的额外 provider
  │
  ├─ YES + 无现有 cap-* → cap-* (新能力，需注册)
  │  放置: _caps/core/*.md 或 _tools/<family>/sub/*.md
  │  注册: objects.yaml + capability-catalog.yaml + skills-registry.yaml
  │
  └─ NO → utility (辅助工具，不需 cap-*)
     放置: _tools/<family>/*.md
```

---

## Artifact Test (Q5) 判定标准

必须同时满足以下 **三个条件** 才算 "产出参与门禁链的 artifact"：

1. **命名型产出物**：产出物是 `artifact-types.yaml` 中已有类型（或有充分理由新增），且有明确的格式和结构
2. **被消费或触发**：该产出物被其他 cap-* 作为 input 消费，或被 rule-* 触发检查，或是门禁链的终态交付物
3. **可独立重复调用**：每次调用产出一致的 artifact（非交互式、非状态依赖）

---

## cap-* vs utility 分界线

| 特征 | cap-* (能力) | utility (辅助) |
|---|---|---|
| 产出物 | 可被下游消费的命名 artifact | 瞬态显示/格式转换/环境配置 |
| 注册要求 | 必须在 capability-catalog + registry | 只需在 _tools/ 目录 |
| 合约 | 有 input_types/output_types | 无 |
| 门禁参与 | YES — artifact 类型触发 rule-* | NO |
| 示例 | cap-render-slides → slides artifact | gpu-setup → 环境配置 |

---

## tool-adapter vs 新 cap-* 分界线

| 特征 | tool-adapter | 新 cap-* |
|---|---|---|
| 目标 artifact | 已有 cap-* 覆盖 | 无现有 cap-* |
| 注册方式 | capability-catalog 中已有 cap-* 条目下新增 provider | 新增 cap-* 条目 |
| Leveling | 通常 P1-M2 (较低) | 需独立评估 |
| 示例 | citation-management → cap-check-citation-integrity 的 adapter | cap-render-slides (全新) |

---

## 8 种分类结果

| # | 类型 | ID 格式 | 放置位置 | 注册要求 |
|---|---|---|---|---|
| 1 | **policy** | rule-<scope>-<intent> | `_policies/` | skills-registry.yaml |
| 2 | **orchestrator** | L0 keyword | `workflow/` routing table | skills-registry.yaml |
| 3 | **path-template** | path-<domain>-<outcome> | `_paths/` | skills-registry.yaml |
| 4 | **external** | (marketplace name) | 引用 only | skills-registry.yaml source: marketplace |
| 5 | **style** | (descriptive) | `_tools/<family>/` | none |
| 6 | **tool-adapter** | cap-<verb>-<object> (existing) | `_tools/<family>/sub/` | capability-catalog.yaml |
| 7 | **cap-*** | cap-<verb>-<object> (new) | `_caps/core/` or `_tools/` | full registration |
| 8 | **utility** | (descriptive) | `_tools/<family>/` | none |

---

## 分类输出格式

对每个分类的 skill 产出一行记录：

```yaml
- tool: <原始文件名>
  family: <所属家族>
  classification: <8 种之一>
  cap_id: <cap-* ID 或 null>
  stage: <lifecycle stage 或 null>
  placement: <目标文件路径>
  artifact_produced: <artifact type 或 null>
  decision_path: "Q<n>=<answer> → <classification>"
  flags: [AMBIG, NEW_OBJECT, NEW_CAP, NEW_ARTIFACT, NEEDS_REVIEW]
```

### flags 说明

| Flag | 含义 |
|---|---|
| `AMBIG` | 决策树中有歧义，需人工确认 |
| `NEW_OBJECT` | 需要在 objects.yaml 新增名词 |
| `NEW_CAP` | 需要在 capability-catalog.yaml 新增条目 |
| `NEW_ARTIFACT` | 需要在 artifact-types.yaml 新增类型 |
| `NEEDS_REVIEW` | 预判不确定，需 review |

---

## 使用方法

```
1. 列出所有待分类的 skill/tool
2. 对每个逐一执行决策树 (Q1 → Q5)
3. 记录分类结果 + flags
4. 汇总到 docs/skill-decomposition-map.md
5. 根据 flags 更新治理文件 (objects.yaml, capability-catalog.yaml, etc.)
```
