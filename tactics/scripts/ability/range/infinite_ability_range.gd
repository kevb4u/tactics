extends AbilityRange

func get_tiles_in_range(level: Level) -> Array[Tile]:
	return level.tiles.values()


func is_position_oriented() -> bool:
	return false
