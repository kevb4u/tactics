class_name AbilityArea extends Node

var range_h:int:
	get:
		return _get_range().horizontal
		
var range_min_h:int:
	get:
		return _get_range().min_h
		
var range_v: int:
	get:
		return _get_range().vertical

func _ready() -> void:
	name = "AbilityArea"


func _get_range() -> AbilityRange:
	var filtered: Array[Node] = self.get_parent().get_children().filter(func(node): return node is AbilityRange)
	var _range: AbilityRange = filtered[0]
	return _range


func get_tiles_in_area(_level: Level, _pos: Vector2i) -> Array[Tile]:
	return []
