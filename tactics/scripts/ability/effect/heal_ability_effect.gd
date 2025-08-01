class_name HealAbilityEffect extends BaseAbilityEffect

const min_damage: int = -999
const max_damage: int = 999


## Flat Heal based on Power
func predict(target: Tile) -> int:
	var attacker: Unit = get_unit()
	var defender: Unit = target.content
	return get_stat(attacker, defender, Global.get_or_register_signal(DamageAbilityEffect.get_power_notification_key), 0)


func apply(target: Tile) -> int:
	var defender: Unit = target.content
	
	## Start with the predicted damage value
	var value: int = predict(target)
	
	## Add some random variance #TODO: floori(randf_range(0.9, 1.1))??
	value = floori(value * randf_range(0.9, 1.1))
	
	## Clamp the damage to a range
	value = clamp(value, min_damage, max_damage)
	
	## Apply the damage to the target
	var stat: Stats = defender.get_node("Stats")
	stat.set_stat(StatTypes.Stat.HP, stat.get_stat(StatTypes.Stat.HP) + value)
	return value


func get_stat(attacker: Unit, defender: Unit, notifiy: Signal, start_value: int) -> int:
	var mods: Array[ValueModifier]
	var info: Info.Info3 = Info.Info3.new(attacker, defender, mods)
	notifiy.emit(info)
	mods.sort()
	
	var value: float = start_value
	for i in mods.size():
		value = mods[i].modify(start_value, value)
	
	var ret_value: int = floori(value)
	ret_value = clamp(ret_value, min_damage, max_damage)
	return ret_value
