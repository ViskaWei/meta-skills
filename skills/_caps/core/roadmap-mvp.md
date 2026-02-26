---
cap_id: cap-plan-roadmap
verb: plan
object: roadmap
stage: decide
inputs: [hypothesis-tree, metrics-contract]
outputs: [roadmap-mvp]
preconditions: ["hypothesis tree and metrics contract exist"]
side_effects: ["writes: artifacts/roadmap.md"]
failure_modes: [mixed-hypotheses-in-mvp, missing-stop-loss]
leveling: G3-V1-P2-M3
---

# decide-roadmap-mvp

把假设树变成最小成本可证伪实验（MVP）列表，带止损规则。Roadmap 的核心。

## 触发词
`roadmap`, `mvp`, `实验计划`, `roadmap-mvp`

## 输入
假设树（来自 `discover-hypothesis-tree`）+ 评估口径（来自 `discover-metrics-contract`）

## 流程

1. **遍历假设树**：按优先级顺序
2. **为每条假设设计 MVP**：最低成本验证该假设的实验
3. **定义验收阈值**：用 metrics-contract 里的阈值
4. **设定止损规则**：什么条件下放弃这条路
5. **估算成本**：GPU-hours / 人-hours / wall-clock time

## 产物模板

```markdown
# Roadmap MVP: [项目名]
_来源: 假设树 [link]_
_评估口径: metrics-contract v[x]_

## MVP 实验列表

### MVP-1: 验证 H[x] — [一句话描述]
- **假设**: [H[x] 的陈述]
- **实验方案**: [最小可行实验——不是"调到最好"，是"最快知道行不行"]
- **关键变量**: [只改这一个变量]
- **对照组**: [baseline / ablation]
- **预期信号**: [如果假设为真，应该看到 metric > threshold]
- **验收阈值**: [metric ≥ X = 通过，< Y = 推翻]
- **止损规则**:
  - 如果 [condition] → 放弃该假设，跳到 MVP-[next]
  - 如果 [condition] → 降级为辅助信号，不作为主要贡献
- **成本**: [GPU-hours] / [wall-clock estimate]
- **依赖**: [需要先完成 MVP-? 的结果]

### MVP-2: 验证 H[y]
...

## 执行顺序
```
MVP-1 ──→ [Pass?] ──→ MVP-3
              │
              └─[Fail]──→ MVP-2 ──→ [Pass?] ──→ MVP-4
                                        │
                                        └─[Fail]──→ 退回 Discover
```

## 全局止损
- 连续 [N] 个 MVP 全部 Fail → 退回 `discover-problem-tree` 重新定义问题
- 总时间超过 [X hours] 且无 Pass → 暂停，走 `review-decision-gate`
- 总成本超过 [Y GPU-hours] → 走 `decide-resource-budget` 重新评估

## 产物目录
```
artifacts/
  roadmap.md          ← 本文件
  mvp-1/              ← 每个 MVP 的实验文件夹
    config.yaml
    run.sh
    results/
  mvp-2/
    ...
```
```

## 完成标准
- 每个 MVP 只验证一条假设（不混合）
- 止损规则是具体条件（不是"感觉不好就停"）
- 执行顺序有依赖图
- 有全局止损规则

## 门禁
**Roadmap 是 Build 的前置条件。没有 Roadmap = 不允许开始 Build。**

## 后续流向
→ `build-scaffold`（搭建实验框架）
→ `verify-quality-gate`（止损规则由 quality-gate 执行）
