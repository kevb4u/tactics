class_name DamageAbilityEffect extends BaseAbilityEffect

#signal get_attack_notification(info: Info.Info3)
#signal get_defense_notification(info: Info.Info3)
#signal get_power_notification(info: Info.Info3)
#signal tweak_damage_notification(info: Info.Info3)

static var get_attack_notification_key: FastKey = FastKey.get_or_register_key("get_attack_notification")
static var get_defense_notification_key: FastKey = FastKey.get_or_register_key("get_defense_notification")
static var get_power_notification_key: FastKey = FastKey.get_or_register_key("get_power_notification")
static var tweak_damage_notification_key: FastKey = FastKey.get_or_register_key("tweak_damage_notification")

const min_damage: int = -999
const max_damage: int = 999


func predict(target: Tile) -> int:
	var attacker: Node = get_parent()
	while not attacker is Unit:
		attacker = attacker.get_parent()
	var defender: Unit = target.content
	
	## Get the attackers base attack stat considering
	## mission items, support check, status check, and equipment, etc
	var attack: int = get_stat(attacker, defender, Global.get_or_register_signal(get_attack_notification_key), 0)
	
	## Get the targets base defense stat considering
	## mission items, support check, status check, and equipment, etc
	var defense: int = get_stat(attacker, defender, Global.get_or_register_signal(get_defense_notification_key), 0)
	
	## Calculate base damage
	@warning_ignore("integer_division")
	var damage: int = attack - (defense / 2)
	damage = max(damage, 1)
	
	## Get the abilities power stat considering possible variations
	var power: int = get_stat(attacker, defender, Global.get_or_register_signal(get_power_notification_key), 0)
	
	## Apply power bonus power is the percent power it does (e.g. 100 will do 100% full damage)
	@warning_ignore("integer_division")
	damage = power * damage / 100
	damage = max(damage, 1)
	
	## Tweak the damage based on a variety of other checks like
	## Elemental damage, Critical Hits, Damage multipliers, etc.
	damage = get_stat(attacker, defender, Global.get_or_register_signal(tweak_damage_notification_key), damage)
	
	## Clamp the damage to a range
	damage = clamp(damage, min_damage, max_damage)
	return damage


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
	stat.set_stat(StatTypes.Stat.HP, stat.get_stat(StatTypes.Stat.HP) - value)
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
