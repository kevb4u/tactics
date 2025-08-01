@tool
class_name IsometricTileMap extends TileMapLayer

var astar: AStarGrid2D

func _ready() -> void:
	astar = AStarGrid2D.new()
	astar.region = get_used_rect()
	astar.cell_size = tile_set.tile_size
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	bake_navigation()


func bake_navigation() -> void:
	for x in get_used_rect().size.x:
		for y in get_used_rect().size.y:
			var tile_position: Vector2i = get_used_rect().position + Vector2i(x, y)
			var tile_data := get_cell_tile_data(tile_position)
			
			if tile_data:
				if tile_data.get_custom_data("walkable") == false:
					astar.set_point_solid(tile_position)
			else:
				astar.set_point_solid(tile_position)


func set_solid(solid_position: Vector2) -> void:
	var tile_position: Vector2 = map_to_local(solid_position)
	astar.set_point_solid(tile_position)

func get_astar_path(start: Vector2, end: Vector2) -> Array[Vector2]:
	var id_path := get_astar_path_3d(local_to_map(start), local_to_map(end))
	if id_path.is_empty() == false:
		return convert_to_local(id_path)
	return []

func get_astar_path_3d(start: Vector2i, end: Vector2i) -> Array[Vector2i]:
	if astar.is_in_bounds(end.x, end.y):
		var id_path = astar.get_id_path(
				start,
				end
			).slice(1)
		if id_path.is_empty() == false:
			return id_path
	return []

func convert_to_local(id_path: Array[Vector2i]) -> Array[Vector2]:
	var path_local: Array[Vector2] = []
	
	for i in id_path:
		path_local.append(map_to_local(i))
	
	return path_local
