# Every high-risk AI system's training data has a governed, bias-checked datasheet

`EU-AIAct-Article10` · framework **eu-ai-act** · severity **high** · Provider obligations

## What this control checks

EU AI Act Article 10 requires that high-risk AI systems be developed
on the basis of training, validation and testing data sets that meet
quality criteria: relevant data-governance practices covering design
choices, provenance/collection, examination for bias, and
representativeness. Concord requires every high-risk production model
to declare its training datasets (an MLflow training_datasets tag) and
every named dataset to carry a datasheet at docs/ai/datasets/<name>.md
documenting provenance, a bias examination, and representativeness.

## Why it matters

Article 10 is the obligation spreadsheet-GRC handles worst and
as-code handles best: the evidence is technical (which datasets fed
which model, where they came from, whether they were examined for
bias) and it lives in the ML stack, not a policy binder. Binding each
high-risk model to a per-dataset datasheet turns "we have a data
governance policy" into a verifiable graph — every production model,
every dataset it was trained on, and the provenance + bias record for
each — that regenerates on every model release.

## Evidence

Collected from the `mlflow` source (`model_registry` evidence type).

## What a failure looks like

This control reports a finding when any of the following hold:

- no model registry evidence collected
- no dataset-governance evidence collected
- high-risk model <value> does not declare its training datasets (training_datasets tag)
- training dataset <value> (used by high-risk model <value>) has no datasheet under docs/ai/datasets/
- dataset datasheet <value> is missing required field <value>
- dataset datasheet <value> has no known_limitations field (Article 10(2)(g))

## Remediation

Bring each affected resource or attestation listed under *What a failure looks like* into compliance, then re-collect evidence. Estimated effort: **1d**. Automated fix available: **false**.

## How to re-verify

```
concord check --controls <pack>/controls --framework eu-ai-act --control-id EU-AIAct-Article10
```

A passing run reports this control green; in CI, `concord gate` exits non-zero while it fails.

## Cross-framework mappings

```
  eu_ai_act:
  - "Article-10"
  iso42001:
  - "7.4"
  - "8.3"
  nist_ai_rmf:
  - "MAP-2.3"
  - "MEASURE-2.6"
```
