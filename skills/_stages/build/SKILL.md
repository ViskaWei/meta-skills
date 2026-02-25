---
name: build
description: "Execute plans into running artifacts. Routes to: flowcharts/diagrams, code scaffolding, data pipelines, ML training, web development, paper writing, media generation. Use when building any artifact, or directly say 'build', 'scaffold', 'flowchart', 'train', 'paper', 'data pipeline', 'model', 'eval', 'website', 'diagram', 'plot', 'table', 'outline'."
---

# build

把计划落地成"可运行的实验/系统/页面"，并带有 UX 表达。

## 触发词
`build`, `implement`, `code`, `scaffold`, `flowchart`, `train`, `paper`, `data pipeline`, `model`, `eval`, `website`, `diagram`, `plot`, `table`, `写论文`, `outline`

## Gate 前置
**需要**: ADR + Roadmap（来自 Decide 阶段）。
**例外**: 直接工具别名（flowchart, train, image）跳过此门禁。

## Sub-skills

| Sub-skill | 文件 | 输入 | 产物 | 完成标准 |
|---|---|---|---|---|
| **Scaffold** | `sub/scaffold.md` | ADR/plan | 可跑最小框架 | 一条命令跑通 |
| **Data Pipeline** | `sub/data-pipeline.md` | 数据源 | 数据加载 + split + 契约 | 无泄漏, 有 assertion |
| **Model & Loss** | `sub/model-loss.md` | ADR + 口径 | 模型 + 损失 + 先验注入 | 退化模式已列出 |
| **Eval Harness** | `sub/eval-harness.md` | 口径 | 统一评估脚本 | 与 metrics-contract 对齐 |
| **UX Structure Map** | `sub/ux-structure-map.md` | 任意目标 | 流程图 (L0/L1/L2) | 3 秒理解 |
| **Visualization Pack** | `sub/visualization-pack.md` | 实验结果 | 图表模板包 | colorblind-friendly |
| **Paper Outline** | `sub/paper-outline.md` | 实验结果 | Section outline + claim map | 每个 claim 有证据 |
| **Paper Draft** | `sub/paper-draft.md` | Outline | 完整段落 | 全段落, 引用完整 |
| **Results Table** | `sub/results-table.md` | 实验结果 JSON | 主表 + 消融表 (LaTeX) | 最优值加粗, 方向标注 |
| **Task Decomposition** | `sub/task-decomposition.md` | ADR | 任务树 | 每任务 0.5-2 天 |
| **Interface Contracts** | `sub/interface-contracts.md` | 任务树 | I/O 契约 | 有 boundary case |

## 域工具路由（直接别名触发）

| 触发词 | 域工具 | 路径 |
|---|---|---|
| "flowchart", "流程图", "pipeline diagram" | 流程图 | `_tools/flowchart/orchestrator.md` |
| "write paper", "manuscript" | 科学写作 | `_tools/paper/sub/scientific-writing.md` |
| "train model", "NN training", "sweep" | ML 训练 | `_tools/ml/nn-training.md` |
| "website", "interactive site" | Web | `_tools/web/repo-explorer.md` |
| "image", "schematic" | 媒体 | `_tools/media/generate-image.md` |
| "research", "rq" | 研究 | `_tools/research/project-manager.md` |
| "SpecViT", "DESI" | 天文 | `_tools/astro/` |
| "blade" | Blade | `_tools/blade/blade.md` |
| "report", "生成报告" | 报告 | `_tools/paper/sub/doc-latex-report.md` |
| "algo latex", "pseudocode" | 算法 | `_tools/paper/sub/algo-plot-latex.md` |
| "code2algo" | 代码→算法 | `_tools/paper/sub/code2algo.md` |
| "code2d2" | 代码→D2 | `_tools/web/code2d2-web.md` |
| "coding prompt" | 编码提示 | `_tools/research/coding-prompt.md` |
| "parallel sweep" | 并行扫描 | `_tools/ml/parallel-runner.md` |

## 默认行为
- 用户说工具别名 → 直接路由到域工具
- 无别名 → Scaffold → Data Pipeline → Model → Eval
- 写论文 → Paper Outline → Paper Draft
