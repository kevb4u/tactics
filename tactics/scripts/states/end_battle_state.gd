class_name EndBattleState extends BattleState

func enter() -> void:
	super()
	_owner.end_battle()
