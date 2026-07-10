# Every high-risk AI system has Annex IV technical documentation

`EU-AIAct-Article11` · framework **eu-ai-act** · severity **high** · Provider obligations

## What this control checks

EU AI Act Article 11 requires providers of high-risk AI systems to
draw up technical documentation conforming to Annex IV before
placing the system on the market. Concord checks every production
model classified as eu_ai_act_tier=high has a corresponding
technical-documentation markdown file with reviewer + reviewed_at
frontmatter so the doc is auditable, not merely present.

## Why it matters

Annex IV requires nine categories of documentation (system
description, design, development, validation, risk management,
changes, accuracy metrics, cybersecurity, post-market monitoring).
Maintaining these as Git-versioned markdown lets Concord prove
not just existence but freshness — auditors care that the doc
matches the deployed system, not a frozen snapshot from launch.

## Evidence

Collected from the `mlflow` source (`model_registry` evidence type).

## What a failure looks like

This control reports a finding when any of the following hold:

- no model registry evidence collected
- no technical-documentation evidence collected
- high-risk model <value> has no technical documentation under docs/ai/technical-documentation/
- technical doc <value> is missing required frontmatter field <value>
- technical doc <value> has not been reviewed in over <value> days
- technical doc <value> has no accuracy_metrics field (recommended by Annex IV §3)
- no technical documentation under docs/ai/technical-documentation/
- technical doc missing required field <value>
- technical doc not reviewed in over <value> days

## Remediation

Bring each affected resource or attestation listed under *What a failure looks like* into compliance, then re-collect evidence. Estimated effort: **1d**. Automated fix available: **false**.

## How to re-verify

```
concord check --controls <pack>/controls --framework eu-ai-act --control-id EU-AIAct-Article11
```

A passing run reports this control green; in CI, `concord gate` exits non-zero while it fails.

## Cross-framework mappings

```
  eu_ai_act:
  - "Article-11"
  - "Annex-IV"
  iso42001:
  - "7.5.3"
  - "8.4"
  nist_ai_rmf:
  - "GOVERN-1.6"
  - "MAP-4.1"
```
