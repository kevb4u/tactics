extends BaseAbilityMenuState

@export var abilityTargetState:State
@export var categorySelectionState:State

static var category: int
var catalog: AbilityCatalog

func enter() -> void:
	super()
	stat_panel_controller.show_primary(turn.actor)
	ability_menu_panel_controller.selected.connect(confirm)


func exit() -> void:
	super()
	await stat_panel_controller.hide_primary()
	ability_menu_panel_controller.selected.disconnect(confirm)


func load_menu() -> void:
	catalog = turn.actor.get_node("AbilityCatalog")
	var container: Node = catalog.get_category(category)
	
	var count: int = catalog.ability_count(container)
	
	menu_options.clear()
	
	var locks: Array[bool] = []
	for i in count:
		var ability: Ability = catalog.get_ability(category, i)
		var cost: AbilityMagicCost = ability.get_node("ManaCost")
		if cost:
			menu_options.append("{0}: {1}".format([ability.name, cost.amount]))
		else:
			menu_options.append(ability.name)
		locks.append(not ability.can_perform())
	
	ability_menu_panel_controller.show(menu_title, menu_options)
	for i in count:
		ability_menu_panel_controller.set_locked(i, locks[i])


func confirm(selection: int) -> void:
	turn.ability = catalog.get_ability(category, selection)
	_owner.state_machine.change_state(abilityTargetState)


func cancel() -> void:
	_owner.state_machine.change_state(categorySelectionState)


func set_options(options: Array[String]) -> void:
	menu_options.clear()
	for entry in options:
		menu_options.append(entry)
