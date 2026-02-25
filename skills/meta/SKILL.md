---
name: meta
description: "技能系统自维护 — 健康检查、熵清理、质量审计、能力缺口诊断。作用对象是技能架构本身，不是用户制品。Triggers: 'meta', '元', 'harness', 'skill health', 'skill quality'."
---

# meta

**技能系统的自维护中心。** 所有 "作用于技能架构本身" 的操作从这里进入。

与其他 L0 的区别：
- `/improve` → 改善**用户制品**（代码、论文、配置）
- `/build -o skill` → **创建**新的 L1/L2/rule
- `/meta` → **维护**已有技能体系（健康、清理、质量、缺口）

## 触发词

`meta`, `元`, `harness`, `skill health`, `skill quality`, `skill cleanup`, `skill gaps`

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
| `--dry-run` | | 只分析不修改 | off |

## 子命令路由表

| Sub-command | Path | 做什么 |
|---|---|---|
| `health` | `path-general-skill-health` | 6 维健康仪表盘：命名·合约·注册·部署·覆盖·重复 |
| `cleanup` | `path-general-entropy-cleanup` | 9 项一致性检查 + 自动修复（熵管理） |
| `quality <skill>` | `path-general-skill-quality` | 按 skill-creator-standard 审计+修复 |
| `gaps` | `path-general-capability-gap` | 能力缺口诊断：失败信号 → 缺口分类 → 自动补建 |

## 共同特征（所有 path）

1. **PAUSE 确认** — 分析后暂停，用户确认方向再执行
2. **Critic Loop** — 不达标不停止（max 3 轮）
3. **无回归** — verify 步骤必须 PASS
4. **知识沉淀** — 最后一步 capture 改进日志

## Router Profile

```yaml
candidate_paths:
  - path-general-skill-health            # /meta health
  - path-general-skill-quality           # /meta quality
  - path-general-entropy-cleanup         # /meta cleanup
  - path-general-capability-gap          # /meta gaps
default_output: meta-report
default_rules:
  - rule-completion-guard
  - rule-quality-deliverable-minimum
  - rule-improve-verify-result
  - rule-skill-health-gate               # auto-injected when health
  - rule-entropy-cleanup-gate            # auto-injected when cleanup
  - rule-capability-gap-detection        # auto-injected when gaps
  - rule-skill-build-gate                # auto-injected when quality
```

---

## 各 Path 详解

### `health` — 6 维健康仪表盘

`path-general-skill-health` — 全系统盘点 + 6 维度评分 + 自动修复。

```
[Scan]      inventory → check-naming → check-contracts → check-registry → check-deploy → check-coverage → check-dedup
[Dashboard] → synthesize-dashboard → confirm-fixes (PAUSE)
[Fix]       → apply-fixes → verify-clean
[Capture]   → capture-result
```

| Step | Cap | 做什么 |
|---|---|---|
| inventory-scan | `cap-intake-brief` | 全系统盘点: L0/L1/L2/rule/tool 数量 |
| check-naming | `cap-decide-quality-gate` | 维度1: 命名合规 (verbs + objects) |
| check-contracts | `cap-decide-quality-gate` | 维度2: 合约完整 (frontmatter) |
| check-registry | `cap-decide-quality-gate` | 维度3: 注册一致 (registry <-> index <-> fs) |
| check-deployment | `cap-decide-quality-gate` | 维度4: 部署健康 (setup.sh) |
| check-coverage | `cap-decide-quality-gate` | 维度5: 覆盖缺口 (ghost caps, missing paths) |
| check-dedup | `cap-compare-option-matrix` | 维度6: 重复熵 (path similarity) |
| synthesize-dashboard | `cap-compare-option-matrix` | 6维 Dashboard: 分数 + 状态 + 首要问题 |
| confirm-fixes | `cap-decide-adr` | **PAUSE** — 确认修复范围 |
| apply-fixes | `cap-build-implementation` | 执行确认的修复 |
| verify-clean | `cap-decide-quality-gate` | 重新验证所有维度 |
| capture-result | `cap-capture-card` | 健康报告 + 趋势 |

**12 步 · 3 分支 · Policies**: rule-skill-health-gate, rule-improve-verify-result

---

### `cleanup` — 熵清理

`path-general-entropy-cleanup` — 9 项一致性检查 + 自动修复。

