---
name: improve
description: "改善已有制品 — 研究最佳实践 → 差距分析 → 改进 → critic 审查。Triggers: 'improve', '完善', 'polish', 'enhance', 'refine'."
---

# improve

完善打磨已有的东西。不是修 bug（那是 `/fix`），而是让**能用的东西变更好**。

与其他 L0 的区别：
- `/meta` → 维护**技能架构**本身
- `/fix` → 修复**不达标**的东西
- `/improve` → 改善**已能用**的制品

## 触发词

`improve`, `完善`, `polish`, `enhance`, `refine`

## 语法

```
/improve [target] [flags]
```

## Flags

| Flag | Short | Description | Default |
|---|---|---|---|
| `--goal "..."` | `-g` | 改进方向 | Auto-detect |
| `--target <path>` | `-t` | 要改进的文件/目录 | Required |
| `--depth fast\|standard\|deep` | `-d` | 改进深度 | standard |
| `--mode loop\|ratchet` | `-m` | 改进模式 | loop |

## 路由表

| Mode | Path | 做什么 |
|---|---|---|
| `loop` (default) | `path-general-improve-loop` | 研究驱动改进循环：搜索最佳实践 → 差距分析 → 改进 → critic |
| `ratchet` | `path-general-ratchet-loop` | 质量爬坡：check → fix → re-check until PASS |

## 共同特征

1. **PAUSE 确认** — 分析后暂停，用户确认方向再执行
2. **Critic Loop** — 不达标不停止（max 3 轮）
3. **无回归** — verify 步骤必须 PASS
4. **知识沉淀** — 最后一步 capture 改进日志

## Router Profile

```yaml
candidate_paths:
  - path-general-improve-loop        # /improve (default)
  - path-general-ratchet-loop        # /improve --mode ratchet
default_output: improvement-log
default_rules:
  - rule-quality-deliverable-minimum
  - rule-improve-verify-result
  - rule-completion-guard
```

---

## Path A: `loop` — 研究驱动改进

`path-general-improve-loop` — 最佳实践导向，适合任何制品。

```
[Research]  read → search best practices → gap matrix
[Confirm]   → confirm-direction (PAUSE)
[Execute]   → plan → apply → verify
[Critic]    → critic ──[ITERATE]──→ plan
                      ──[PASS]────→ capture
```

| Step | Cap | 做什么 |
|---|---|---|
| read-current | `cap-intake-brief` | 深度阅读 |
| research-best-practices | `cap-extract-standards-scout` | 搜索行业最佳实践 |
| gap-analysis | `cap-compare-option-matrix` | 差距矩阵 |
| confirm-direction | `cap-decide-adr` | **PAUSE** |
| plan-improvements | `cap-plan-roadmap` | 排优先级 |
| apply-improvements | `cap-build-implementation` | 逐项改进 |
| verify-changes | `cap-decide-quality-gate` | 回归检测 |
| critic-review | `cap-review-improvement` | 6维打分 |
| capture-result | `cap-capture-card` | 改进日志 |

**9 步 · 4 分支 · Policies**: rule-improve-verify-result, rule-quality-deliverable-minimum

---

## Path B: `ratchet` — 质量爬坡

`path-general-ratchet-loop` — check → fix → re-check，直到 PASS 或达到上限。

```
[Check]     → check-current
[Fix]       → plan → apply
[Re-check]  → re-check ──[FAIL]──→ plan (max 5 轮)
                        ──[PASS]──→ capture
```

| Step | Cap | 做什么 |
|---|---|---|
| check-current | `cap-decide-quality-gate` | 运行所有检查 |
| plan-improvements | `cap-plan-roadmap` | 分析失败，计划修复 |
| apply-fixes | `cap-build-implementation` | 执行修复 |
| re-check | `cap-decide-quality-gate` | 重新检查 |
| capture-result | `cap-capture-card` | 记录改进日志 |

**5 步 · 3 分支 · max 5 iterations**

---

## Extension Points

要添加更多改进模式（如论文优化、repo 整合），创建对应的 path：

```
path-paper-improve-submission         # 论文投稿优化
path-general-repo-consolidation       # 多仓库整合
```

然后在此 SKILL.md 的路由表中注册即可。

## Examples

```
/improve src/api/ --goal "error handling" --depth deep
/improve README.md --goal "clearer onboarding"
/improve --mode ratchet src/ --goal "type safety"
```

## COMPLETION CONTRACT — 不完成不停止

你在执行 `/improve` 命令时，必须完成以下**全部**步骤才能停止。

### 必须产出
- [ ] gate-verdict — 每轮 verify 步骤产出，最终轮必须 PASS
- [ ] improvement-log — before/after 对比 + remaining gaps
- [ ] improvement-review — critic 评分

### 完成信号
当且仅当以上全部 checkbox 为真时，输出:
<promise>ALL_STEPS_COMPLETE</promise>

如果任何一项未完成，你必须继续工作。不要停止。不要说"接下来你可以..."。
