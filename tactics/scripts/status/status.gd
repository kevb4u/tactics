class_name Status extends Node

signal added_notification(status_effect: StatusEffect)
signal removed_notification

func add(status_effect: StatusEffect, status_condition: StatusCondition) -> StatusCondition:
	add_child(status_condition)
	if status_condition.get_children().has(status_effect) == false:
		status_condition.add_child(status_effect)
		added_notification.emit(status_effect)
	return status_condition


func remove(status_condition: StatusCondition) -> void:
	if get_children().has(status_condition):
		var filtered: Array[Node] = status_condition.get_children().filter(func(node): return node is StatusEffect)
		var status_effect: StatusEffect = filtered[0]
		if status_effect:
			status_effect.get_parent().remove_child(status_effect)
			status_effect.on_disable()
			status_effect.queue_free()
		status_condition.get_parent().remove_child(status_condition)
		status_condition.on_disable()
		status_condition.queue_free()
		removed_notification.emit()
