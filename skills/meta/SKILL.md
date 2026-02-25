---
name: meta
description: "技能系统自身的运维与进化 — 健康检查、质量审计、外部融合、熵清理、能力缺口、生命周期管理、回流合并。作用对象是技能架构本身，不是用户制品。Triggers: 'meta', '元', 'harness', 'skill health', 'skill scout', 'skill quality'."
---

# meta

**技能系统的运维中心。** 所有 "作用于技能架构本身" 的操作统一从这里进入。

与其他 L0 的区别：
- `/improve` → 改善**用户制品**（代码、论文、配置）
- `/build -o skill` → **创建**新的 L1/L2/rule
- `/meta` → **维护/进化**已有技能体系（健康、质量、融合、清理、缺口、生命周期、回流）

## 触发词

`meta`, `元`, `harness`, `skill health`, `skill scout`, `skill quality`, `skill lifecycle`, `skill cleanup`, `skill annotate`, `skill gaps`, `探索技能`, `技能健康`

## 语法

```
/meta <sub-command> [target] [flags]
```

## Flags

| Flag | Short | Description | Default |
|---|---|---|---|
| `--goal "..."` | `-g` | 具体目标 | Auto-detect |
| `--target <path>` | `-t` | 作用对象 | 全系统 |
| `--depth fast|standard|deep` | `-d` | 检查深度 | standard |
| `--dry-run` | | 只分析不修改 | off |

## 子命令路由表

| Sub-command | Path | 做什么 |
|---|---|---|
| `health` | `path-general-skill-health` | 6 维健康仪表盘：命名·合约·注册·部署·覆盖·重复 |
| `scout` | `path-general-skill-scout-integrate` | 发现+评估+融合外部 skill 到 3 层架构 |
| `quality <skill>` | `path-general-skill-quality` | 按 skill-creator-standard 审计+修复 |
| `cleanup` | `path-general-entropy-cleanup` | 9 项一致性检查 + 自动修复（熵管理） |
| `lifecycle` | `path-general-skill-lifecycle` | 版本升级 / 废弃 / 晋升 / 归档 |
| `gaps` | `path-general-capability-gap` | 能力缺口诊断：失败信号 → 缺口分类 → 自动补建 |
| `annotate` | `path-general-skill-annotate` | 批量标注缺失 frontmatter 的 L2 block |
| `promote` | `path-general-skill-promote` | 扫描 repo 技能 → 评估 → 合规检查 → 分类放置 → 确认 → 合并 |
| `rule` | `path-standards-session-to-rule` | 从当前 session 提取 rule/policy |

## 共同特征（所有 path）

1. **PAUSE 确认** — 分析后暂停，用户确认方向再执行
2. **Critic Loop** — 不达标不停止（max 3 轮）
3. **无回归** — verify 步骤必须 PASS
4. **知识沉淀** — 最后一步 capture 改进日志

## Router Profile

