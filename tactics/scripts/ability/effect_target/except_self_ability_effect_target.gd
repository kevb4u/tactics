extends AbilityEffectTarget

func is_target(tile: Tile) -> bool:
	if (tile == null || tile.content == null || not tile.content is Unit || get_unit() == tile.content):
		return false
	
	var unit: Unit = tile.content
	var s: Stats = unit.get_node("Stats")
	return s != null && s.get_stat(StatTypes.Stat.HP) > 0


func get_unit() -> Unit:
	var _unit = get_parent()
	while not _unit is Unit:
		_unit = _unit.get_parent()
	return _unit
