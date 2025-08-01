extends BattleState

@export var selectUnitState:BattleState
@export var commandSelectionState:BattleState

var start_dir: Directions.Dirs

func enter() -> void:
	super()
	_owner.turn_order_controller.update_ctr(turn.actor)
	
	start_dir = turn.actor.dir
	var mouse_tile: Tile = Global.get_tile_mouse_postion_3d()
	if mouse_tile:
		turn.actor.dir = Directions.get_directions(turn.actor.tile, mouse_tile)
	select_tile(turn.actor.tile.pos)
	
	_owner.facing_indicator_2d.set_active(true)
	_owner.facing_indicator_2d.set_direction(turn.actor.dir)
	_owner.facing_indicator_3d.set_active(true)
	_owner.facing_indicator_3d.set_direction(turn.actor.dir)
	
	if driver.current == Drivers.Dri.Computer:
		computer_control()


func exit() -> void:
	super()
	turn.plan = null
	_owner.facing_indicator_2d.set_active(false)
	_owner.facing_indicator_3d.set_active(false)


func computer_control() -> void:
	await get_tree().create_timer(0.5)
	turn.actor.dir = _owner.cpu.determine_end_facing_direction()
	turn.actor.match_with_tile()
	_owner.facing_indicator_2d.set_direction(turn.actor.dir)
	_owner.facing_indicator_3d.set_direction(turn.actor.dir)
	await get_tree().create_timer(0.5)
	_owner.change_state(selectUnitState)


func OnMove(e: Vector2i) -> void:
	var rotated_point = _owner.camera_controller.adjust_movement(e)
	turn.actor.dir = Directions.to_dir(rotated_point)
	turn.actor.match_with_tile()
	_owner.facing_indicator_2d.set_direction(turn.actor.dir)
	_owner.facing_indicator_3d.set_direction(turn.actor.dir)


func OnFire(e: int) -> void:
	match e:
		0:
			_owner.state_machine.change_state(selectUnitState)
		1:
			turn.actor.dir = start_dir
			turn.actor.match_with_tile()
			_owner.facing_indicator_2d.set_direction(turn.actor.dir)
			_owner.facing_indicator_3d.set_direction(turn.actor.dir)
			if turn.has_unit_acted:
				commandSelectionState.cancel()
			
			_owner.turn_order_controller.update_ctr(turn.actor, true)
			
			_owner.state_machine.change_state(commandSelectionState)


func on_mouse_click(_tile_pos: Tile, _button: int) -> void:
	if _tile_pos and _tile_pos != turn.actor.tile:
		turn.actor.dir = Directions.get_directions(turn.actor.tile, _tile_pos)
		turn.actor.match_with_tile()
		_owner.facing_indicator_2d.set_direction(turn.actor.dir)
		_owner.facing_indicator_3d.set_direction(turn.actor.dir)
	OnFire(_button)


#func Zoom(scroll: int):
	#_owner.cameraController.Zoom(scroll)
  #
#func Orbit(direction: Vector2):
	#_owner.cameraController.Orbit(direction)
