extends AbilityRange

@export var width = 1
var _dirs = [Vector2i(0,1), Vector2i(1,0), Vector2i(0,-1), Vector2i(-1,0)]

func valid_tile(t: Tile):
	return t != null && abs(t.height - unit.tile.height) <= vertical

func get_tiles_in_range(level: Level):
	var ret_value: Array[Tile] = []
	var pos: Vector2i = unit.tile.pos
	for dir in _dirs:
		var sec_dir: Vector2i = Vector2i(1,1) - abs(dir)
		for i in range(min_h, horizontal + 1):
			for j in range(-width + 1, width):
				var tile_vector: Vector2i = pos + dir*i + sec_dir*j
				var tile: Tile = level.get_tile(tile_vector)
				if valid_tile(tile):
					ret_value.append(tile)
	return ret_value
