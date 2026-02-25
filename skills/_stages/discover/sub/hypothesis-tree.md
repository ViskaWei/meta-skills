---
cap_id: cap-map-hypothesis-tree
verb: map
object: hypothesis-tree
stage: discover
inputs: [goal-statement]
outputs: [hypothesis-tree]
preconditions: []
side_effects: []
failure_modes: []
leveling: G2-V1-P1-M1
---

# discover-hypothesis-tree

从问题树生成可证伪假设树——Hub 的核心产物。

## 触发词
`hypothesis`, `假设树`, `hypothesis tree`, `hub`

## 输入
问题树（来自 `discover-problem-tree`）

## 流程

1. **从每个子问题生成假设**：每个子问题至少 2 条可证伪假设
2. **标注证据类型**：每条假设需要什么类型的证据来验证/推翻
3. **排优先级**：按 (信息增量 × 成本^-1) 排序
4. **标注依赖**：哪些假设依赖其他假设的结论

## 产物模板

```markdown
# 假设树: [项目名]
_来源: 问题树 [link]_
_更新: [YYYY-MM-DD]_

## 假设列表

### H1: [假设陈述，必须可证伪]
- **证伪条件**: [什么实验结果能推翻这个假设]
- **证据类型**: [需要什么数据/实验/分析]
- **预期信号**: [如果为真，应该看到什么]
- **成本估计**: [GPU-hours / 人-hours / 数据需求]
- **优先级**: P0 / P1 / P2
- **依赖**: [依赖其他假设？哪个？]
- **状态**: 待验证 / 已验证 / 已推翻 / 搁置

### H2: [假设陈述]
...

### H3: [假设陈述]
...

## 假设依赖图
```
H1 ──→ H3（H1 为真才需要验 H3）
H2 ──→ H4
```

## 优先级排序（推荐验证顺序）
1. H[x] — [理由：信息增量最大/成本最低]
2. H[y] — [理由]
3. H[z] — [理由]

## 止损规则
- 如果 H[x] 被推翻 → 不再验证 H[y], H[z]
- 如果前 3 条假设全部推翻 → 退回 Discover 重新定义问题
```

## 完成标准
- 每条假设有明确的证伪条件（不是"看看效果"）
- 证据类型具体（不是"做实验"）
- 有优先级排序和依赖关系
- 有止损规则
- 可直接输入到 `decide-roadmap-mvp`

## 后续流向
→ `decide-roadmap-mvp`（假设 → 实验计划）
→ `knowledge-hub-sync`（回写 Hub）
