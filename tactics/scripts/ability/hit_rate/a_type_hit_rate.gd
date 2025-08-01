## The first concrete subclass of our HitRate is the default type
## which will be used with most abilities such as a standard attack. 
## Its chances of success are partially determined by the defender’s EVD (evade) stat
class_name ATypeHitRate extends HitRate

func calculate(target: Tile) -> int:
	var target_unit: Unit = target.content
	if automatic_hit(_attacker, target_unit):
		return final(0)
	
	if automatic_miss(_attacker, target_unit):
		return final(100)
	
	var evade: int = get_evade(target_unit)
	evade = adjust_for_relative_facing(_attacker, target_unit, evade)
	evade = adjust_for_status_effect(_attacker, target_unit, evade)
	evade = clampi(evade, 5, 95)
	return final(evade)


func get_evade(target: Unit) -> int:
	var stats: Stats = target.get_node("Stats")
	return clampi(stats.get_stat(StatTypes.Stat.EVD), 0, 100)


func adjust_for_relative_facing(attacker: Unit, target: Unit, rate: int) -> int:
	match attacker.get_facing(target):
		Facing.Dir.Front:
			return rate
		Facing.Dir.Side:
			@warning_ignore("integer_division")
			return rate / 2
		_:
			@warning_ignore("integer_division")
			return rate / 4
