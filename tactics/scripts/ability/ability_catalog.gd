class_name AbilityCatalog extends Node

func category_count() -> int:
	return get_children().size()


func get_category(index: int) -> Node:
	if index < 0 || index >= category_count():
		return null
	return get_child(index)


func ability_count(category: Node) -> int:
	return category.get_children().size() if category != null else 0


func get_ability(category_index: int, ability_index: int) -> Ability:
	var category: Node = get_category(category_index)
	if category == null || ability_index < 0 || ability_index >= category.get_children().size():
		return null
	return category.get_child(ability_index)
	
