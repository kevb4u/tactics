extends AbilityRange

func get_tiles_in_range(level: Level) -> Array[Tile]:
	var ret_value: Array[Tile] = level.range_search(unit.tile, null, expand_search, horizontal )
	return ret_value


func expand_search(from: Tile, to: Tile, _target: Tile) -> bool:
	var dist: float = abs(from.pos.x - to.pos.x) + abs(from.pos.y - to.pos.y)
	return  dist <= horizontal && dist >= min_h && abs(from.height - to.height) <= vertical
