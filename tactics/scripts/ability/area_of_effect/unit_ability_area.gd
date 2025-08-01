extends AbilityArea

## Get the first valid tile
func get_tiles_in_area(level: Level, pos: Vector2i) -> Array[Tile]:
	var ret_value: Array[Tile] = []
	var tile: Tile = level.get_tile(pos)
	if tile != null:
		ret_value.append(tile)
	
	return ret_value
