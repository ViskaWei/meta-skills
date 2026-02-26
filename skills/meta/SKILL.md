---
name: meta
description: "技能系统自维护 — 4 个子命令: check（健康检查+编目）、create（创建 L1/L2/rule）、improve（技能增强）、grow（发现+安装）。作用对象是技能架构本身。Triggers: 'meta', '元', 'harness', 'skill health', 'skill check', 'skill create', 'grow', 'catalog'."
---

# meta

**技能系统的自维护中心。** 所有 "作用于技能架构本身" 的操作从这里进入。

与其他 L0 的区别：
- `/build` → **构建**用户制品（web app、代码、实验）
- `/meta create` → **创建**新的 L1/L2/rule（元操作）
- `/meta` → **维护/进化**已有技能体系

## 触发词

`meta`, `元`, `harness`, `skill health`, `skill check`, `skill create`, `skill quality`, `skill cleanup`, `skill gaps`, `grow`, `catalog`

## 语法

```
/meta <sub-command> [target] [flags]
```

## Flags

| Flag | Short | Description | Default |
|---|---|---|---|
| `--goal "..."` | `-g` | 具体目标 | Auto-detect |
| `--target <path>` | `-t` | 作用对象 | 全系统 |
| `--depth fast\|standard\|deep` | `-d` | 检查深度 | standard |
| `--scope <dimension>` | | 指定检查维度（仅 check 有效） | all |
| `--dry-run` | | 只分析不修改 | off |

## 子命令路由表（4 个用户可调）

| Sub-command | 做什么 |
|---|---|
| `check` | 全系统健康检查 + 编目 — agent 自动选择检查维度 |
| `create <type>` | 创建新 L1/L2/rule；无参数时从 session 提取 rule |
| `improve <skill>` | 技能质量增强（标准审计 + 修复） |
| `grow` | 发现 + 安装外部 skill |

## 共同特征（所有 path）

1. **PAUSE 确认** — 分析后暂停，用户确认方向再执行
2. **Critic Loop** — 不达标不停止（max 3 轮）
3. **无回归** — verify 步骤必须 PASS
4. **知识沉淀** — 最后一步 capture 改进日志

## Router Profile

```yaml
candidate_paths:
  - path-general-skill-health            # check 内部
  - path-general-skill-quality           # improve
  - path-general-entropy-cleanup         # check 内部
  - path-general-capability-gap          # check 内部
default_output: meta-report
default_rules:
  - rule-completion-guard
  - rule-quality-deliverable-minimum
  - rule-improve-verify-result
  - rule-skill-health-gate               # auto-injected when health
  - rule-entropy-cleanup-gate            # auto-injected when cleanup
  - rule-capability-gap-detection        # auto-injected when gaps
  - rule-skill-build-gate                # auto-injected when quality/create
```

---

## `check` — 全系统健康检查

Agent 根据 `--depth` 和 `--scope` 自动组合检查维度。

| 维度 | Path | 做什么 |
|---|---|---|
| `health` | `path-general-skill-health` | 6 维健康仪表盘 |
| `cleanup` | `path-general-entropy-cleanup` | 9 项一致性检查 + 自动修复 |
| `gaps` | `path-general-capability-gap` | 能力缺口诊断 |

- `--depth fast` → 只跑 health + cleanup
- `--depth standard` → 全部维度（默认）
- `--scope health` → 只跑指定维度

---

## `create` — 创建新 L1/L2/rule

创建流程：Build → Test → Capture（3 步强制）。

| 类型 | 命名 | 存放 |
|---|---|---|
| L1 路径模板 | `path-<domain>-<outcome>` | `_paths/<id>.yaml` |
| L2 原子能力 | `cap-<verb>-<object>` | `_stages/<stage>/sub/<action>.md` |
| Cross-cutting 规则 | `rule-<scope>-<intent>` | `_policies/<id>.yaml` |

```
/meta create cap <verb> <object>        → L2 原子能力
/meta create path <domain> <outcome>    → L1 路径模板
/meta create rule <scope> <intent>      → Cross-cutting 规则
/meta create rule                       → 从当前 session 提取 rule
```

---

## `improve` — 技能增强

`path-general-skill-quality` — 按 skill-creator-standard 审计 + 修复。

```
/meta improve skills/meta/SKILL.md             # 审计+增强单个 skill
/meta improve skills/meta/SKILL.md -d fast     # 快速审计
```

---

## `grow` — 发现 + 安装外部 Skill

Extension point. The private overlay adds full grow pipeline with 10-source scanning.

```
/meta grow                                     # 完整流水线
/meta grow "topic"                             # 按主题搜索
/meta grow --scan-only                         # 只扫描不安装
```

---

## Examples

```
/meta check                                    # 标准健康检查
/meta check --depth fast                       # 快速检查
/meta check --scope health                     # 只跑健康检查
/meta create cap extract metrics               # 创建 L2
/meta create path research ablation            # 创建 L1
/meta create rule quality naming-lint          # 创建规则
/meta create rule                              # 从 session 提取 rule
/meta improve skills/build/SKILL.md            # 审计+增强
/meta grow                                     # 自动增长
```

## COMPLETION CONTRACT — 不完成不停止

你在执行 `/meta` 命令时，必须完成以下**全部**步骤才能停止。

### 必须产出
- [ ] gate-verdict — 每轮 verify 步骤产出，最终轮必须 PASS
- [ ] meta-report — 分析报告 + before/after 对比
- [ ] improvement-review — critic 评分

### 完成信号
当且仅当以上全部 checkbox 为真时，输出:
<promise>ALL_STEPS_COMPLETE</promise>

如果任何一项未完成，你必须继续工作。不要停止。不要说"接下来你可以..."。

## Routing (via Smart Router)

Read `_tools/router/smart-router.md` for the shared routing algorithm. This skill's router_profile is defined in `skills-registry.yaml` under the `system_commands` section.
