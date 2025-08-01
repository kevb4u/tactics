extends AbilityArea

## Gets all the units in the area range
func get_tiles_in_area(level: Level, _pos: Vector2i) -> Array[Tile]:
	return _get_range().get_tiles_in_range(level)
