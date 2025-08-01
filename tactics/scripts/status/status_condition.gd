class_name StatusCondition extends Node

func _enter_tree() -> void:
	on_enable()


func _exit_tree() -> void:
	on_disable()


func on_enable() -> void:
	pass


func on_disable() -> void:
	pass


func remove() -> void:
	var status: Status = get_parent()
	if status:
		status.remove(self)
