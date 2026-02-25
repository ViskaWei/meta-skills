# Path Template — YAML Schema

## Schema

```yaml
id: path-<domain>-<outcome>
name: "<可读名称>"
domain: <domain>
version: 1
outcome: "<从什么 → 到什么>"
steps:
  - id: <步骤名>
    stage: <stage>
    capabilities_needed: [cap-<verb>-<object>]
    output_type: <artifact-type>
    gate_requires: [<upstream-artifact-type>]
branches:
  - from: <step-id>
    condition: "<条件>"
    goto: <step-id>
applicable_policies:
  required: [rule-quality-deliverable-minimum]
  recommended: [rule-<scope>-<intent>]
stop_rules:
  consecutive_failures: 3
  budget_exhausted: "walk to decision-gate"
```

## Domain 词汇

research, paper, repo, webui, docs, data, ops, standards, general

## 注意事项

1. capabilities_needed 填 `step-*` ID，不填文件路径
2. 每步一个 output_type
3. gate_requires 引用上游 output_type
4. 止损规则必填
