extends AbilityRange

@export var width:int = 1

func _get_direction_oriented() -> bool:
	return true


func valid_tile(t: Tile) -> bool:
	return t != null && abs(t.height - unit.tile.height) <= vertical


func get_tiles_in_range(level: Level) -> Array[Tile]:
	var ret_value:Array[Tile] = []
	var pos: Vector2i = unit.tile.pos
	var dir: Vector2i = Directions.to_vector(unit.dir)
	var sec_dir: Vector2i = Vector2i(1,1) - abs(dir)
	
	for i in range(min_h, horizontal + 1):
		for j in range(-width + 1, width):
			var tile_vector:Vector2i = pos + dir*i + sec_dir*j
			if(tile_vector.x > level._max.x || tile_vector.x < level._min.x):
				break
			if(tile_vector.y > level._max.y || tile_vector.y < level._min.y):
				break
			
			var tile: Tile = level.get_tile(tile_vector)
			if valid_tile(tile):
				ret_value.append(tile)
	
	return ret_value
