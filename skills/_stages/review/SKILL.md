---
name: review
description: "Retrospectives, experiment retros, paper peer review, and process improvement. Produces: Postmortem, Exp Retro, Decision Gate, Paper Peer Review, Editorial Review, Rebuttal Prep. Use after completing experiments, writing papers, or handling incidents. Triggers: 'review', 'retro', 'postmortem', 'peer review', 'editorial', 'rebuttal', 'decision gate'."
---

# review

从结果中提炼下一轮决策输入。实验复盘 + 论文审稿 + 过程改进。

## 触发词
`review`, `retro`, `复盘`, `postmortem`, `peer review`, `审稿`, `editorial`, `rebuttal`, `design principles`, `decision gate`, `设计原则`, `决策门`

## Sub-skills

| Sub-skill | 文件 | 输入 | 产物 |
|---|---|---|---|
| **Exp Retro** | `sub/exp-retro.md` | 实验汇总 | 复盘 (失败原因 + 信号 + 下一步) |
| **Design Principles** | `sub/design-principles-extract.md` | 多轮实验经验 | Do/Don't 原则 + 反模式 |
| **Decision Gate** | `sub/decision-gate.md` | 复盘 + 预算 | 继续/换方向/写论文 |
| **Paper Peer** | `sub/paper-peer.md` | 论文稿 | 5 维评审 + 返工清单 |
| **Paper Editorial** | `sub/paper-editorial.md` | 论文稿 | 行文/结构/密度优化 |
| **Rebuttal Prep** | `sub/rebuttal-prep.md` | 论文 + review | 预判 concerns + 回应 |
| **Postmortem** | `sub/postmortem.md` | 事故/项目 | 根因 + action items |
| **Metrics Retro** | `sub/metrics-retro.md` | 成功指标 | 指标复盘 |
| **Process Improvement** | `sub/process-improvement.md` | 复盘发现 | 流程改进建议 |

## 域工具引用
| 域工具 | 路径 | 用途 |
|---|---|---|
| archive | `_tools/research/archive.md` | 实验归档 |
| merge | `_tools/research/merge.md` | 合并相似实验 |
| update | `_tools/research/update.md` | 更新实验文档 |
| peer-review | `_tools/paper/sub/peer-review.md` | 完整审稿 checklist |
| scientific-critical-thinking | `_tools/paper/sub/scientific-critical-thinking.md` | 方法论批判 |
| scholar-evaluation | `_tools/paper/sub/scholar-evaluation.md` | 8 维学术评估 |
| scicomp-validation | `_tools/ml/scicomp-validation.md` | 科学计算 bug 检测 |

## Review-Fix 循环（论文场景）
`review-paper-peer` → 返工 → `build-paper-draft` → `verify-paper-structure` → `review-paper-peer`（Round N+1）
重复直到 Accept / Minor Revision。
