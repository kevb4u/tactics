class_name AttackPattern extends Node

var pickers: Array[BaseAbilityPicker]
var index: int = 0

func _ready() -> void:
	for c in get_children():
		if c is BaseAbilityPicker:
			pickers.append(c)


func pick(plan: PlanOfAttack) -> void:
	pickers[index].pick(plan)
	index += 1
	if index >= pickers.size():
		index = 0
