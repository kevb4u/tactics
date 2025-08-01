class_name RandomAbilityPicker extends BaseAbilityPicker

@export var pickers: Array[BaseAbilityPicker]

func pick(plan: PlanOfAttack) -> void:
	var index: int = randi_range(0, pickers.size() - 1)
	var p: BaseAbilityPicker = pickers[index]
	p.pick(plan)
