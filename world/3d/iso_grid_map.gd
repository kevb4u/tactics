@tool
class_name IsometricGridMap extends GridMap

@export_tool_button("Clear") var _clear = clear
@export_tool_button("Create From Tilemap") var create_ = _create_from_tile_map
@export var iso_tile_map_sort: IsometricTileMapSort

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	if iso_tile_map_sort:
		_create_from_tile_map()


func _create_from_tile_map() -> void:
	clear()
	for i in iso_tile_map_sort.get_children().size():
		var child: Node2D = iso_tile_map_sort.get_child(i)
		_add_in_tile_map(child, i)


func select_tiles(tiles: Array[Tile]) -> void:
	for t in tiles:
		t.select_tile()


func deselect_tiles(tiles: Array[Tile]) -> void:
	for t in tiles:
		t.deselect_tile()


func _add_in_tile_map(iso: IsometricTileMap, height: int) -> void:
	for x in iso.get_used_rect().size.x:
		for y in iso.get_used_rect().size.y:
			var tile_position: Vector2i = iso.get_used_rect().position + Vector2i(x, y)
			var tile_data := iso.get_cell_tile_data(tile_position)
			var tile_position_with_height_offset: Vector3 = Vector3i(tile_position.x + height, height, tile_position.y + height)
			if tile_data:
				set_cell_item(tile_position_with_height_offset, 0)
			#else:
				#set_cell_item(tile_position_with_height_offset, 0)
