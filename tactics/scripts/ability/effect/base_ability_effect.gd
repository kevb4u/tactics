class_name BaseAbilityEffect extends Node

signal hit_notification(hit_damage: int)
signal missed_notification

func predict(_target: Tile) -> int:
	return 0


func apply(_target: Tile) -> int:
	return 0


func get_unit() -> Unit:
	var _owner: Node = get_parent()
	while not _owner is Unit:
		_owner = _owner.get_parent()
	return _owner
