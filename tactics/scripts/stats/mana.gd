class_name Mana extends Node

var unit: Unit
var stats: Stats
var MP: int:
	get:
		return stats.get_stat(StatTypes.Stat.MP)
	set(value):
		stats.set_stat(StatTypes.Stat.MP, value)

var MMP: int:
	get:
		return stats.get_stat(StatTypes.Stat.MMP)
	set(value):
		stats.set_stat(StatTypes.Stat.MMP, value)

func _ready() -> void:
	stats = get_node("../Stats")
	unit = stats.get_parent()
	on_enable()


func on_enable() -> void:
	stats.will_change_notification(StatTypes.Stat.MP).connect(on_mp_will_change)
	stats.did_change_notification(StatTypes.Stat.MMP).connect(on_mmp_did_change)
	Global.game_controller.battle_controller.turn_order_controller.turn_began_notification.connect(on_turn_began)


func _exit_tree() -> void:
	on_disable()


func on_disable() -> void:
	stats.will_change_notification(StatTypes.Stat.MP).disconnect(on_mp_will_change)
	stats.did_change_notification(StatTypes.Stat.MMP).disconnect(on_mmp_did_change)
	Global.game_controller.battle_controller.turn_order_controller.turn_began_notification.disconnect(on_turn_began)


func on_mp_will_change(_stats: Stats, vce: ValueChangeException) -> void:
	vce.add_modifier(ClampValueModifier.new(Global.max_signed_int_32, 0, stats.get_stat(StatTypes.Stat.MMP)))


func on_mmp_did_change(_stats: Stats, args: int) -> void:
	var old_mmp: int = args
	if MMP > old_mmp:
		MP = MP + (MMP - old_mmp)
	else:
		MP = clamp(MP, 0, MMP)


func on_turn_began(_unit: Unit) -> void:
	if unit != _unit:
		return
	
	if MP < MMP:
		MP = MP + max(floori(MMP * 0.1), 1)
