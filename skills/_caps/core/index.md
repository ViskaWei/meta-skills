---
cap_id: cap-sync-index
verb: sync
object: index
stage: knowledge
inputs: [knowledge-card]
outputs: [index-entry]
preconditions: ["knowledge card exists"]
side_effects: ["updates: knowledge index"]
failure_modes: [missing-tags, duplicate-entry]
leveling: G3-V1-P2-M3
---

# knowledge-index

索引与标签系统：让知识可检索、可复用。

## 触发词
`index`, `索引`, `tag`, `打标签`

## 功能

为知识卡片、论文笔记、实验报告打标签，建立可检索的索引。

## 标签体系

```markdown
# Knowledge Index

## 按任务分类
- `task:classification` — 分类任务
- `task:regression` — 回归任务
- `task:generation` — 生成任务
- `task:inverse-problem` — 逆问题

## 按方法分类
- `method:nn` — 神经网络
- `method:rbf` — 径向基函数
- `method:bayesian` — 贝叶斯方法
- `method:physics-informed` — 物理信息方法

## 按领域分类
- `domain:astro` — 天文
- `domain:ips` — 相互作用粒子系统
- `domain:spectra` — 光谱
- `domain:ml` — 机器学习

## 按类型分类
- `type:paper-note` — 论文笔记
- `type:exp-retro` — 实验复盘
- `type:design-principle` — 设计原则
- `type:knowledge-card` — 知识卡片
- `type:anti-pattern` — 反模式

## 按状态分类
- `status:active` — 正在使用
- `status:archived` — 已归档
- `status:superseded` — 已被替代
```

## 索引条目格式

```markdown
| ID | 标题 | 标签 | 创建日期 | 路径 |
|---|---|---|---|---|
| KC-001 | [title] | `task:X` `method:Y` | 2026-02-22 | knowledge/KC-001.md |
```

## 完成标准
- 每个知识产物有唯一 ID
- 至少 2 个标签（任务 + 方法 or 领域 + 类型）
- 路径可直接访问
