class_name KnockOutStatusEffect extends StatusEffect

var _owner: Unit
var stats: Stats


func on_enable() -> void:
	_owner = get_unit()
	stats = _owner.get_node("Stats")
	
	# Animation
	_owner.entity_3d.sprite.frame = 180
		
	Global.game_controller.battle_controller.turn_order_controller.turn_check_notification.connect(on_turn_check)
	stats.will_change_notification(StatTypes.Stat.CTR).connect(on_stat_counter_will_change)


func on_disable() -> void:
	_owner.dir = _owner.dir
	Global.game_controller.battle_controller.turn_order_controller.turn_check_notification.disconnect(on_turn_check)
	stats.will_change_notification(StatTypes.Stat.CTR).disconnect(on_stat_counter_will_change)


func on_turn_check(unit: Unit, exc: BaseException) -> void:
	if _owner != unit:
		return
	
	## Dont allow a KO'd unit to take turns
	if exc.default_toggle == true:
		exc.flip_toggle()


func on_stat_counter_will_change(_stats: Stats, exc: ValueChangeException) -> void:
	## Dont allow a KO'd unit to increment the turn order counter
	## Might allow it like FFT so only a limited time to revive unit
	## DurationStatus for knock out need to be implemented tho
	if exc.to_value > exc.from_value:
		exc.flip_toggle()


func get_unit() -> Unit:
	var unit: Node = get_parent()
	while not unit is Unit:
		unit = unit.get_parent()
	return unit
