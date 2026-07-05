package concord.eu_ai_act.article_10

import rego.v1

# EU AI Act Article 10 — data governance for high-risk AI systems.
# Inputs:
#   input.model_registry.models[]  — production AI inventory; a high-risk
#                                     model declares training_datasets, a
#                                     comma-separated list of dataset names.
#   input.dataset_docs.docs[]      — parsed docs/ai/datasets/*.md datasheets.

# A datasheet is complete only when it names the dataset, its provenance,
# a bias examination, its representativeness, and who reviewed it.
required_frontmatter := ["dataset", "provenance", "bias_evaluation", "representativeness", "reviewer"]

deny contains msg if {
    not input.model_registry
    msg := "no model registry evidence collected"
}

deny contains msg if {
    not input.dataset_docs
    msg := "no dataset-governance evidence collected"
}

# Every high-risk production model must declare which datasets it trained on.
deny contains msg if {
    some model in input.model_registry.models
    is_high_risk_prod(model)
    not has_datasets(model)
    msg := sprintf("high-risk model %q does not declare its training datasets (training_datasets tag)", [model.name])
}

# Every declared training dataset must have a datasheet.
deny contains msg if {
    some model in input.model_registry.models
    is_high_risk_prod(model)
    some ds in dataset_names(model)
    not has_datasheet(ds)
    msg := sprintf("training dataset %q (used by high-risk model %q) has no datasheet under docs/ai/datasets/", [ds, model.name])
}

# Every datasheet must document the required governance fields.
deny contains msg if {
    some doc in input.dataset_docs.docs
    some field in required_frontmatter
    not has_value(doc, field)
    msg := sprintf("dataset datasheet %q is missing required field %q", [doc.path, field])
}

# Article 10(2)(f)/(g): gaps and shortcomings should be documented too.
warn contains msg if {
    some doc in input.dataset_docs.docs
    not has_value(doc, "known_limitations")
    msg := sprintf("dataset datasheet %q has no known_limitations field (Article 10(2)(g))", [doc.path])
}

is_high_risk_prod(model) if {
    model.production == true
    model.eu_ai_act_tier == "high"
}

has_datasets(model) if {
    model.training_datasets
    model.training_datasets != ""
}

dataset_names(model) := names if {
    names := {trim(d, " ") | some d in split(model.training_datasets, ",")}
}

has_datasheet(name) if {
    some doc in input.dataset_docs.docs
    doc.dataset == name
}

has_value(doc, key) if {
    v := doc[key]
    v != ""
}
