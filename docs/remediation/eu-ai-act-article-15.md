# Every high-risk AI system meets accuracy, robustness and cybersecurity thresholds

`EU-AIAct-Article15` · framework **eu-ai-act** · severity **high** · Provider obligations

## What this control checks

EU AI Act Article 15 requires high-risk AI systems to achieve an
appropriate level of accuracy, robustness and cybersecurity, and to
perform consistently across their lifecycle. Concord binds every
high-risk production model to a recorded evaluation run (Weights &
Biases) and checks it meets the accuracy threshold and carries
robustness-testing evidence, and that the model declares a
cybersecurity assessment (an MLflow cybersecurity_assessment tag).

## Why it matters

Article 15 is where "the model works" becomes an auditable claim.
A number in a slide deck is not evidence; a versioned evaluation run
with accuracy + robustness metrics, tied to the exact model version in
production, is. Pinning the check to the eval run that produced the
deployed version — and refusing to pass a high-risk model with no
robustness testing or no cybersecurity assessment — makes the quality
bar continuous and release-gated rather than a launch-day snapshot.

## Evidence

Collected from the `mlflow` source (`model_registry` evidence type).

## What a failure looks like

This control reports a finding when any of the following hold:

- no model registry evidence collected
- no evaluation-run evidence collected
- high-risk model <value> has no evaluation run recorded in W&B
- high-risk model <value> has no evaluation run meeting the <value> accuracy threshold
- high-risk model <value> has no robustness-testing evidence in its evaluation run
- high-risk model <value> has no cybersecurity_assessment recorded
- high-risk model <value> evaluation run has no adversarial-robustness testing (recommended by Article 15)
- no evaluation run recorded in W&B
- no evaluation run meeting the <value> accuracy threshold
- no robustness-testing evidence in evaluation run
- no cybersecurity_assessment recorded

## Remediation

Bring each affected resource or attestation listed under *What a failure looks like* into compliance, then re-collect evidence. Estimated effort: **1d**. Automated fix available: **false**.

## How to re-verify

```
concord check --controls <pack>/controls --framework eu-ai-act --control-id EU-AIAct-Article15
```

A passing run reports this control green; in CI, `concord gate` exits non-zero while it fails.

## Cross-framework mappings

```
  eu_ai_act:
  - "Article-15"
  - "Annex-IV"
  iso42001:
  - "8.3"
  - "9.1"
  nist_ai_rmf:
  - "MEASURE-2.5"
  - "MEASURE-2.7"
  - "MANAGE-2.2"
```
