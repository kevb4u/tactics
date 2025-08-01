extends BattleState

@export var commandSelectionState: State

func enter() -> void:
	super()
	refresh_primary_stat_panel(_owner.level.pos)
	#refresh_secondary_stat_panel(_owner.levl.pos)


func exit() -> void:
	super()
	await stat_panel_controller.hide_primary()
	#await stat_panel_controller.hide_secondary()


func OnMove(e:Vector2i) -> void:
	var rotatedPoint = _owner.camera_controller.adjust_movement(e)
	select_tile(rotatedPoint + _owner.level.pos)
	refresh_primary_stat_panel(_owner.level.pos)
	#refresh_secondary_stat_panel(_owner.levl.pos)


func OnFire(e:int) -> void:
	#print("Fire: " + str(e))
	if e == 0:
		_owner.state_machine.change_state(commandSelectionState)


func on_mouse_click(tile_pos: Tile, button: int) -> void:
	if button > 0:
		select_tile(tile_pos.pos)
		refresh_primary_stat_panel(_owner.level.pos)
	elif button == 0:
		_owner.state_machine.change_state(commandSelectionState)
		