```yaml
candidate_paths:
  - path-general-skill-health            # /meta health
  - path-general-skill-scout-integrate   # /meta scout
  - path-general-skill-quality           # /meta quality
  - path-general-entropy-cleanup         # /meta cleanup
  - path-general-skill-lifecycle         # /meta lifecycle
  - path-general-capability-gap          # /meta gaps
  - path-general-skill-annotate          # /meta annotate
  - path-general-skill-promote           # /meta promote
  - path-standards-session-to-rule       # /meta rule
default_output: meta-report
default_rules:
  - rule-completion-guard
  - rule-quality-deliverable-minimum
  - rule-improve-verify-result
  - rule-skill-health-gate               # auto-injected when health
  - rule-entropy-cleanup-gate            # auto-injected when cleanup
  - rule-capability-gap-detection        # auto-injected when gaps
  - rule-skill-build-gate                # auto-injected when quality/annotate
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

### `scout` — 发现 + 融合外部 Skill

`path-general-skill-scout-integrate` — 从外部生态搜索 → 5维评估 → 适配 3 层 → 部署。

```
[Define]    define-need (capability gaps)
[Scout]     4 sources: Anthropic official → awesome lists → skills.sh → GitHub
[Evaluate]  5-dim scoring → S/A/B/C rank → confirm (PAUSE)
[Adapt]     determine placement → content adaptation → handle duplicates
[Deploy]    register → setup.sh → verify
[Capture]   scout report
```

**输入模式**:
- `/meta scout` — 全面探索，先扫描当前系统缺口
- `/meta scout "browser automation"` — 按主题搜索
- `/meta scout --input <url>` — 直接导入指定 skill/repo

**6 步 · 3 分支 · Policies**: rule-quality-deliverable-minimum, rule-capability-gap-detection

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

### `lifecycle` — 生命周期管理

`path-general-skill-lifecycle` — 版本升级 / 废弃 / 晋升 / 归档。

```
[Inventory] inventory-skills → classify-maturity
[Confirm]   → confirm-actions (PAUSE)
[Apply]     → apply-actions → update-registry → verify-lifecycle
[Capture]   → capture-result
```

**5 分类**: PROMOTE · STABLE · REVIEW · DEPRECATE · ARCHIVE

**7 步 · 3 分支 · Policies**: rule-improve-verify-result

---

### `annotate` — 批量标注

`path-general-skill-annotate` — 扫描缺失 frontmatter → 自动分类 → 批量标注。

```
[Scan]     scan-unannotated → classify-blocks
[Preview]  → preview-annotations (PAUSE)
[Apply]    → apply-frontmatter → rebuild-index → verify-annotations
[Capture]  → capture-result
```

**7 步 · 4 分支 · Policies**: rule-skill-build-gate

---

### `promote` — 回流合并

`path-general-skill-promote` — 扫描 repo 技能 → 评估 → 合规检查 → 分类放置 → 确认 → 合并。

```
[Scan]      扫描 repo/.claude/skills/ 下所有 .md 文件
[Evaluate]  对比 meta 框架已有 caps → 找出新增/改进的
[Conform]   检查 naming + frontmatter 合规 → 自动修复不合规的
[Classify]  判断放哪一层: L2 cap → _stages/<stage>/sub/ 或 _tools/<family>/
                         L1 path → _paths/
                         Policy → _policies/
[Confirm]   PAUSE — 用户确认哪些要 promote
[Merge]     复制到 meta-skills/ + 更新 registry + index
[Verify]    validate_contracts.sh + setup.sh
[Capture]   promotion log
```

**8 步 · 3 分支 · Policies**: rule-skill-build-gate, rule-improve-verify-result

---

### `rule` — Session → Rule

`path-standards-session-to-rule` — 从当前对话提取 rule/policy。

1. **提取** session 对话历史 → 结构化 brief
2. **导出** 可测试的 acceptance criteria
3. **冲突检查** 对照所有现有 `rule-*.yaml`
4. **草拟** 新 `rule-<scope>-<intent>.yaml` → `_policies/`
5. **部署** `tools/setup.sh` + 验证
6. **沉淀** knowledge card

---

## 与其他 L0 的分工

| 操作 | 入口 | 理由 |
|---|---|---|
| 改善用户代码/配置/文档 | `/improve system` | 作用对象是用户制品 |
| 改善论文 | `/improve paper` | 作用对象是用户制品 |
| 创建新 L1/L2/rule | `/build -o skill` | 创建新的，不是维护已有的 |
| 沉淀知识卡片 | `/capture` | 作用对象是知识，不是技能系统 |
| 维护/进化技能体系 | **`/meta`** | 作用对象是技能架构本身 |

## Examples

```
/meta health                                    # 6维健康仪表盘
/meta health --scope stage:verify               # 只检查 verify 阶段
/meta scout                                     # 全面探索外部 skill 生态
/meta scout "browser automation"                # 按主题搜索
/meta scout --input https://github.com/user/skill-repo  # 直接导入
/meta quality skills/improve/SKILL.md           # 审计单个 skill
/meta cleanup                                   # 全面扫描 + 修复
/meta cleanup --depth fast                      # 快速检查，只报告不修复
/meta gaps                                      # 诊断能力缺口
/meta gaps --scope tools                        # 只检查工具缺口
/meta annotate                                  # 批量标注缺失 frontmatter
/meta annotate --dry-run                        # 预览标注，不实际写入
/meta lifecycle                                 # 全系统生命周期审计
/meta lifecycle --action deprecate --since 90   # 废弃90天无活动的技能
/meta promote                                   # 从 repo 回流技能到 meta-skills
/meta rule                                      # 从当前 session 提取 rule
/meta rule "web deployment must verify external URL"
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
