---
name: operate
description: "Operational support: experiment tracking, observability, runbooks, incident triage, cost optimization. Use when monitoring systems, tracking experiments, handling failures, or optimizing running infrastructure. Triggers: 'operate', 'monitor', 'ops', 'runbook', 'incident', 'triage', 'cost', 'track'."
---

# operate

长跑与迭代：能观测、能排障、能控成本。

## 触发词
`operate`, `monitor`, `ops`, `runbook`, `incident`, `triage`, `cost`, `track`, `实验记录`

## Sub-skills

| Sub-skill | 文件 | 输入 | 产物 |
|---|---|---|---|
| **Experiment Tracker** | `sub/experiment-tracker.md` | 实验结果 | 自动记录 + 对比 + 汇总 |
| **Observability** | `sub/observability.md` | 系统/服务 | 指标/日志/告警计划 |
| **Runbook** | `sub/runbook.md` | 告警/流程 | 操作手册 |
| **Incident Triage** | `sub/incident-triage.md` | 事故 | 分诊记录 |
| **Cost Performance** | `sub/cost-performance.md` | 使用数据 | 优化建议 |

## 域工具引用
| 域工具 | 路径 | 用途 |
|---|---|---|
| nn-training | `_tools/ml/nn-training.md` | NN 训练 7 步协议 |
| parallel-runner | `_tools/ml/parallel-runner.md` | 多 GPU 并行扫参 |
| status | `_tools/research/status.md` | 项目状态查看 |
| blade | `_tools/blade/blade.md` | Agent 任务操作 |
| gpu-setup | `_tools/infra/gpu-setup-volta04.md` | GPU 环境 |

## 资源分配规则（来自 CLAUDE.md）
- GPU 任务 → volta04; CPU 任务 → elephant6
- 数据 → datascope; 通知 → Telegram
