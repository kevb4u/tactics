class_name Feature extends Node

var target: Node:
	get:
		return _target

var _target: Node

## Temporary effect on the target
func activate(target_obj: Node) -> void:
	if _target == null:
		_target = target_obj
		on_apply()


func deactivate() -> void:
	if _target != null:
		on_remove()
		_target = null


## Permenant effect on the target
func apply(target_obj: Node) -> void:
	_target = target_obj
	on_apply()
	_target = null


func on_apply() -> void:
	pass


func on_remove() -> void:
	pass
