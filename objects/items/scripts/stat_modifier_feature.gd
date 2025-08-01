class_name StatModifierFeature extends Feature

@export var type: StatTypes.Stat
@export var amount: int
var stats: Stats:
	get:
		return _target.get_node("Stats")

func on_apply() -> void:
	var startValue = stats.get_stat(type)
	stats.set_stat(type, startValue + amount)


func on_remove() -> void:
	var startValue = stats.get_stat(type)
	stats.set_stat(type, startValue - amount)
