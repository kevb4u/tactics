@tool
class_name Tile extends Node

static var tile_status_key: FastKey = FastKey.get_or_register_key("tile_status_key")

var tile_map_pos: Vector2i
var tile_map: IsometricTileMap
var grid_map: GridMap

var pos: Vector2i

var og_height: int

var height: int:
	get():
		return height + height_offset
	set(value):
		og_height = value
		height = value

var height_offset: int = 0

var content: Node
var status: Status = Status.new()

var prev: Tile
var distance: int

var default_cell: int = 0

func center() -> Vector3:
	var _pos: Vector2 = Global.map_to_local(pos)
	return Vector3(_pos.x, height * 16, _pos.y)


func select_tile() -> void:
	tile_map.set_cell(tile_map_pos, 0, Vector2i(0, 0))
	grid_map.set_cell_item(Vector3i(pos.x, height + 1, pos.y), 26)


func deselect_tile() -> void:
	tile_map.set_cell(tile_map_pos, 0, Vector2i(0, 3))
	grid_map.set_cell_item(Vector3i(pos.x, height + 1, pos.y), -1)


func change_tile(cell: int) -> void:
	tile_map.set_cell(tile_map_pos, 0, Vector2i(0, 0))
	grid_map.set_cell_item(Vector3i(pos.x, height, pos.y), cell)


func change_status(status_effect: StatusEffect, status_condition: StatusCondition) -> void:
	for c in status.get_children():
		for cc in c.get_children():
			if cc is StatusEffect:
				cc.get_parent().remove()
	status_effect.tile = self
	status.add(status_effect, status_condition)
	status_condition.on_enable()
	status_effect.on_enable()


func get_status_effect() -> StatusEffect:
	return status.get_child(0).get_child(0)


func on_tile_status() -> void:
	if not content is Unit:
		return
	pass
