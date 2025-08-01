class_name Movement extends Node

signal finished

var unit: Unit

var range: int:
	get:
		if Global.game_controller.battle_controller.in_battle == false:
			return 20
		return stats.get_stat(StatTypes.Stat.MOV)

var jump_height: int:
	get:
		if Global.game_controller.battle_controller.in_battle == false:
			return 1
		return stats.get_stat(StatTypes.Stat.JMP)

var stats: Stats
var is_active: bool = false
var path: Array[Tile]
var walk_tween: Tween

func _ready() -> void:
	_init()


func _init() -> void:
	if get_parent():
		unit = get_node("../")
		if unit:
			stats = unit.get_node("Stats")


func traverse(_tile: Tile) -> void:
	pass


func turn(dir: Directions.Dirs) -> void:
	unit.dir = dir


func get_tiles_in_range(level: Level, target: Tile) -> Array[Tile]:
	var ret_value: Array[Tile] = level.search(unit.tile, target, expanded_search)
	filter(ret_value)
	return ret_value


func expanded_search(from: Tile, _to: Tile, _target: Tile) -> bool:
	return from.distance + 1 <= range


func filter(tiles: Array) -> void:
	for i in range(tiles.size()-1, -1, -1):
		if tiles[i].content != null:
			tiles.remove_at(i)
