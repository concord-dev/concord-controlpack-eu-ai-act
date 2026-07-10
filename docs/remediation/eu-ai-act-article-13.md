# Every high-risk AI system publishes a deployer-facing model card

`EU-AIAct-Article13` · framework **eu-ai-act** · severity **high** · Provider obligations

## What this control checks

EU AI Act Article 13 requires high-risk AI systems to be designed
and developed so that their operation is sufficiently transparent
to enable deployers to interpret outputs. Concord enforces this
by requiring every high-risk production model to expose a model
card, either as an MLflow tag `public_model_card_url` or as a
Git-versioned markdown file at docs/ai/model-cards/<model>.md.

## Why it matters

The model card is the canonical transparency artifact: it tells
downstream deployers about intended use, performance, limitations,
and known biases. Without it, deployers cannot satisfy their own
Article 26 obligations. We accept either an externally hosted
card (via tag) or an internally maintained Git-tracked one.

## Evidence

Collected from the `mlflow` source (`model_registry` evidence type).

## What a failure looks like

This control reports a finding when any of the following hold:

- no model registry evidence collected
- high-risk model <value> has neither public_model_card_url tag nor docs/ai/model-cards/<model>.md
- model card <value> is missing intended_use section
- model card <value> is missing limitations section

## Remediation

Bring each affected resource or attestation listed under *What a failure looks like* into compliance, then re-collect evidence. Estimated effort: **4h**. Automated fix available: **false**.

## How to re-verify

```
concord check --controls <pack>/controls --framework eu-ai-act --control-id EU-AIAct-Article13
```

A passing run reports this control green; in CI, `concord gate` exits non-zero while it fails.

## Cross-framework mappings

```
  eu_ai_act:
  - "Article-13"
  iso42001:
  - "8.4"
  - "9.4"
  nist_ai_rmf:
  - "GOVERN-1.3"
  - "MAP-4.1"
  - "MEASURE-3.3"
```
