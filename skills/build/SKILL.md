---
name: build
description: "Build runnable artifacts — routes to specialized build paths. In this core framework, /build is a placeholder for domain-specific build paths (web, code, experiment). Triggers: 'build', '做', 'create', 'scaffold'."
---

# build

Build runnable artifacts. In this core framework, `/build` provides extension points for domain-specific build paths.

> **创建新 skill（L1/L2/rule）？** 使用 `/meta create` — skill 创建已迁移到 `/meta`。

## 触发词

`build`, `做`, `create`, `scaffold`

## 语法

```
/build <description> [--output web|code|experiment] [flags]
```

## Flags

| Flag | Short | Description | Default |
|---|---|---|---|
| `--goal "..."` | `-g` | What to build | From natural language |
| `--output web\|code\|experiment` | `-o` | Output type | Auto-detect |
| `--search` | `-s` | Research best practices before building | off |
| `--depth fast\|standard\|deep` | `-d` | Build thoroughness | standard |

## Extension Points

This core framework provides the build skeleton. Add domain-specific paths:

```
path-webui-build-verify-release      # web app 构建
path-experiment-build-run-verify     # experiment 构建
path-general-scaffold-implement-test # 通用代码构建
```

Register new paths in `skills-registry.yaml` and this SKILL.md routing table.

## Router Profile

```yaml
candidate_paths: []   # Add domain-specific paths here
default_output: delivery-package
default_rules:
  - rule-quality-deliverable-minimum
```

## Process

```
Parse → [Research] → ⭐ Think (PAUSE) → Scaffold → Implement → Verify → Deliver → Capture
```

1. **Parse intent** → detect output type
2. **Research** *(when `--search`)* → scout best practices
3. **Think / Plan** *(PAUSE)* → user confirms approach
4. **Scaffold** → generate project structure
5. **Implement** → build the artifact
6. **Verify** → run tests, quality gates
7. **Deliver** → package with handoff guide
8. **Capture** → knowledge card

## Examples

```
/build "dashboard for experiment results" -o web
/build "data preprocessing pipeline" -o code
/build "ablation study scaffold" -o experiment
```

## COMPLETION CONTRACT — 不完成不停止

你在执行 `/build` 命令时，必须完成以下**全部**步骤才能停止。

### 必须产出
- [ ] delivery-package — 最终交付物 + handoff guide
- [ ] build-log — 结构化变更记录
- [ ] verify-pass — 验证通过

### 完成信号
当且仅当以上全部 checkbox 为真时，输出:
<promise>ALL_STEPS_COMPLETE</promise>

如果任何一项未完成，你必须继续工作。不要停止。不要说"接下来你可以..."。
