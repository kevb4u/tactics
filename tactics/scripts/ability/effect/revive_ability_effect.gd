class_name ReviveAbilityEffect extends BaseAbilityEffect

@export var percent: float

func predict(target: Tile) -> int:
	var stats: Stats = target.content.get_node("Stats")
	return floori(stats.get_stat(StatTypes.Stat.MHP) * percent)


func apply(target: Tile) -> int:
	var stats: Stats = target.content.get_node("Stats")
	var value: int = predict(target)
	stats.set_stat(StatTypes.Stat.HP, value)
	return value
