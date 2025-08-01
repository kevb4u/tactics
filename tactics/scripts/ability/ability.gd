class_name Ability extends Node

static var ability_key: FastKey = FastKey.get_or_register_key("ability_key")
static var ability_blackboard: BlackboardManager.Blackboard = BlackboardManager.get_shared_blackboard(ability_key.hashed_key)

signal can_perform_check(exc: BaseException)
signal failed_notification
signal did_perform_notification

@onready var ability_range: AbilityRange = $AbilityRange
@onready var ability_area: AbilityArea = $AbilityArea
@onready var ability_power: BaseAbilityPower = $AbilityPower

func can_perform() -> bool:
	var exc: BaseException = BaseException.new(true)
	can_perform_check.emit(exc)
	return exc.toggle


func is_target(tile: Tile) -> bool:
	for i in get_child_count():
		var componenet: Node = get_child(i)
		for j in componenet.get_child_count():
			if componenet.get_child(j) is AbilityEffectTarget:
				var target: AbilityEffectTarget = componenet.get_child(j)
				if target.is_target(tile):
					return true
	return false


func perform(targets: Array[Tile]) -> void:
	if can_perform() == false:
		failed_notification.emit()
		return
	
	for i in targets.size():
		perform_on_target(targets[i])
	
	did_perform_notification.emit()


func perform_on_target(target: Tile) -> void:
	for child in get_children():
		if child is BaseAbilityEffect:
			perform_ability(target, child, child.get_parent().get_node("HitRate"))
		else:
			for c in child.get_children():
				if c is BaseAbilityEffect:
					perform_ability(target, c, c.get_parent().get_node("HitRate"))


func perform_ability(target: Tile, effect: BaseAbilityEffect, hit_rate: HitRate) -> void:
	var chance: int = hit_rate.calculate(target)
	if randi_range(0, 101) > chance:
		effect.missed_notification.emit()
		return
	var value: int = effect.apply(target)
	effect.hit_notification.emit(value)


func create_ability(ability: AbilityResource) -> Ability:
	var ret_ability: Ability
	var result: Dictionary = ability_blackboard.try_get(FastKey.get_or_register_key(ability.ability_name), ret_ability)
	ret_ability = result.result
	
	if result.did_get == false:
		ret_ability = Node.new()
		ret_ability.name = ability.ability_name
		
		var ability_range = Node.new()
		ability_range.set_script(ability.ability_range)
		ret_ability.add_child(ability_range)
		
		var ability_area = Node.new()
		ability_area.set_script(ability.ability_area)
		ret_ability.add_child(ability_area)
		
		if ability.ability_cost > 0:
			var mana_cost = AbilityMagicCost.new()
			mana_cost.amount = ability.ability_cost
			ret_ability.add_child(mana_cost)
		
		var ability_power
		if ability.ability_power_type == "Physical":
			ability_power = PhysicalAbilityPower.new()
		else:
			ability_power = MagicalAbilityPower.new()
		ability_power.level = ability.ability_power
		ret_ability.add_child(ability_power)
		
		for ac in ability.ability_components:
			var sd
		
		
		ability_blackboard.set_generic(FastKey.get_or_register_key(ability.ability_name), ret_ability)
	
	return ret_ability.duplicate()
