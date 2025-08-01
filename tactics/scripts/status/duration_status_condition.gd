class_name DurationStatusCondition extends StatusCondition

@export var duration: int = 3
var turn_controller: TurnOrderController

func _init() -> void:
	turn_controller = Global.game_controller.battle_controller.turn_order_controller


func on_enable() -> void:
	turn_controller.turn_began_notification.connect(on_new_turn)


func on_disable() -> void:
	if turn_controller.turn_began_notification.is_connected(on_new_turn):
		turn_controller.turn_began_notification.disconnect(on_new_turn)


func on_new_turn(unit: Unit) -> void:
	if unit != get_parent().get_parent():
		return
	duration -= 1
	if duration <= 0:
		await Global.game_controller.battle_controller.turn_order_controller.turn_completed_notification
		remove()
