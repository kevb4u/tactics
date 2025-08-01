extends BattleState

var tiles: Array[Tile] = []
@export var MoveSequenceState: State
@export var commandSelectionState: State

func enter() -> void:
	super()
	var mover: Movement = turn.actor.get_node("Movement")
	tiles = mover.get_tiles_in_range(_owner.level, null)
	select_tiles(tiles)
	refresh_primary_stat_panel(_owner.level.pos)
	
	if driver.current == Drivers.Dri.Computer:
		computer_highlight_move_target()


func exit() -> void:
	super()
	deselect_tiles(tiles)
	tiles = []
	
	await stat_panel_controller.hide_primary()


func computer_highlight_move_target() -> void:
	var cursor_pos: Vector2i = pos
	while cursor_pos != turn.plan.move_location:
		if cursor_pos.x < turn.plan.move_location.x:
			cursor_pos.x += 1;
		if cursor_pos.x > turn.plan.move_location.x:
			cursor_pos.x -= 1;
		if cursor_pos.y < turn.plan.move_location.y:
			cursor_pos.y+= 1;
		if cursor_pos.y > turn.plan.move_location.y:
			cursor_pos.y -= 1;
		select_tile(cursor_pos);
		await get_tree().create_timer(0.25).timeout
	_owner.change_state(MoveSequenceState)


func OnMove(e: Vector2i):
	var rotatedPoint = _owner.camera_controller.adjust_movement(e)
	select_tile(rotatedPoint + _owner.level.pos)
	refresh_primary_stat_panel(_owner.level.pos)


func OnFire(e:int):
	if e == 0:
		if tiles.has(_owner.current_tile):
			_owner.state_machine.change_state(MoveSequenceState)
	elif e > 0:
		_owner.state_machine.change_state(commandSelectionState)


func on_mouse_click(_tile_pos: Tile, _button: int) -> void:
	if _tile_pos:
		if _button == 0 || _button == 2:
			select_tile(_tile_pos.pos)
			refresh_primary_stat_panel(_owner.level.pos)
		if _button != 2:
			OnFire(_button)
