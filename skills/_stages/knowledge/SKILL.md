---
name: knowledge
description: "Capture and productize project knowledge. Produces: Knowledge Cards, Hub Sync, Index, Standards Updates, Template Library, Learning Plans. Use when documenting learnings, updating standards, building reusable templates, or syncing results back to research hub. Triggers: 'knowledge', 'capture', 'card', 'hub sync', 'index', 'template', 'standards', 'broadcast'."
---

# knowledge

把经验固化成可检索、可复用、可自动调用的资产。

## 触发词
`knowledge`, `capture`, `card`, `hub sync`, `index`, `标签`, `template`, `standards`, `broadcast`, `卡片`, `沉淀`, `回写`

## Sub-skills

| Sub-skill | 文件 | 输入 | 产物 |
|---|---|---|---|
| **Hub Sync** | `sub/hub-sync.md` | 实验复盘 | Hub 回写（假设状态 + 关键数字） |
| **Card Create** | `sub/capture.md` | 项目/实验 | 知识卡片 (What/Why/How/Pitfalls) |
| **Index** | `sub/index.md` | 知识产物 | 索引 + 标签 |
| **Standards Update** | `sub/standards-update.md` | 过程改进 | 标准版本升级 |
| **Template Library** | `sub/template-library.md` | 重复模式 | 可复用模板 |
| **Learning Loop** | `sub/learning-loop.md` | 知识库 | 学习计划 |

## 域工具引用
| 域工具 | 路径 | 用途 |
|---|---|---|
| card | `_tools/research/card.md` | 研究知识卡片 |
| broadcast | `_tools/research/broadcast.md` | 跨项目广播 |
| design-principles | `_tools/research/design-principles.md` | 设计原则提取 |
| notebooklm-learn | `_tools/paper/sub/notebooklm-learn.md` | NotebookLM 优化 |
| skill-creator-enhanced | `_tools/skill/skill-creator-enhanced.md` | 从学习创建 skill |

## 默认行为
- 实验结束后 → **Hub Sync** + **Card Create** + **Index**
- 标准变化 → **Standards Update**
- 重复模式 → **Template Library**
