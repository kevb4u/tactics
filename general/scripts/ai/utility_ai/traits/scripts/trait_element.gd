class_name TraitElement extends Resource

@export var linked_stat : AIStat

@export_category("Scoring Scales")
@export_range(0.5, 1.5) var scoring_positive_scale : float = 1.0
@export_range(0.5, 1.5) var scoring_negative_scale : float = 1.0

@export_category("Impact Scales")
@export_range(0.5, 1.5) var impact_positive_scale : float = 1.0
@export_range(0.5, 1.5) var impact_negative_scale : float = 1.0

@export_category("Decay Rate")
@export_range(0.5, 1.5) var decay_rate_base : float = 1.0

func apply(target_stat : AIStat, target_type : ETraitTarget.Type, current_value : float) -> float:
	if target_stat == linked_stat:
		match target_type:
			ETraitTarget.Type.decay_rate:
				current_value *= decay_rate_base
			ETraitTarget.Type.impact:
				if current_value > 0:
					current_value *= impact_positive_scale
				elif current_value < 0:
					current_value *= impact_negative_scale
			ETraitTarget.Type.score:
				if current_value > 0:
					current_value *= scoring_positive_scale
				elif current_value < 0:
					current_value *= scoring_negative_scale
	return current_value
