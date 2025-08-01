class_name UndeadAbilityEffectTarget extends AbilityEffectTarget

## Indicates whether the Undead component must be present (true)
## or must not be present (false) for the target to be valid.
var toggle: bool

func is_target(tile: Tile) -> bool:
	if tile == null or tile.content == null:
		return false
	
	var undead_node: Array[Node] = tile.content.get_children().filter(func(node): return node is Undead)
	var has_component: bool = undead_node != null
	
	if has_component != toggle:
		return false
	
	var stats: Stats = tile.content.get_node("Stats")
	return stats != null and stats.get_stat(StatTypes.Stat.HP) > 0
