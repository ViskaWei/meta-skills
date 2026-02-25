# 命名规范 — 3-Layer Architecture

## 受控动词表（18 个）

| 动词 | 含义 | 常见阶段 |
|---|---|---|
| intake | 接收输入 | discover |
| extract | 提取信息 | discover |
| map | 结构化映射 | discover |
| compare | 比较选项 | decide |
| decide | 做出决策 | decide |
| plan | 制定计划 | decide |
| scaffold | 搭建框架 | build |
| build | 构建实现 | build |
| render | 渲染输出 | build |
| assemble | 组装证据 | verify |
| check | 检查验证 | verify |
| package | 打包交付 | deliver |
| publish | 发布 | deliver |
| track | 跟踪监控 | operate |
| triage | 分类处理 | operate |
| review | 审查回顾 | review |
| capture | 捕获知识 | knowledge |
| sync | 同步回流 | knowledge |

## 域词汇表（path-* 专用）

`research`, `paper`, `repo`, `webui`, `docs`, `data`, `ops`, `standards`, `general`

## Lint 规则

1. **kebab-case**: `cap-extract-brief` ✅ / `step_discover_extractBrief` ✗
2. **3-6 tokens**: `cap-extract-brief` (4) ✅ / `cap-extract-and-validate-hypothesis-tree` (7) ✗
3. **受控动词**: `render` ✅ / `create` ✗
4. **8 阶段**: discover, decide, build, verify, deliver, operate, review, knowledge
5. **不含实现细节**: `cap-render-flowchart` ✅ / `cap-render-d2-flowchart-svg` ✗
6. **前缀**: step- / path- / rule- / run-

## 快速检查公式

```
ID = <prefix>-<scope>-<verb>-<object>[-<qualifier>]
```
