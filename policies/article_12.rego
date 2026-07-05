package concord.eu_ai_act.article_12

import rego.v1

# EU AI Act Article 12 — logging / record-keeping for high-risk AI systems.
# Inputs:
#   input.model_registry.models[]      — production AI inventory
#   input.log_retention.indexes[]      — Datadog log index inventory, each with
#                                        detail.retention_days / is_rate_limited /
#                                        exclusion_filters

min_retention_days := n if {
    n := input._concord.params.min_retention_days
} else := 180

indexes := input.log_retention.indexes

deny contains msg if {
    not input.model_registry
    msg := "no model registry evidence collected"
}

deny contains msg if {
    not input.log_retention
    msg := "no log-retention evidence collected"
}

# High-risk systems are running but nothing is being logged.
deny contains "high-risk AI systems are in production but no log indexes exist for Article 12 record-keeping" if {
    some model in input.model_registry.models
    is_high_risk_prod(model)
    count(indexes) == 0
}

# Every log index must retain records for at least the floor.
deny contains msg if {
    some idx in indexes
    retention(idx) < min_retention_days
    msg := sprintf("log index %q retains records for %d days, below the %d-day record-keeping floor", [idx.name, retention(idx), min_retention_days])
}

# Rate limiting and exclusion filters silently drop traceability records.
warn contains msg if {
    some idx in indexes
    idx.detail.is_rate_limited == true
    msg := sprintf("log index %q is rate-limited; inference records may be dropped", [idx.name])
}

warn contains msg if {
    some idx in indexes
    idx.detail.exclusion_filters > 0
    msg := sprintf("log index %q has %d exclusion filter(s) that may drop traceability events", [idx.name, idx.detail.exclusion_filters])
}

is_high_risk_prod(model) if {
    model.production == true
    model.eu_ai_act_tier == "high"
}

retention(idx) := idx.detail.retention_days
