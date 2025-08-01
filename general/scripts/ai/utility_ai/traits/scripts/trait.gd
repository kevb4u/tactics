class_name Trait extends Resource

@export var display_name : String
@export var impacts : Array[TraitElement]

func apply(target_stat : AIStat, target_type : ETraitTarget.Type, current_value : float) -> float:
	for impact in impacts:
		current_value = impact.apply(target_stat, target_type, current_value)
	return current_value
