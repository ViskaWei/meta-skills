---
cap_id: cap-extract-retro
verb: extract
object: retro
stage: review
inputs: [gate-verdict]
outputs: [experiment-retro]
preconditions: ["experiment results available"]
side_effects: ["writes: artifacts/retro.md"]
failure_modes: [missing-hypothesis-tree, vague-failure-analysis]
leveling: G3-V1-P2-M3
---

# review-exp-retro

实验复盘：失败原因、信号强弱、下一步建议。科研场景的 postmortem。

## 触发词
`retro`, `复盘`, `exp retro`, `实验复盘`

## 输入
- 实验汇总（来自 `operate-experiment-tracker`）
- 假设树 + Roadmap（Discover/Decide 产物）

## 产物模板

```markdown
# 实验复盘: [MVP-X / 假设 H-Y]
_日期: [YYYY-MM-DD]_

## 一句话结论
[这轮实验证明了/推翻了/未能确定 什么]

## 结果摘要
| 指标 | 预期 | 实际 | 差距 | 判定 |
|---|---|---|---|---|
| M1 | < 0.40 | 0.454 | +0.054 | 未达标 |

## 信号分析
- **强信号**: [哪些结果是确定的，不太可能翻转]
- **弱信号**: [哪些结果不确定，可能是 noise]
- **无信号**: [哪些实验没有产出有意义的信息]

## 失败原因分析（如适用）
1. **根本原因**: [e.g., 损失函数有退化最小值]
2. **贡献因素**: [e.g., 数据噪声太大，信号被淹没]
3. **排除因素**: [e.g., 不是 bug / 不是超参数问题]

## 假设树更新
| 假设 | 状态变化 | 证据 |
|---|---|---|
| H1 | 待验证 → 已推翻 | M1 > threshold in all runs |
| H2 | 待验证 → 待验证 | 信号太弱，需要更多数据 |

## 下一步建议
| 优先级 | 建议 | 理由 | 估计成本 |
|---|---|---|---|
| P0 | [action] | [why] | [hours] |
| P1 | [action] | [why] | [hours] |

## 是否触发止损？
- [ ] 连续 N 个 MVP Fail → **退回 Discover**
- [ ] 当前假设全部推翻 → **退回 Problem Tree**
- [ ] 有新假设浮现 → **更新假设树，走 Decide**
```

## 完成标准
- 每个假设有明确状态更新
- 失败原因是具体的（不是"效果不好"）
- 下一步建议可直接输入到 Decide
