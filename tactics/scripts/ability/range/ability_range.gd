class_name AbilityRange extends Node

@export var horizontal: int = 1
@export var min_h: int = 0
@export var vertical: int = 999999

var direction_oriented: bool: get = _get_direction_oriented

func _ready() -> void:
	name = "AbilityRange"


func _get_direction_oriented() -> bool:
	return false

var unit: Unit:
	get:
		var _unit = get_parent()
		while not _unit is Unit:
			_unit = _unit.get_parent()
		return _unit


func get_tiles_in_range(_level: Level) -> Array[Tile]:
	return []


func is_position_oriented() -> bool:
	return true
