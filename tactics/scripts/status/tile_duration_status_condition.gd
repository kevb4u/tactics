class_name TileDurationStatusCondition extends StatusCondition

@export var duration: int = 3
var turn_controller: TurnOrderController

func _init() -> void:
	turn_controller = Global.game_controller.battle_controller.turn_order_controller


func on_enable() -> void:
	Global.get_or_register_signal(Tile.tile_status_key).connect(on_new_turn)


func on_disable() -> void:
	Global.get_or_register_signal(Tile.tile_status_key).disconnect(on_new_turn)


func on_new_turn() -> void:
	duration -= 1
	if duration <= 0:
		remove()
