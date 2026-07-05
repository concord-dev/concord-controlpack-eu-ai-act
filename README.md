# concord-controlpack-eu-ai-act

EU AI Act control pack for [Concord](https://github.com/concord-dev/concord) —
govern your AI systems as code. Each control evaluates real ML evidence (model
registry, datasets, evaluation runs, logs, repo docs) against a high-risk
provider obligation and cross-maps to ISO/IEC 42001 and the NIST AI RMF.

## Install

```sh
concord controlpack install ghcr.io/concord-dev/concord-controlpack-eu-ai-act:v0.3.0
```

## Controls

High-risk (Annex III) provider obligations:

| Control | Obligation | Primary evidence |
|---|---|---|
| `EU-AIAct-Article9`  | Art. 9 — risk-management system (documented, iterative) | MLflow registry + `docs/ai/risk-management/*.md` |
| `EU-AIAct-Article10` | Art. 10 — data governance (provenance + bias + representativeness) | MLflow registry + `docs/ai/datasets/*.md` |
| `EU-AIAct-Article11` | Art. 11 + Annex IV — technical documentation | MLflow registry + `docs/ai/technical-documentation/*.md` |
| `EU-AIAct-Article12` | Art. 12 — logging / record-keeping (retention) | MLflow registry + Datadog log indexes |
| `EU-AIAct-Article13` | Art. 13 — transparency (model card published) | MLflow registry + `docs/ai/model-cards/*.md` |
| `EU-AIAct-Article14` | Art. 14 — human oversight (runbook + kill-switch) | MLflow registry + `docs/ai/oversight/*.md` |
| `EU-AIAct-Article15` | Art. 15 — accuracy / robustness / cybersecurity | MLflow registry + W&B evaluation runs |

Every control is fixture-tested (`concord control lint`) and scopes only to
production models tagged `eu_ai_act_tier: high` in the model registry, so
limited- and minimal-risk systems are not flagged.

## Evidence sources

This pack consumes evidence from the following Concord plugins:

- `github` — repo docs (risk-management, datasheets, technical docs, model cards, oversight runbooks)
- `mlflow` — model registry (the AI-system inventory + tags)
- `wandb` — evaluation runs (accuracy, robustness)
- `datadog` — log index retention

## Validate locally

```sh
concord control lint .
```
