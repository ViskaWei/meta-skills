---
name: research
description: "科研生命周期 — 立项、完整循环、知识沉淀。3 个子命令覆盖核心科研 pipeline。Triggers: 'research', '科研', 'experiment', 'hypothesis'."
---

# research

**科研项目的核心 pipeline。** 从 research question 到 knowledge card，3 个子命令覆盖科研关键路径。

与其他 L0 的区别：
- `/build` → 构建**任意**可运行制品
- `/improve` → 改善**已有**制品
- `/research` → 管理**科研项目**的生命周期

## 触发词

`research`, `科研`, `experiment`, `hypothesis`, `rq`

## 语法

```
/research <sub-command> [target] [flags]
```

## Flags

| Flag | Short | Description | Default |
|---|---|---|---|
| `--topic <name>` | `-T` | 研究课题目录名 | Auto-detect |
| `--goal "..."` | `-g` | 研究问题或目标 | From natural language |
| `--depth fast\|standard\|deep` | `-d` | 研究深度 | standard |

## 子命令路由表

| Sub-command | Path | 做什么 |
|---|---|---|
| `new` | `path-research-new-experiment` | 6 步立项: RQ → 问题树 → 假设 → 指标 → 路线图 → scaffold |
| `full` | `path-research-hypothesis-to-evidence` | 完整科研循环: Discover → Decide → Build → Verify → Review → Knowledge |
| `card` | (knowledge stage) | 知识沉淀: 从实验结果提炼 → 知识卡片 → hub sync |

## 共同特征

1. **假设驱动** — 每个实验验证一条可证伪假设
2. **止损规则** — 连续失败 → 退回重新定义问题
3. **知识沉淀** — 实验结果 → 卡片 → Hub

## Router Profile

```yaml
candidate_paths:
  - path-research-new-experiment           # /research new
  - path-research-hypothesis-to-evidence   # /research full
default_output: evidence-bundle
default_rules:
  - rule-quality-deliverable-minimum
  - rule-research-front-loading
  - rule-completion-guard
```

---

## 各 Path 详解

### `new` — 立项（6 步）

`path-research-new-experiment` — 结构化立项，仅产出文档不执行代码。

```
[Discover]  intake → problem-tree → hypotheses → metrics
[Decide]    → roadmap
[Build]     → scaffold (文档骨架)
```

| Step | Cap | 产出 |
|---|---|---|
| intake | `cap-intake-brief` | 研究问题 + 约束 |
| problem-tree | `cap-map-problem-tree` | 问题分解树 |
| hypotheses | `cap-map-hypothesis-tree` | 可证伪假设 (≥2) |
| metrics | `cap-extract-metrics-contract` | 评估口径 + 阈值 |
| roadmap | `cap-plan-roadmap` | MVP 列表 + 止损规则 |
| scaffold | `cap-scaffold-experiment` | hub + roadmap + exp 骨架 |

**Policies**: rule-quality-deliverable-minimum, rule-research-front-loading

---

### `full` — 完整循环（24 步）

`path-research-hypothesis-to-evidence` — 从假设到证据到知识。

```
[Discover]  intake → problem-tree → hypotheses → metrics
[Decide]    roadmap → experiment-design → resource-budget → ADR
[Build]     scaffold → data-pipeline → model → eval-harness
[Operate]   → experiment tracking
[Verify]    evidence → metric-sanity → reproducibility → quality-gate
[Review]    retro → design-principles → decision-gate
[Knowledge] card → hub-sync → index
```

**分支规则**:
- decision-gate → "继续" → 回到 roadmap（下一个 MVP）
- decision-gate → "转向" → 回到 problem-tree
- quality-gate → "FAIL" → 回到 scaffold

**Extension Points（不在公开 repo，按需创建）**:
- `cap-build-data-pipeline` / `cap-build-model-loss` / `cap-render-eval-harness`（Build 阶段）
- `cap-track-experiment`（Operate 阶段）
- `cap-check-metric-sanity` / `cap-check-reproducibility`（Verify 阶段）
- `cap-plan-resource-budget`（Decide 阶段）

这些是 domain-specific 能力，用户按自己的领域创建对应的 L2 block。

---

### `card` — 知识沉淀

使用 Knowledge stage 的已有能力：

```
[Review]    cap-extract-retro → cap-extract-design-principles
[Knowledge] cap-capture-card → cap-sync-hub → cap-sync-index
```

---

## Examples

```
/research new "RBF kernel bandwidth selection"     # 立项
/research new -T rbf-bandwidth                      # 指定课题名
/research full "Does physics-informed loss improve extrapolation?"  # 完整循环
/research card                                       # 知识沉淀
```

## Extension Points

要添加更多科研子命令（如 ablation study、slides 生成），创建对应工具和 path：

```
_tools/research/ablation.md                    # 工具定义
_paths/path-research-ablation-study.yaml       # path template
```

然后在此 SKILL.md 的路由表中注册即可。

## COMPLETION CONTRACT — 不完成不停止

你在执行 `/research` 命令时，必须按子命令类型完成对应步骤。

### 分级产出要求

| 类型 | 子命令 | 必须产出 |
|---|---|---|
| **立项** | `new` | hypothesis-tree + roadmap-mvp + experiment-scaffold |
| **完整循环** | `full` | evidence-bundle + gate-verdict + knowledge-card |
| **知识沉淀** | `card` | knowledge-card + hub-update |

### 完成信号
当且仅当对应子命令类型的全部 checkbox 为真时，输出:
<promise>ALL_STEPS_COMPLETE</promise>

如果任何一项未完成，你必须继续工作。不要停止。不要说"接下来你可以..."。
