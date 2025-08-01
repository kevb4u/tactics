class_name Rank extends Node

const min_level: int = 1
const max_level: int = 99
const max_experience: int = 999999

var stats: Stats

var LVL: int: 
	get:
		return stats.get_stat(StatTypes.Stat.LVL)

var EXP: int:
	get:
		return stats.get_stat(StatTypes.Stat.EXP)
	set(value):
		stats.set_stat(StatTypes.Stat.EXP, value)

var level_percent: float:
	get:
		return (float)(LVL - min_level) / (float)(max_level - min_level)


func _ready() -> void:
	stats = get_node("../Stats")
	stats.will_change_notification(StatTypes.Stat.EXP).connect(on_exp_will_change)
	stats.did_change_notification(StatTypes.Stat.EXP).connect(on_exp_did_change)


func init(level: int) -> void:
	stats.set_stat(StatTypes.Stat.LVL, level, false)
	stats.set_stat(StatTypes.Stat.EXP, experience_for_level(level), false)


func on_exp_will_change(_sender: Stats, vce: ValueChangeException):
	vce.add_modifier(ClampValueModifier.new(999999, EXP, max_experience))


func on_exp_did_change(_sender: Stats, _old_value: int):
	stats.set_stat(StatTypes.Stat.LVL, level_for_experience(EXP), false)


static func experience_for_level(level: int) -> int:
	var _level_percent: float = clamp( (float)(level - min_level) / (float)(max_level - min_level), 0, 1)
	return (int)(max_experience * ease(_level_percent, 2.0))


## Iterate down until finds the level we are at based on experience amount
static func level_for_experience(_exp: int)->int:
	var lvl = max_level
	while lvl >= min_level:
		if(_exp >= experience_for_level(lvl)):
			break
		lvl -= 1
	return lvl


func _exit_tree() -> void:
	stats.will_change_notification(StatTypes.Stat.EXP).disconnect(on_exp_will_change)
	stats.did_change_notification(StatTypes.Stat.EXP).disconnect(on_exp_did_change)
