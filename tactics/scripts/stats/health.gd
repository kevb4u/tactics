class_name Health extends Node

var stats: Stats
var HP: int:
	get:
		return stats.get_stat(StatTypes.Stat.HP)
	set(value):
		stats.set_stat(StatTypes.Stat.HP, value)

var MHP: int:
	get:
		return stats.get_stat(StatTypes.Stat.MHP)
	set(value):
		stats.set_stat(StatTypes.Stat.MHP, value)

var min_hp: int = 0 # Defeat HP
# https://theliquidfire.com/2015/11/16/tactics-rpg-victory-conditions/

func _ready() -> void:
	stats = get_node("../Stats")
	on_enable()


func on_enable() -> void:
	stats.will_change_notification(StatTypes.Stat.HP).connect(on_hp_will_change)
	stats.did_change_notification(StatTypes.Stat.MHP).connect(on_mhp_did_change)


func _exit_tree() -> void:
	on_disable()


func on_disable() -> void:
	stats.will_change_notification(StatTypes.Stat.HP).disconnect(on_hp_will_change)
	stats.did_change_notification(StatTypes.Stat.MHP).disconnect(on_mhp_did_change)


func on_hp_will_change(_stats: Stats, vce: ValueChangeException) -> void:
	vce.add_modifier(ClampValueModifier.new(Global.max_signed_int_32, min_hp, stats.get_stat(StatTypes.Stat.MHP)))


func on_mhp_did_change(_stats: Stats, args: int) -> void:
	var old_mhp: int = args
	if MHP > old_mhp:
		HP = HP + (MHP - old_mhp)
	else:
		HP = clamp(HP, min_hp, MHP)
