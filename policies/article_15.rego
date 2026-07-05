package concord.eu_ai_act.article_15

import rego.v1

# EU AI Act Article 15 — accuracy, robustness and cybersecurity for
# high-risk AI systems.
# Inputs:
#   input.model_registry.models[]  — production AI inventory; a high-risk
#                                     model carries a cybersecurity_assessment tag.
#   input.eval_runs.models[]       — W&B evaluation runs keyed by model name,
#                                     each with accuracy + robustness_tested.

min_accuracy := n if {
    n := input._concord.params.min_accuracy
} else := 0.8

deny contains msg if {
    not input.model_registry
    msg := "no model registry evidence collected"
}

deny contains msg if {
    not input.eval_runs
    msg := "no evaluation-run evidence collected"
}

# Every high-risk production model must have an evaluation run.
deny contains msg if {
    some model in input.model_registry.models
    is_high_risk_prod(model)
    not has_eval(model.name)
    msg := sprintf("high-risk model %q has no evaluation run recorded in W&B", [model.name])
}

# The evaluation run must meet the accuracy threshold.
deny contains msg if {
    some model in input.model_registry.models
    is_high_risk_prod(model)
    has_eval(model.name)
    not accuracy_ok(model.name)
    msg := sprintf("high-risk model %q has no evaluation run meeting the %v accuracy threshold", [model.name, min_accuracy])
}

# The evaluation run must include robustness testing.
deny contains msg if {
    some model in input.model_registry.models
    is_high_risk_prod(model)
    has_eval(model.name)
    not robustness_ok(model.name)
    msg := sprintf("high-risk model %q has no robustness-testing evidence in its evaluation run", [model.name])
}

# The model must declare a cybersecurity assessment.
deny contains msg if {
    some model in input.model_registry.models
    is_high_risk_prod(model)
    not has_value(model, "cybersecurity_assessment")
    msg := sprintf("high-risk model %q has no cybersecurity_assessment recorded", [model.name])
}

# Adversarial robustness is recommended by Article 15(5) but not mandated.
warn contains msg if {
    some model in input.model_registry.models
    is_high_risk_prod(model)
    some e in input.eval_runs.models
    e.name == model.name
    e.adversarial_tested != true
    msg := sprintf("high-risk model %q evaluation run has no adversarial-robustness testing (recommended by Article 15)", [model.name])
}

is_high_risk_prod(model) if {
    model.production == true
    model.eu_ai_act_tier == "high"
}

has_eval(name) if {
    some e in input.eval_runs.models
    e.name == name
}

accuracy_ok(name) if {
    some e in input.eval_runs.models
    e.name == name
    e.accuracy >= min_accuracy
}

robustness_ok(name) if {
    some e in input.eval_runs.models
    e.name == name
    e.robustness_tested == true
}

has_value(obj, key) if {
    v := obj[key]
    v != ""
}
