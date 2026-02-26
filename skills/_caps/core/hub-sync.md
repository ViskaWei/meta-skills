---
cap_id: cap-sync-hub
verb: sync
object: hub
stage: knowledge
inputs: [knowledge-card]
outputs: [sync-report]
preconditions: []
side_effects: []
failure_modes: []
leveling: G3-V1-P1-M1
---

# knowledge-hub-sync

把关键数字、证据链接、假设状态回写 Hub。Hub 的"自动回流"。

## 触发词
`hub sync`, `回写`, `sync hub`, `更新 hub`

## 输入
- 实验复盘（来自 `review-exp-retro`）
- Design Principles（来自 `review-design-principles-extract`）

## 流程

1. **读取当前 Hub**：假设树 + 关键数字
2. **更新假设状态**：待验证 → 已验证/已推翻/搁置
3. **写入关键数字**：实验结果 → Hub 的对应假设
4. **添加证据链接**：指向实验报告/图表/checkpoint
5. **更新 Design Principles**：新发现的原则
6. **版本标记**：Hub v[N] → v[N+1]

## 更新模板

```markdown
## Hub 更新记录

### [YYYY-MM-DD] v[N+1]
- H1: 待验证 → **已推翻** — M1=0.454 > threshold (MVP-1, run3)
- H2: 待验证 → **已验证** — M2=0.87 达标 (MVP-2, run1)
- 新增 DP-5: [原则名称]
- 关键数字更新: best M1 = 0.45, best M2 = 0.87
- 证据链接: `experiments/mvp-1/results/`, `experiments/mvp-2/results/`
```

## 完成标准
- 假设状态与最新实验结论一致
- 关键数字有来源（run ID / experiment ID）
- 证据链接可访问
- Hub 版本号递增

## 后续流向
→ `review-decision-gate`（基于更新后的 Hub 做下一轮决策）
→ `knowledge-card-create`（把新原则变成卡片）
