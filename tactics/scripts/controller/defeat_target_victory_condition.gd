class_name DefeatTargetVictoryCondition extends BaseVictoryCondition

var target: Unit

func check_for_game_over() -> void:
	super()
	if victor == AllianceType.Alliances.None and is_defeated(target):
		victor = AllianceType.Alliances.Hero