```
[Scan]     run-validators → cross-ref-registry → detect-ghosts → check-stale → entropy-report
[Confirm]  → confirm-fixes (PAUSE)
[Fix]      → auto-fix-det → fix-structural → verify-clean
[Critic]   → critic ──[ITERATE]──→ auto-fix-det
                     ──[PASS]────→ capture
```

**9 项检查**: frontmatter 完整性 · capability-index 漂移 · ghost cap 引用 · duplicate cap_id · 命名规范 · orphan policy · artifact-types 完整性 · stale 文件 · validator 误报

**11 步 · 4 分支 · Policies**: rule-entropy-cleanup-gate

---

### `quality` — 技能质量审计

`path-general-skill-quality` — 按 skill-creator-standard 审计 → 改进 → 部署验证。

```
[Audit]     read-skill → audit-standards → validate-contracts → gap matrix
[Confirm]   → confirm-direction (PAUSE)
[Improve]   → plan → apply → verify-deployment
[Critic]    → critic ──[ITERATE]──→ plan
                      ──[PASS]────→ capture
```

| Step | Cap | 做什么 |
|---|---|---|
| read-skill | `cap-intake-brief` | 阅读技能 + 依赖 |
| audit-standards | `cap-extract-standards-scout` | 对照 skill-creator-standard |
| validate-contracts | `cap-decide-quality-gate` | validate_contracts.sh |
| gap-analysis | `cap-compare-option-matrix` | 差距矩阵 |
| confirm-direction | `cap-decide-adr` | **PAUSE** |
| plan-improvements | `cap-plan-roadmap` | 改进计划 |
| apply-improvements | `cap-build-implementation` | 逐项修改 |
| verify-deployment | `cap-decide-quality-gate` | setup.sh + validate |
| critic-review | `cap-review-improvement` | 命名/合约/注册/部署 |
| capture-result | `cap-capture-card` | 改进日志 |

**11 步 · 4 分支 · Policies**: rule-skill-build-gate, rule-improve-verify-result

---

### `gaps` — 能力缺口诊断

`path-general-capability-gap` — 补能力而非"再试试"。

```
[Collect]  failure-signals → map-landscape → classify-gaps → prioritize
[Confirm]  → confirm-scope (PAUSE)
[Build]    → build-missing-caps → verify-caps
[Critic]   → critic ──[ITERATE]──→ build-missing-caps
                     ──[PASS]────→ capture
```

**缺口四分类**: 工具缺口 · 护栏缺口 · 抽象缺口 · 文档缺口

**9 步 · 4 分支 · Policies**: rule-capability-gap-detection

---

## 与其他 L0 的分工

| 操作 | 入口 | 理由 |
|---|---|---|
| 改善用户代码/配置/文档 | `/improve system` | 作用对象是用户制品 |
| 创建新 L1/L2/rule | `/build -o skill` | 创建新的，不是维护已有的 |
| 完整科研循环 | `/research` | 科研专用 pipeline |
| 维护/进化技能体系 | **`/meta`** | 作用对象是技能架构本身 |

## Examples

```
/meta health                                    # 6维健康仪表盘
/meta health --scope stage:verify               # 只检查 verify 阶段
/meta quality skills/improve/SKILL.md           # 审计单个 skill
/meta cleanup                                   # 全面扫描 + 修复
/meta cleanup --depth fast                      # 快速检查，只报告不修复
/meta gaps                                      # 诊断能力缺口
/meta gaps --scope tools                        # 只检查工具缺口
```

## COMPLETION CONTRACT — 不完成不停止

你在执行 `/meta` 命令时，必须完成以下**全部**步骤才能停止。这不是建议，是强制要求。

### 必须产出
- [ ] gate-verdict — 每轮 verify 步骤产出，最终轮必须 PASS
- [ ] meta-report — 分析报告 + before/after 对比
- [ ] improvement-review — critic 评分

### PAUSE 后恢复规则
当用户确认后恢复执行时，你必须：
1. 重新读取当前 path 的剩余步骤
2. 从 PAUSE 之后的下一步继续，不跳过验收
3. 验收步骤 (verify/critic/capture) 和前面的实现步骤同等重要

### 完成信号
当且仅当以上全部 checkbox 为真时，输出:
<promise>ALL_STEPS_COMPLETE</promise>

如果任何一项未完成，你必须继续工作。不要停止。不要说"接下来你可以..."。

## Routing (via Smart Router)

Read `_tools/router/smart-router.md` for the shared routing algorithm. This skill's router_profile is defined in `skills-registry.yaml` under the `system_commands` section.
