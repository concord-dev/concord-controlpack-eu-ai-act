# Every high-risk AI system has a documented human-oversight runbook

`EU-AIAct-Article14` · framework **eu-ai-act** · severity **high** · Provider obligations

## What this control checks

EU AI Act Article 14 requires high-risk AI systems to be designed
so they can be effectively overseen by natural persons during the
period the system is in use. Concord enforces a documented human
oversight runbook at docs/ai/oversight/<model>.md for every
high-risk production model. The runbook must declare the
overseer roles, capability/limitation summary, and kill-switch
procedure.

## Why it matters

Most failures of high-risk AI come not from the model itself but
from operator confusion about its capabilities and from missing
intervention procedures. A versioned, named runbook is the
minimum-viable artifact an auditor will accept as evidence that
human oversight has been operationalized rather than merely
documented as a policy aspiration.

## Evidence

Collected from the `mlflow` source (`model_registry` evidence type).

## What a failure looks like

This control reports a finding when any of the following hold:

- no model registry evidence collected
- high-risk model <value> has no oversight runbook at docs/ai/oversight/
- oversight runbook <value> is missing required section <value>
- oversight runbook <value> has no approver field
- no oversight runbook under docs/ai/oversight/
- oversight runbook missing required section <value>

## Remediation

Bring each affected resource or attestation listed under *What a failure looks like* into compliance, then re-collect evidence. Estimated effort: **6h**. Automated fix available: **false**.

## How to re-verify

```
concord check --controls <pack>/controls --framework eu-ai-act --control-id EU-AIAct-Article14
```

A passing run reports this control green; in CI, `concord gate` exits non-zero while it fails.

## Cross-framework mappings

```
  eu_ai_act:
  - "Article-14"
  iso42001:
  - "8.5"
  nist_ai_rmf:
  - "MANAGE-1.2"
  - "MANAGE-2.3"
```
