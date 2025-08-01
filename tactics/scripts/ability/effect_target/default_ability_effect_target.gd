extends AbilityEffectTarget

func is_target(tile: Tile) -> bool:
	if (tile == null || tile.content == null || not tile.content is Unit):
		return false
	
	var unit: Unit = tile.content
	var s: Stats = unit.get_node("Stats")
	return s != null && s.get_stat(StatTypes.Stat.HP) > 0
