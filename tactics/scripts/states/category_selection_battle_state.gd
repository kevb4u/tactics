extends BaseAbilityMenuState

@export var commandSelectionState: State
@export var actionSelectionState: State
@export var abilityTargetState:State

func enter() -> void:
	super()
	stat_panel_controller.show_primary(turn.actor)
	ability_menu_panel_controller.selected.connect(confirm)


func exit() -> void:
	super()
	await stat_panel_controller.hide_primary()
	ability_menu_panel_controller.selected.disconnect(confirm)


func load_menu() -> void:
	if(menu_options.size() == 0):
		menu_title = "Action"
		menu_options.append("Attack")
		
		var catalog: AbilityCatalog = turn.actor.get_node("AbilityCatalog")
		for i in catalog.category_count():
			menu_options.append(catalog.get_category(i).name)

	ability_menu_panel_controller.show(menu_title, menu_options)


func confirm(selection: int) -> void:
	if selection == 0:
		attack()
	else:
		set_category(selection - 1)


func cancel() -> void:
	_owner.state_machine.change_state(commandSelectionState)


func attack() -> void:
	turn.ability = turn.actor.get_node("Attack")
	_owner.state_machine.change_state(abilityTargetState)


func set_category(index: int) -> void:
	actionSelectionState.category = index
	_owner.state_machine.change_state(actionSelectionState)
