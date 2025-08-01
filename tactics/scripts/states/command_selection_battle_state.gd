extends BaseAbilityMenuState

@export var moveTargetState: State
@export var categorySelectionState: State
@export var selectUnitState: State
@export var abilityTargetState: State
@export var exploreState: State
@export var endFacingState: State

func enter() -> void:
	super()
	stat_panel_controller.show_primary(turn.actor)
	ability_menu_panel_controller.selected.connect(confirm)
	
	if driver.current == Drivers.Dri.Computer:
		computer_turn()


func exit() -> void:
	super()
	await stat_panel_controller.hide_primary()
	ability_menu_panel_controller.selected.disconnect(confirm)


func load_menu() -> void:
	if(menu_options.size() == 0):
		menu_title = "Commands"
		menu_options.append("Move")
		menu_options.append("Action")
		menu_options.append("Wait")
		menu_options.append("Flee")
	
	ability_menu_panel_controller.show(menu_title, menu_options)
	ability_menu_panel_controller.set_locked(0, turn.has_unit_moved)
	ability_menu_panel_controller.set_locked(1, turn.has_unit_acted)


func computer_turn() -> void:
	if turn.plan == null:
		turn.plan = _owner.cpu.evaluate()
		turn.ability = turn.plan.ability
	
	await get_tree().create_timer(1).timeout
	
	if turn.has_unit_moved == false and turn.plan.move_location != turn.actor.tile.pos:
		_owner.change_state(moveTargetState)
	elif turn.has_unit_acted == false and turn.plan.ability != null:
		_owner.change_state(abilityTargetState)
	else:
		_owner.change_state(endFacingState)


## When we press a button to confirm, 
## we change state based on which menu item is selected.
func confirm(selection: int):
	match selection:
		0:
			_owner.change_state(moveTargetState)
		1:
			_owner.change_state(categorySelectionState)
		2:
			_owner.change_state(endFacingState)
		3:
			_owner.end_battle()


## If we’ve already moved and it is still undoable( i.e. we haven’t attacked),
## our move will undo. Otherwise we will switch to the Explore State.
func cancel():
	if(turn.has_unit_moved && !turn.lock_move):
		turn.undo_move()
		ability_menu_panel_controller.set_locked(0, false)
		select_tile(turn.actor.tile.pos)
	else:
		_owner.change_state(exploreState)
