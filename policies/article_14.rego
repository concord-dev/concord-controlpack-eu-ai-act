package concord.eu_ai_act.article_14

import rego.v1

# EU AI Act Article 14 — human oversight runbook for high-risk AI systems.

required_sections := ["overseer_roles", "capabilities", "limitations", "kill_switch"]

deny contains msg if {
    not input.model_registry
    msg := "no model registry evidence collected"
}

deny contains msg if {
    some model in input.model_registry.models
    is_high_risk_prod(model)
    not has_oversight_doc(model.name)
    msg := sprintf("high-risk model %q has no oversight runbook at docs/ai/oversight/", [model.name])
}

deny contains msg if {
    some doc in input.oversight_docs.docs
    some section in required_sections
    not has_value(doc, section)
    msg := sprintf("oversight runbook %q is missing required section %q", [doc.path, section])
}

warn contains msg if {
    some doc in input.oversight_docs.docs
    not has_value(doc, "approver")
    msg := sprintf("oversight runbook %q has no approver field", [doc.path])
}

# Per-AI-system emission: one verdict per high-risk production model, keyed by
# model name. Keeps the deny/warn contract above for validate; powers per-system
# conformance in `concord plan` and the Annex IV per-system table.
resource_findings contains verdict if {
    some model in input.model_registry.models
    is_high_risk_prod(model)
    msgs := model_denials(model)
    count(msgs) > 0
    verdict := {"resource": model.name, "status": "fail", "messages": sort([m | some m in msgs])}
}

resource_findings contains verdict if {
    some model in input.model_registry.models
    is_high_risk_prod(model)
    count(model_denials(model)) == 0
    verdict := {"resource": model.name, "status": "pass", "messages": []}
}

model_denials(model) := no_doc | missing_sections if {
    no_doc := {msg |
        not has_oversight_doc(model.name)
        msg := "no oversight runbook under docs/ai/oversight/"
    }
    missing_sections := {msg |
        some doc in input.oversight_docs.docs
        doc.model == model.name
        some section in required_sections
        not has_value(doc, section)
        msg := sprintf("oversight runbook missing required section %q", [section])
    }
}

is_high_risk_prod(model) if {
    model.production == true
    model.eu_ai_act_tier == "high"
}

has_oversight_doc(name) if {
    some doc in input.oversight_docs.docs
    doc.model == name
}

has_value(doc, key) if {
    v := doc[key]
    v != ""
}
