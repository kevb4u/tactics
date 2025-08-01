class_name AbilityMagicCost extends Node

@export var amount: int
var _owner: Ability

func _ready() -> void:
	name = "ManaCost"
	_owner = get_node("../")
	on_enable()


func on_enable() -> void:
	_owner.can_perform_check.connect(on_can_perform_check)
	_owner.did_perform_notification.connect(on_did_perform_notification)


func _exit_tree() -> void:
	on_disable()


func on_disable() -> void:
	_owner.can_perform_check.disconnect(on_can_perform_check)
	_owner.did_perform_notification.disconnect(on_did_perform_notification)


func on_can_perform_check(exc: BaseException) -> void:
	var stats: Stats = get_node("../../../../Stats")
	if stats.get_stat(StatTypes.Stat.MP) < amount:
		exc.flip_toggle()


func on_did_perform_notification() -> void:
	var stats: Stats = get_node("../../../../Stats")
	stats.set_stat(StatTypes.Stat.MP, stats.get_stat(StatTypes.Stat.MP) - amount)
