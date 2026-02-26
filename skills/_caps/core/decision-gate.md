---
cap_id: cap-decide-gate
verb: decide
object: gate
stage: review
inputs: [evidence-bundle]
outputs: [gate-verdict]
preconditions: []
side_effects: []
failure_modes: []
leveling: G3-V0-P1-M1
---

# review-decision-gate

下一轮决策门：继续加数据？换结构？改任务定义？还是发论文？

## 触发词
`decision gate`, `决策门`, `next round`, `继续还是停`

## 输入
- 实验复盘（来自 `review-exp-retro`）
- 假设树当前状态
- 资源预算剩余（来自 `decide-resource-budget`）

## 产物模板

```markdown
# 决策门: [项目名] — Round [N]
_日期: [YYYY-MM-DD]_

## 当前状态
- 假设通过: [N] / [Total]
- 核心指标: M1 = [value] (target: [target])
- 剩余预算: [hours/GPU-hours]

## 选项评估

### A: 继续当前方向（加数据/调参）
- **预期收益**: [能提升多少]
- **成本**: [需要多少资源]
- **风险**: [可能白费]

### B: 换方法/结构
- **预期收益**: [突破瓶颈可能性]
- **成本**: [重新实现的时间]
- **风险**: [不确定是否更好]

### C: 改任务定义（缩小/放大问题）
- **预期收益**: [更可行的目标]
- **成本**: [重新 Discover/Decide 的时间]
- **风险**: [可能放弃了重要的方向]

### D: 收工写论文（用已有结果）
- **前提**: [已有结果是否够发表]
- **Venue**: [哪里发？标准是什么？]
- **缺口**: [还需要补什么实验/图表]

## 决定
**选择**: [A/B/C/D]
**理由**: [为什么]

## 下一步
→ [对应的 lifecycle stage]
```

## 完成标准
- 至少评估了 3 个选项
- 决定有明确理由
- 下一步可直接执行
