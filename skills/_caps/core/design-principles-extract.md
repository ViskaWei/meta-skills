---
cap_id: cap-extract-design-principles
verb: extract
object: design-principles
stage: review
inputs: [experiment-results, evidence-bundle]
outputs: [design-principles]
preconditions: []
side_effects: []
failure_modes: []
leveling: G2-V1-P1-M1
---

# review-design-principles-extract

从实验中提炼可复用的 Design Principles（Do & Don't）。

## 触发词
`design principles`, `设计原则`, `do dont`, `extract principles`

## 输入
- 实验复盘（来自 `review-exp-retro`）
- 多轮实验的累积经验

## 产物模板

```markdown
# Design Principles: [领域/项目]
_版本: v[X]_
_来源: [哪些实验/项目]_

## Principles

### DP-[N]: [原则名称]
- **Do**: [推荐做法]
- **Don't**: [反模式]
- **Why**: [原理/证据]
- **Evidence**: [哪个实验证明了这一点]
- **适用条件**: [什么情况下适用]
- **例外**: [什么情况下不适用]

### DP-[N+1]: [原则名称]
...

## Anti-Patterns（已知反模式）
| # | 反模式 | 后果 | 来源 |
|---|---|---|---|
| AP-1 | [description] | [what goes wrong] | [experiment] |
```

## 完成标准
- 每条原则有 Do/Don't/Why/Evidence
- 有适用条件（不是普适真理）
- 反模式有具体后果

## 后续流向
→ `knowledge-card-create`（变成可检索的卡片）
→ `knowledge-hub-sync`（回写 Hub）
