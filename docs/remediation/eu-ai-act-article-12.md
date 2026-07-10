# High-risk AI systems keep inference logs with adequate retention

`EU-AIAct-Article12` · framework **eu-ai-act** · severity **high** · Provider obligations

## What this control checks

EU AI Act Article 12 requires high-risk AI systems to technically
allow for the automatic recording of events (logs) over their
lifetime, to a degree appropriate to the intended purpose, ensuring
traceability. Concord checks that where high-risk models are in
production, log indexes exist and each retains records for at least
the record-keeping floor, so the traceability evidence an incident
investigation or a market-surveillance authority would demand is
actually being kept — not silently expired or rate-limited away.

## Why it matters

Logging is the obligation that only bites after something goes wrong:
a contested decision, a drift incident, a regulator request. By then a
30-day retention window or an aggressive exclusion filter has already
destroyed the record. Checking retention configuration continuously —
against a floor, and flagging rate-limiting and exclusion filters that
quietly drop events — turns "we log everything" into a verifiable,
monitored property of the running system.

## Evidence

Collected from the `mlflow` source (`model_registry` evidence type).

## What a failure looks like

This control reports a finding when any of the following hold:

- no model registry evidence collected
- no log-retention evidence collected
- log index <value> retains records for <value> days, below the <value>-day record-keeping floor
- log index <value> is rate-limited; inference records may be dropped
- log index <value> has <value> exclusion filter(s) that may drop traceability events

## Remediation

Bring each affected resource or attestation listed under *What a failure looks like* into compliance, then re-collect evidence. Estimated effort: **4h**. Automated fix available: **false**.

## How to re-verify

```
concord check --controls <pack>/controls --framework eu-ai-act --control-id EU-AIAct-Article12
```

A passing run reports this control green; in CI, `concord gate` exits non-zero while it fails.

## Cross-framework mappings

```
  eu_ai_act:
  - "Article-12"
  - "Annex-IV"
  iso42001:
  - "8.4"
  - "9.1"
  nist_ai_rmf:
  - "MEASURE-1.1"
  - "MANAGE-4.1"
```
