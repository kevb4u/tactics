class_name StatComparisonCondition extends StatusCondition

var type: StatTypes.Stat
var value: int
var condition: Callable
var stats: Stats

func init(_type: StatTypes.Stat, _value: int, _condition: Callable) -> void:
	type = _type
	value = _value
	condition = _condition
	
	stats.did_change_notification(type).connect(on_stat_changed)


func on_enable() -> void:
	var unit = get_parent()
	while not unit is Unit:
		unit = unit.get_parent()
	stats = unit.get_node("Stats")


func _exit_tree() -> void:
	on_disable()


func on_disable() -> void:
	stats.did_change_notification(type).disconnect(on_stat_changed)


func equal_to() -> bool:
	return stats.get_stat(type) == value


func less_than() -> bool:
	return stats.get_stat(type) < value


func less_than_or_equal_to() -> bool:
	return stats.get_stat(type) <= value


func greater_than() -> bool:
	return stats.get_stat(type) > value


func greater_than_or_equal_to() -> bool:
	return stats.get_stat(type) >= value


func on_stat_changed(_stats: Stats, _old_value: int) -> void:
	if condition != null and not condition.call():
		remove()
