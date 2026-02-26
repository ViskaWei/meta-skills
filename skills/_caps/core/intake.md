---
cap_id: cap-intake-brief
verb: intake
object: brief
stage: discover
inputs: [url, file-path, goal-statement]
outputs: [intake-manifest]
preconditions: []
side_effects: ["writes: artifacts/intake-manifest.md"]
failure_modes: [source-inaccessible, ambiguous-goal]
leveling: G3-V0-P2-M3
---

# discover-intake

记录输入源并建立 Input Manifest，确保所有原始材料可追溯。

## 触发词
`intake`, `输入`, `来源`, `收集材料`

## 输入
用户目标 + 任意输入源（arXiv URL / PDF / Repo / 笔记 / 截图 / 数据集链接）

## 流程

1. **收集所有输入源**：URL、文件路径、截图、口头描述
2. **验证可用性**：链接是否可访问、文件是否存在、数据是否可读
3. **记录元信息**：版本、时间戳、大小、格式
4. **分类**：论文 / 代码 / 数据 / 文档 / 其他
5. **输出 Input Manifest**

## 产物模板

```markdown
# Input Manifest
_Created: [YYYY-MM-DD HH:MM]_
_Goal: [一句话目标]_

## 输入源清单

| # | 类型 | 来源 | 版本/时间戳 | 状态 | 备注 |
|---|---|---|---|---|---|
| 1 | 论文 | [arXiv URL] | v2, 2026-01 | ✅ 可访问 | 主论文 |
| 2 | 代码 | [GitHub URL] | commit abc123 | ✅ 可克隆 | 官方实现 |
| 3 | 数据 | [path/to/data] | 2000 samples | ✅ 可读 | shape (2000,100,10,2) |
| 4 | 截图 | [path/to/img] | — | ✅ 存在 | 用户标注的关键图 |

## 缺失/风险
- [可能需要但还没拿到的材料]
- [链接可能过期的风险]

## 下一步
→ `discover-literature-skim` 或 `discover-problem-tree`
```

## 完成标准
- 每个输入源有类型、来源、版本、状态
- 缺失材料明确标注
- 第三人可从 manifest 找到所有原始材料
