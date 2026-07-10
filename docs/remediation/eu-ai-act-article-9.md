# Every high-risk AI system has a documented, iterative risk-management record

`EU-AIAct-Article9` · framework **eu-ai-act** · severity **high** · Provider obligations

## What this control checks

EU AI Act Article 9 requires providers of high-risk AI systems to
establish, implement, document and maintain a risk-management system
that runs as a continuous, iterative process across the whole
lifecycle. Concord enforces a Git-versioned risk-management record at
docs/ai/risk-management/<model>.md for every high-risk production
model. The record must identify hazards, the mitigations applied, and
the residual risk accepted, and it must be reviewed on a recurring
cadence so the process is demonstrably iterative rather than a
one-time launch artifact.

## Why it matters

Article 9 is unusual in that it mandates a *process*, not a document —
risk identification, estimation, evaluation and mitigation repeated
"throughout the entire lifecycle." The auditable proxy for a living
process is a record that is (a) complete (hazards → mitigations →
residual risk), (b) attributable (a named reviewer), and (c) fresh
(reviewed within the review window). A stale or fieldless record is
the signature of a process that stopped after launch, which is exactly
the failure mode Article 9 is written against.

## Evidence

Collected from the `mlflow` source (`model_registry` evidence type).

## What a failure looks like

This control reports a finding when any of the following hold:

- no model registry evidence collected
- no risk-management evidence collected
- high-risk model <value> has no risk-management record under docs/ai/risk-management/
- risk-management record <value> is missing required field <value>
- risk-management record <value> has not been reviewed in over <value> days
- risk-management record <value> has no post_market_monitoring field (Article 9(2)(d))
- no risk-management record under docs/ai/risk-management/
- record missing required field <value>
- record not reviewed in over <value> days

## Remediation

Bring each affected resource or attestation listed under *What a failure looks like* into compliance, then re-collect evidence. Estimated effort: **1d**. Automated fix available: **false**.

## How to re-verify

```
concord check --controls <pack>/controls --framework eu-ai-act --control-id EU-AIAct-Article9
```

A passing run reports this control green; in CI, `concord gate` exits non-zero while it fails.

## Cross-framework mappings

```
  eu_ai_act:
  - "Article-9"
  iso42001:
  - "6.1.2"
  - "6.1.3"
  - "8.2"
  nist_ai_rmf:
  - "MAP-1.1"
  - "GOVERN-4.1"
  - "MANAGE-1.1"
```
