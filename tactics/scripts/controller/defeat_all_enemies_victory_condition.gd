class_name DefeatAllEnemiesVictoryCondition extends BaseVictoryCondition

func check_for_game_over() -> void:
	super()
	if victor == AllianceType.Alliances.None and party_defeated(AllianceType.Alliances.Enemy):
		victor = AllianceType.Alliances.Hero
