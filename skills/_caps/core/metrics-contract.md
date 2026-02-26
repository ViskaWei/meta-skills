---
cap_id: cap-extract-metrics-contract
verb: extract
object: metrics-contract
stage: discover
inputs: [hypothesis-tree]
outputs: [metrics-contract]
preconditions: ["hypothesis tree exists"]
side_effects: ["writes: artifacts/metrics-contract.md"]
failure_modes: [ambiguous-metric-definition, missing-baseline]
leveling: G3-V1-P2-M3
---

# discover-metrics-contract

定义评估口径：指标定义 + 计算细节 + 阈值草案。防止"指标 hack"和"口径不一致"。

## 触发词
`metrics`, `评估口径`, `指标定义`, `metrics contract`

## 输入
问题树的 Success Metrics + 假设树的证据类型

## 产物模板

```markdown
# 评估口径: [项目名]
_版本: v1.0_
_冻结日期: [一旦进入 Build 阶段，口径不可随意更改]_

## 主要指标

### M1: [指标名称]
- **定义**: [精确的数学/逻辑定义]
- **计算公式**: `[formula or code snippet]`
- **输入**: [什么数据参与计算]
- **输出范围**: [值域, e.g., [0, 1], lower is better]
- **Baseline**: [当前最好的值 + 来源]
- **Target**: [目标值 + 达到条件]
- **阈值草案**:
  - 显著提升: > [value]
  - 基本达标: > [value]
  - 不可接受: < [value]
- **已知陷阱**:
  - [e.g., 该指标在某种条件下会虚高]
  - [e.g., 需要对 [X] 做归一化才有意义]

### M2: [指标名称]
...

## 辅助指标（监控用，不做门禁判断）
| 指标 | 定义 | 用途 |
|---|---|---|
| [metric] | [definition] | [why track it] |

## 数据泄漏检查清单
- [ ] Train/Val/Test 严格分离？
- [ ] 指标计算只用 Test set？
- [ ] 有无 look-ahead bias？
- [ ] 有无 label leakage？

## 口径变更规则
- Build 阶段开始后，指标定义冻结
- 如需变更，必须写 ADR 并重新走 Decide
- 变更前后的结果都要保留（不允许只留"好看的"）
```

## 完成标准
- 每个指标有精确定义（第三人可独立实现得到相同结果）
- 阈值有梯度（不是只有 pass/fail）
- 已知陷阱至少列 1 条
- 数据泄漏检查清单完成
