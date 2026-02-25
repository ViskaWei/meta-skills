---
name: discover
description: "Turn vague goals into actionable briefs, problem trees, hypothesis trees, and metrics contracts. Produces: Brief, Requirements, Context Map, Risk Register. Use when starting a new project, reading papers, or when requirements are unclear. Triggers: 'discover', 'brief', 'spec', 'intake', 'skim', 'hypothesis', 'metrics'."
---

# discover

把"想法/输入材料"变成可执行的问题定义与假设树。

## 触发词
`discover`, `brief`, `spec`, `intake`, `skim`, `hypothesis`, `metrics`, `问题定义`, `假设树`, `速读`, `评估口径`, `risk register`, `新项目`, `start project`, `standards`, `SOP`, `playbook`, `best practices`, `industry standard`

## Sub-skills

| Sub-skill | 文件 | 输入 | 产物 | 完成标准 |
|---|---|---|---|---|
| **Intake** | `sub/intake.md` | 用户目标 + 输入源 | Input Manifest | 每个源有类型/版本/状态 |
| **Literature Skim** | `sub/literature-skim.md` | arXiv URL / PDF | 1 页结构化笔记 | 所有字段填写, ≥1 可复用点 |
| **Problem Tree** | `sub/problem-tree.md` | 目标 + manifest | 问题树 (What/Why/Constraints/Metrics) | 四维度有具体内容, metrics 可测量 |
| **Hypothesis Tree** | `sub/hypothesis-tree.md` | 问题树 | 假设树 (可证伪条件 + 证据类型) | ≥2 假设, 有止损规则 |
| **Metrics Contract** | `sub/metrics-contract.md` | 假设树 + metrics | 评估口径 (定义 + 阈值 + 泄漏检查) | 第三人可独立实现得到相同结果 |
| **Brief** | `sub/brief.md` | 目标 + 材料 | 1 页 Brief | 所有字段填写, metrics 可测量 |
| **Requirements** | `sub/requirements.md` | Brief | MoSCoW 需求列表 | 每条有验证方法 |
| **Context Map** | `sub/context-map.md` | Repo/系统 | 上下文图 | 回答"在哪/谁管/什么坏" |
| **Risk Register** | `sub/risk-register.md` | Brief + context | 风险清单 | Top 5 有缓解措施 |
| **Standards Scout** | `sub/standards-scout.md` | 模糊需求 + 成熟领域 | Standards Pack (brief, landscape, playbook, checklist, templates, refs) | 2+ 行业路线已比较, 有默认推荐 |

## 默认行为
- 无指定 sub-skill → 运行 **Intake** → **Problem Tree**
- 已有问题树 → 运行 **Hypothesis Tree**
- 用户说 "skim" / "速读" → 直接 **Literature Skim**
- 用户说 "standards" / "SOP" / "playbook" / "best practices" → 直接 **Standards Scout**

## 域工具引用
| 域工具 | 路径 | 用途 |
|---|---|---|
| research-lookup | `_tools/research/lookup.md` | Perplexity 文献检索 |
| literature-review | `_tools/paper/sub/literature-review.md` | 系统性文献综述 |
| hypothesis-generation | `_tools/paper/sub/hypothesis-generation.md` | 假设生成 |
| citation-management | `_tools/paper/sub/citation-management.md` | 引用管理 |
| repo-init | `_tools/research/repo-init.md` | 初始化研究项目 |
| session | `_tools/research/session.md` | GPT/Claude 会话归档 |

## Gate: Discover → Decide
**产物**: 假设树 (`artifacts/hypothesis-tree.md`) + 评估口径 (`artifacts/metrics-contract.md`)
**要求**: 假设树 ≥2 条可证伪假设，口径冻结
**FAIL**: 补充假设或口径
