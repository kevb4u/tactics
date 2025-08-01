## Our final hit rate type is for special abilities which should normally hit without fail. 
## There still may be exceptions to this rule, so I left a notification to allow a chance for misses
class_name FullTypeHitRate extends HitRate

func calculate(target: Tile) -> int:
	if automatic_hit(_attacker, target.content):
		return final(100)
	return final(0)

func is_angle_based() -> bool:
	return false
