class_name BaseAbilityPicker extends Node

var _owner: Unit
var ac: AbilityCatalog

func start() -> void:
	var temp_owner = get_parent()
	while not temp_owner is Unit:
		temp_owner = temp_owner.get_parent()
	_owner = temp_owner
	
	ac = _owner.ability_catalog


func pick(plan: PlanOfAttack) -> void:
	pass


func find(ability_name: String) -> Ability:
	start()
	
	var category_count: int = ac.category_count()
	for i in category_count:
		var has_ability: bool = ac.get_category(i).has_node(ability_name)
		if has_ability:
			return ac.get_category(i).find_child(ability_name)
	return null


func default() -> Ability:
	return _owner.get_node("Attack")
