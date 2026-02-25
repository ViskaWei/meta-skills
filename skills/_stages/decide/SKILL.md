---
name: decide
description: "Compare options and record decisions. Produces: Option Matrix, ADR (Architecture Decision Record), Roadmap MVP, Experiment Design, Resource Budget. Use when choosing between approaches, planning implementation, or designing experiments. Triggers: 'decide', 'plan', 'adr', 'matrix', 'roadmap', 'mvp', 'experiment design'."
---

# decide

把假设树变成最小成本可证伪实验（MVP），写清止损。

## 触发词
`decide`, `plan`, `adr`, `matrix`, `roadmap`, `mvp`, `experiment design`, `budget`, `预算`, `实验计划`

## Gate 前置
**需要**: 假设树 + 评估口径（来自 Discover 阶段）。没有 → 重定向到 `discover`。

## Sub-skills

| Sub-skill | 文件 | 输入 | 产物 | 完成标准 |
|---|---|---|---|---|
| **Option Matrix** | `sub/option-matrix.md` | Brief + 备选方案 | 对比矩阵 | ≥2 方案, 有取舍 |
| **Roadmap MVP** | `sub/roadmap-mvp.md` | 假设树 + 口径 | MVP 列表 + 止损规则 | 每个 MVP 只验证一条假设 |
| **Experiment Design** | `sub/experiment-design.md` | 研究问题 | 实验设计 (变量/对照/统计) | 有止损条件 |
| **ADR** | `sub/adr.md` | Option matrix | 架构决策记录 | 第三人可重述, 有回滚 |
| **Resource Budget** | `sub/resource-budget.md` | Roadmap | 资源预算 | 有止损预算 |
| **Milestone Plan** | `sub/plan-milestones.md` | ADR | M0→M3 计划 | 每个里程碑有验收 |

## 默认行为
- 无 option matrix → 运行 **Option Matrix**
- 有 matrix 无 ADR → 运行 **ADR**
- 有 ADR → 运行 **Roadmap MVP**

## 域工具引用
| 域工具 | 路径 | 用途 |
|---|---|---|
| new-experiment | `_tools/research/new-experiment.md` | 实验计划 |
| design-principles | `_tools/research/design-principles.md` | 设计原则提取 |
| next-steps | `_tools/research/next-steps.md` | P0/P1 任务管理 |
| ml-patterns | `_tools/ml/ml-patterns.md` | ML 实验模式 |

## Gate: Decide → Build
**产物**: ADR (`artifacts/adr.md`) + Roadmap (`artifacts/roadmap.md`)
**要求**: ADR 有决策 + 回滚策略; Roadmap 有 MVP + 止损规则
**FAIL**: 补充决策文档
