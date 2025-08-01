class_name BattleSceneComponent extends SceneComponent

func start() -> void:
	Global.game_controller.battle_controller.start_battle(_owner)
	Global.get_or_register_signal(BattleController.battle_end_key).connect(finish)


func finish() -> void:
	Global.get_or_register_signal(BattleController.battle_end_key).disconnect(finish)
	super()
