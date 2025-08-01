class_name AutoStatusController extends Node

var units: Array[Unit]

func on_enable() -> void:
	units = Global.game_controller.battle_controller.units
	for u in units:
		var stats: Stats = u.get_node("Stats")
		stats.did_change_notification(StatTypes.Stat.HP).connect(on_hp_did_change_notification)
	Global.game_controller.battle_controller.turn_order_controller.turn_check_notification.connect(on_turn_check)
	Global.game_controller.battle_controller.turn_order_controller.turn_completed_notification.connect(on_turn_complete)


func on_disable() -> void:
	for u in units:
		if u != null:
			var stats: Stats = u.get_node("Stats")
			stats.did_change_notification(StatTypes.Stat.HP).disconnect(on_hp_did_change_notification)
	Global.game_controller.battle_controller.turn_order_controller.turn_check_notification.disconnect(on_turn_check)


## Add knockout status if HP is 0
func on_hp_did_change_notification(stats: Stats, _old_value: int) -> void:
	if stats.get_stat(StatTypes.Stat.HP) == 0:
		var status: Status = stats.get_parent().status
		var c: StatComparisonCondition = StatComparisonCondition.new()
		status.add(KnockOutStatusEffect.new(), c)
		c.init(StatTypes.Stat.HP, 0, c.equal_to)


## Add status if unit is on certain tiles once turn starts (e.g Fire = burn for that turn)
# burn here or poison so if someone pushes them here it will still trigger
# instead of once their turn ends
func on_turn_check(unit: Unit, exc: BaseException) -> void:
	if exc.toggle:
		if unit.tile.status.get_child_count() > 0:
			var tile_status_effect: StatusEffect = unit.tile.get_status_effect()
			var duration_status_condition: DurationStatusCondition = DurationStatusCondition.new()
			var status_effect = Node.new()
			
			if tile_status_effect is FireStatusEffect:
				status_effect.set_script(PoisonStatusEffect)
			
			if status_effect is StatusEffect:
				unit.status.add(status_effect, duration_status_condition)
				duration_status_condition.duration = 1


## Add status if unit is on certain tiles that will last until their next turn (e.g. Snow = slow)
# TODO: Make a special status condition so that status is removed once it leaves the tile
func on_turn_complete(unit: Unit) -> void:
	if unit.tile.status.get_child_count() > 0:
		var tile_status_effect: StatusEffect = unit.tile.get_status_effect()
		var duration_status_condition: DurationStatusCondition = DurationStatusCondition.new()
		var status_effect = Node.new()
		
		if tile_status_effect is SnowStatusEffect:
			status_effect.set_script(SlowStatusEffect)
		
		if status_effect is StatusEffect:
			unit.status.add(status_effect, duration_status_condition)
			duration_status_condition.duration = 1
