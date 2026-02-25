---
cap_id: cap-map-problem-tree
verb: map
object: problem-tree
stage: discover
inputs: [brief]
outputs: [problem-tree]
preconditions: ["brief or goal statement exists"]
side_effects: ["writes: artifacts/problem-tree.md"]
failure_modes: [too-broad-decomposition, missing-constraints]
leveling: G3-V1-P2-M3
---

# discover-problem-tree

将模糊目标拆解为结构化问题树。

## 触发词
`problem tree`, `问题树`, `问题定义`, `what/why/constraints`

## 输入
用户目标 + Input Manifest（来自 `discover-intake`）

## 产物模板

```markdown
# 问题树: [项目名]

## What — 要解决什么问题？
- 核心问题: [一句话]
- 子问题 1: [具体化]
- 子问题 2: [具体化]
- 子问题 3: [具体化]

## Why — 为什么要解决？
- 对谁有价值: [用户/领域/团队]
- 不解决的后果: [现状的痛点]
- 现有方案的不足: [gap analysis]

## Constraints — 限制条件
- 时间: [deadline]
- 算力: [GPU/CPU 可用资源]
- 数据: [数据量/质量/可获取性]
- 知识: [需要但目前缺少的 domain knowledge]
- 工具: [必须用/不能用的工具/框架]

## Success Metrics — 怎么算"解决了"？
| 指标 | 当前值 | 目标值 | 测量方法 |
|---|---|---|---|
| [metric] | [baseline] | [target] | [how] |

## 非目标（明确排除）
- [NOT doing this]
- [NOT doing that]

## 开放问题
- [还不确定的事情]
```

## 完成标准
- What/Why/Constraints/Metrics 四个维度都有具体内容
- Success Metrics 有 baseline 和 target（可测量）
- 非目标至少 2 条
- 第三人读完后能重述问题定义
