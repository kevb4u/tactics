## The second type of hit rate component is used for special abilities 
## which focus on applying status effects. Its chances of success are
## partially determined by the defender’s RES (resistance) stat
class_name STypeHitRate extends HitRate

func calculate(target: Tile) -> int:
	var target_unit: Unit = target.content
	if automatic_hit(_attacker, target_unit):
		return final(0)
	
	if automatic_miss(_attacker, target_unit):
		return final(100)
	
	var res: int = get_resistance(target_unit)
	res = adjust_for_relative_facing(_attacker, target_unit, res)
	res = adjust_for_status_effect(_attacker, target_unit, res)
	res = clampi(res, 0, 100)
	return final(res)


func get_resistance(target: Unit) -> int:
	var stats: Stats = target.get_node("Stats")
	return stats.get_stat(StatTypes.Stat.RES)


func adjust_for_relative_facing(attacker: Unit, target: Unit, rate: int) -> int:
	match attacker.get_facing(target):
		Facing.Dir.Front:
			return rate
		Facing.Dir.Side:
			return rate - 10
		_:
			return rate - 20
