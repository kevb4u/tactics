extends AbilityRange

func get_tiles_in_range(level: Level) -> Array[Tile]:
	var ret_value: Array[Tile] = []
	ret_value.append(unit.tile)
	return ret_value


func is_position_oriented() -> bool:
	return false
