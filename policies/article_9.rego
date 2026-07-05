package concord.eu_ai_act.article_9

import rego.v1

# EU AI Act Article 9 — risk-management system for high-risk AI systems.
# Inputs:
#   input.model_registry.models[]  — production AI inventory
#   input.risk_docs.docs[]         — parsed docs/ai/risk-management/*.md files

max_age_days := n if {
    n := input._concord.params.max_age_days
} else := 365

nanos_per_day := 86400000000000

# A risk-management record is complete only when it names the model it
# covers, the hazards identified, the mitigations applied, the residual
# risk accepted, and who reviewed it and when.
required_frontmatter := ["model", "hazards", "mitigations", "residual_risk", "reviewer", "reviewed_at"]

deny contains msg if {
    not input.model_registry
    msg := "no model registry evidence collected"
}

deny contains msg if {
    not input.risk_docs
    msg := "no risk-management evidence collected"
}

# Every high-risk production model must have a risk-management record.
deny contains msg if {
    some model in input.model_registry.models
    is_high_risk_prod(model)
    not has_record(model.name)
    msg := sprintf("high-risk model %q has no risk-management record under docs/ai/risk-management/", [model.name])
}

# Every record must declare the required fields.
deny contains msg if {
    some doc in input.risk_docs.docs
    some field in required_frontmatter
    not has_value(doc, field)
    msg := sprintf("risk-management record %q is missing required field %q", [doc.path, field])
}

# The process must be iterative: records go stale.
deny contains msg if {
    some doc in input.risk_docs.docs
    doc.reviewed_at
    reviewed_ns := time.parse_rfc3339_ns(doc.reviewed_at)
    cutoff_ns := time.now_ns() - (max_age_days * nanos_per_day)
    reviewed_ns < cutoff_ns
    msg := sprintf("risk-management record %q has not been reviewed in over %d days", [doc.path, max_age_days])
}

# Article 9(2)(d) folds post-market monitoring into the risk process.
warn contains msg if {
    some doc in input.risk_docs.docs
    not has_value(doc, "post_market_monitoring")
    msg := sprintf("risk-management record %q has no post_market_monitoring field (Article 9(2)(d))", [doc.path])
}

is_high_risk_prod(model) if {
    model.production == true
    model.eu_ai_act_tier == "high"
}

has_record(name) if {
    some doc in input.risk_docs.docs
    doc.model == name
}

has_value(doc, key) if {
    v := doc[key]
    v != ""
}
