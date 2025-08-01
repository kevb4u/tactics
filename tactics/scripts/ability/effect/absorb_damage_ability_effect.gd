class_name AbsorbDamageAbilityEffect extends BaseAbilityEffect

#var tracked_sibling_index: int
@export var effect: BaseAbilityEffect
var amount: int

func _ready() -> void:
	#effect = get_tracked_effect()
	on_enable()


func on_enable() -> void:
	effect.hit_notification.connect(on_effect_hit)
	effect.missed_notification.connect(on_effect_miss)


func _exit_tree() -> void:
	on_disable()


func on_disable() -> void:
	effect.hit_notification.disconnect(on_effect_hit)
	effect.missed_notification.disconnect(on_effect_miss)


func predict(_target: Tile) -> int:
	return 0


func apply(_target: Tile) -> int:
	var stats: Stats = get_unit().get_node("Stats")
	stats.set_stat(StatTypes.Stat.HP, stats.get_stat(StatTypes.Stat.HP) + amount)
	return amount


func on_effect_hit(args: int) -> void:
	amount = args


func on_effect_miss() -> void:
	amount = 0


#func get_tracked_effect() -> BaseAbilityEffect:
	#var _owner: Ability = get_node("../../")
	#if tracked_sibling_index >= 0 and tracked_sibling_index < _owner.get_children().size():
		#var sibling: Node = _owner.get_child(tracked_sibling_index)
		#return sibling.get_node("AbilityEffect")
	#return null
