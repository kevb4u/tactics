class_name BaseVictoryCondition extends Node

var victor: AllianceType.Alliances = AllianceType.Alliances.None
var units: Array[Unit]
var bc: BattleController

func on_enable() -> void:
	bc = Global.game_controller.battle_controller
	units = bc.units
	
	for u in units:
		var stats: Stats = u.get_node("Stats")
		stats.did_change_notification(StatTypes.Stat.HP).connect(on_hp_did_change_notification)


func on_disable() -> void:
	for u in units:
		if u != null:
			var stats: Stats = u.get_node("Stats")
			stats.did_change_notification(StatTypes.Stat.HP).disconnect(on_hp_did_change_notification)


func on_hp_did_change_notification(stats: Stats, old_value: int) -> void:
	check_for_game_over()


func check_for_game_over() -> void:
	if party_defeated(AllianceType.Alliances.Hero):
		victor = AllianceType.Alliances.Enemy


func is_defeated(unit: Unit) -> bool:
	var health: Health = unit.get_node("Health")
	if health:
		return health.min_hp == health.HP
	
	var stats: Stats = unit.get_node("Stats")
	return stats.get_stat(StatTypes.Stat.HP) == 0


func party_defeated(type: AllianceType.Alliances) -> bool:
	for i in units.size():
		var a: Alliance = units[i].alliance
		if a.type == type and not is_defeated(units[i]):
			return false
	return true
