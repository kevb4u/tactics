class_name PhysicalAbilityPower extends BaseAbilityPower

@export var level: int

func get_base_attack() -> int:
	var stats: Stats = get_unit().get_node("Stats")
	return stats.get_stat(StatTypes.Stat.ATK)


func get_base_defense(target: Unit) -> int:
	var stats: Stats = target.get_node("Stats")
	return stats.get_stat(StatTypes.Stat.DEF)


func get_power() -> int:
	return level
