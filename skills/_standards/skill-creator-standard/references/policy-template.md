# Policy Template — YAML Schema

## Schema

```yaml
id: rule-<scope>-<intent>
name: "<可读名称>"
version: 1
triggers:
  output_types: [<artifact-type>]
evidence_requirements:
  - type: <evidence-type>
    command: "<命令>"
    required: true
gate_criteria:
  - "<标准>"
injection_point:
  before_step: quality-gate
  verify_capabilities: [cap-check-<specific>]
```

## 已有 Policy

| ID | 触发 | 用途 |
|---|---|---|
| rule-quality-deliverable-minimum | * | 基线质量 |
| rule-webui-visual-regression | web-page | 视觉回归 |
| rule-paper-structure-integrity | paper-draft | 论文结构 |
| rule-research-reproducibility | model-checkpoint | 可复现性 |
| rule-standards-source-trust | standards-pack | 来源可信 |

## 设计原则

1. 一个 Policy 一个关切
2. triggers 精确匹配
3. evidence 可执行
4. gate_criteria 可判定
