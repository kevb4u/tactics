class_name PoisonStatusEffect extends StatusEffect

var turn_controller: TurnOrderController

func _init() -> void:
	turn_controller = Global.game_controller.battle_controller.turn_order_controller


func on_enable() -> void:
	turn_controller.turn_began_notification.connect(on_new_turn)


func on_disable() -> void:
	if turn_controller.turn_began_notification.is_connected(on_new_turn):
		turn_controller.turn_began_notification.disconnect(on_new_turn)


func on_new_turn(unit: Unit) -> void:
	if get_parent() == null:
		return
	if unit != get_parent().get_parent().get_parent():
		return
	var stats: Stats = unit.get_node("Stats")
	var current_hp: int = stats.get_stat(StatTypes.Stat.HP)
	var max_hp: int = stats.get_stat(StatTypes.Stat.MHP)
	var reduce: int = min(current_hp, floori(max_hp * 0.1))
	stats.set_stat(StatTypes.Stat.HP, (current_hp - reduce), false)
