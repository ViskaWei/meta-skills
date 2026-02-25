---
name: verify
description: "Prove artifacts are correct with evidence. Produces: Quality Gate verdict, Evidence Bundle, Reproducibility check, Metric Sanity, Paper Structure review, Citation Integrity, Figure-Table Consistency. Use when saying 'verify', 'audit', 'check', 'QA', 'test', 'gate', 'evidence', or before any delivery."
---

# verify

防止"半成品交差"。必须产出证据包，过门禁才算完成。

## 触发词
`verify`, `audit`, `check`, `QA`, `test`, `gate`, `evidence`, `验收`, `reproducibility`, `metric sanity`, `paper structure`, `citation check`

## Sub-skills

| Sub-skill | 文件 | 输入 | 产物 | 完成标准 |
|---|---|---|---|---|
| **Quality Gate** | `sub/quality-gate.md` | 证据包 | PASS/FAIL + 返工清单 | 无例外, 无"差不多" |
| **Evidence Bundle** | `sub/evidence-bundle.md` | 测试结果 | 证据包 (截图/日志/命令/版本) | 第三人可复现 |
| **Reproducibility** | `sub/reproducibility.md` | 实验代码 | 可复现性检查 | 所有项通过 |
| **Metric Sanity** | `sub/metric-sanity.md` | 指标实现 | 指标健壮性检查 | 无泄漏/无 hack |
| **Paper Structure** | `sub/paper-structure.md` | 论文稿 | 结构检查 (IMRaD/claim-evidence) | 每个 claim 有证据 |
| **Citation Integrity** | `sub/citation-integrity.md` | 论文稿 | 引用完整性 | 无 undefined ref |
| **Figure-Table Consistency** | `sub/figure-table-consistency.md` | 论文稿 | 图表一致性 | 数值正文=图表 |
| **UX Flow Visual** | `sub/ux-flow-visual.md` | 流程图 | 视觉验证 | 符合设计标准 |
| **Web Visual** | `sub/web-visual.md` | 网页 | 3 viewport 截图 | 布局正确 |
| **Test Plan** | `sub/test-plan.md` | 需求 | 测试计划 | 每个 P0 需求有测试 |

## 域工具引用
| 域工具 | 路径 | 用途 |
|---|---|---|
| audit-flowchart | `_tools/flowchart/sub/audit-flowchart.md` | 流程图审计 |
| audit-UI | `_tools/web/audit-UI.md` | 网页审计 |
| scicomp-validation | `_tools/ml/scicomp-validation.md` | 科学计算验证 |
| peer-review | `_tools/paper/sub/peer-review.md` | 论文审稿 |
| audit | `_tools/ml/audit.md` | 通用审计 |

## FAIL 行为
Quality Gate FAIL:
1. 自动生成返工任务清单
2. 路由回 Build 阶段
3. **无例外。无"差不多"。**
4. 修复后重新走 Verify

## Gate: Verify → Deliver
**产物**: 证据包 (`artifacts/evidence.md`) + Quality Gate PASS
**要求**: 证据包完整 + Gate 结果 PASS
