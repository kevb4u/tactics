class_name BaseAbilityPower extends Node

func _ready() -> void:
	name = "AbilityPower"


func on_enable() -> void:
	Global.get_or_register_signal(DamageAbilityEffect.get_attack_notification_key).connect(on_get_base_attack)
	Global.get_or_register_signal(DamageAbilityEffect.get_defense_notification_key).connect(on_get_base_defense)
	Global.get_or_register_signal(DamageAbilityEffect.get_power_notification_key).connect(on_get_power)


func on_disable() -> void:
	Global.get_or_register_signal(DamageAbilityEffect.get_attack_notification_key).disconnect(on_get_base_attack)
	Global.get_or_register_signal(DamageAbilityEffect.get_defense_notification_key).disconnect(on_get_base_defense)
	Global.get_or_register_signal(DamageAbilityEffect.get_power_notification_key).disconnect(on_get_power)


func on_get_base_attack(info: Info.Info3) -> void:
	if info.arg0 != get_unit():
		return
	var mod: AddValueModifier = AddValueModifier.new(0, get_base_attack())
	info.arg2.append(mod)


func on_get_base_defense(info: Info.Info3) -> void:
	if info.arg0 != get_unit():
		return
	
	var mod: AddValueModifier = AddValueModifier.new(0, get_base_defense(info.arg1))
	info.arg2.append(mod)


func on_get_power(info: Info.Info3) -> void:
	if info.arg0 != get_unit():
		return
	
	var mod: AddValueModifier = AddValueModifier.new(0, get_power())
	info.arg2.append(mod)


func get_base_attack() -> int:
	return 0


func get_base_defense(_target: Unit) -> int:
	return 0


func get_power() -> int:
	return 0


func get_unit() -> Unit:
	var _owner: Node = get_parent()
	while not _owner is Unit:
		_owner = _owner.get_parent()
	return _owner
