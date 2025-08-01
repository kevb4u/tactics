@tool
class_name IsometricTileMapSort extends Node2D

@export_tool_button("Sort") var sort_button = sort

var tile_maps: Array[IsometricTileMap]
var tiles: Dictionary[Vector2i, Tile]

func _ready() -> void:
	sort()


func sort() -> void:
	tile_maps.clear()
	for i in get_children().size():
		var child: Node2D = get_child(i)
		if child is IsometricTileMap:
			tile_maps.append(child)
			child.y_sort_enabled = true
			if i == 0:
				child.z_index = -1
			else:
				var tile_size_y: int = child.tile_set.tile_size.y
				child.collision_enabled = false
				child.z_index = 0
				child.y_sort_origin = (i - 1) * tile_size_y
			add_tiles(child, i)
	print("Sorted Tile Map")


func add_tiles(tile_map: IsometricTileMap, height: int) -> void:
	for x in tile_map.astar.size.x:
		for y in tile_map.astar.size.y:
			var _pos: Vector2i = tile_map.astar.region.position + Vector2i(x, y)
			if tile_map.astar.is_in_bounds(_pos.x, _pos.y) == false:
				continue
			
			if tile_map.astar.is_point_solid(_pos) == false:
				# adjust for height
				var height_pos = _pos + Vector2i(height, height)
				
				var tile: Tile
				if tiles.has(height_pos):
					tile = tiles[height_pos]
				else:
					tile = Tile.new()
					tiles[height_pos] = tile
					tile.pos = height_pos
					tile.height = height
					tile.tile_map_pos = _pos
					tile.tile_map = tile_map
					
				if height > tile.height:
					tile.height = height
					tile.tile_map_pos = _pos
					tile.tile_map = tile_map
