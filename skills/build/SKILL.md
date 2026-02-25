---
name: build
description: "按 3 层架构创建新 skill — L1 path、L2 capability、cross-cutting rule。Triggers: 'build', '做', 'create', 'scaffold', 'skill'."
---

# build

按 3 层架构创建新 skill，是框架扩展的入口。

与其他 L0 的区别：
- `/meta` → **维护**已有技能体系
- `/improve` → **改善**已有制品
- `/build` → **创建**新制品（本框架专注 skill 创建）

## 触发词

`build`, `做`, `create`, `scaffold`, `skill`

## 语法

```
/build <description> [--output skill] [flags]
```

## Flags

| Flag | Short | Description | Default |
|---|---|---|---|
| `--goal "..."` | `-g` | What to build | From natural language |
| `--output skill` | `-o` | Output type (skill for L1/L2/rule) | skill |
| `--search` | `-s` | Research best practices before building | off |
| `--depth fast\|standard\|deep` | `-d` | Build thoroughness | standard |

## Skill Creation Mode

> **Policy**: `rule-skill-build-gate` — 自动注入，不可跳过

### 允许的类型

| 类型 | Layer | 命名 | 存放 |
|---|---|---|---|
| 路径模板 | L1 | `path-<domain>-<outcome>` | `_paths/<id>.yaml` |
| 原子能力 | L2 | `cap-<verb>-<object>` | `_stages/<stage>/sub/<action>.md` |
| 质检规则 | cross | `rule-<scope>-<intent>` | `_policies/<id>.yaml` |

### 创建流程

```
Parse → [Research] → ⭐ Think (PAUSE) → Scaffold → Implement → Verify → Capture
```

1. **Parse intent** → 检测要创建什么类型的 skill
2. **Research** *(when `--search`)* → 搜索同类 skill 的最佳实践
3. **Think / Plan** *(PAUSE)* → 设计方案，用户确认后开始
4. **Scaffold** → 按 `_standards/skill-creator-standard/` 创建骨架
5. **Implement** → 填写内容：frontmatter、流程、模板
6. **Verify** → `bash tools/setup.sh` + `bash tools/validate_contracts.sh`
7. **Capture** → 知识卡片

### 注册清单

创建完成后必须更新：
1. `skills-registry.yaml` — cap_id, input/output_types, policies, leveling
2. `_resolver/capability-index.yaml` — cap-* → block file mapping
3. `bash tools/setup.sh` — 部署验证

## Router Profile

```yaml
skill_standard: _standards/skill-creator-standard/SKILL.md
default_output: skill-artifact
default_rules:
  - rule-quality-deliverable-minimum
  - rule-skill-build-gate
```

## Extension Points

此框架的 `/build` 专注于 skill 创建。要添加其他构建能力（如 web app、experiment），创建对应的 path template：

```
path-webui-build-verify-release      # web app 构建
path-experiment-build-run-verify     # experiment 构建
path-general-scaffold-implement-test # 通用代码构建
```

然后在此 SKILL.md 的路由表中注册即可。

## Examples

```
/build -o skill cap extract metrics          # 创建 L2 原子能力
/build -o skill path research ablation       # 创建 L1 路径模板
/build -o skill rule quality naming-lint     # 创建 cross-cutting 规则
/build "experiment tracking capability" -s   # 搜索最佳实践后创建
```

## COMPLETION CONTRACT — 不完成不停止

你在执行 `/build` 命令时，必须完成以下**全部**步骤才能停止。

### 必须产出
- [ ] skill-artifact — 创建的 L1/L2/rule 文件
- [ ] registry-update — skills-registry.yaml 和 capability-index.yaml 已更新
- [ ] verify-pass — setup.sh + validate_contracts.sh PASS

### 完成信号
当且仅当以上全部 checkbox 为真时，输出:
<promise>ALL_STEPS_COMPLETE</promise>

如果任何一项未完成，你必须继续工作。不要停止。不要说"接下来你可以..."。
