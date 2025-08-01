extends BattleState

@export var confirmAbilityTargetState: State
@export var categorySelectionState: State

var tiles = []
var ar: AbilityRange

func enter() -> void:
	super()
	var filtered: Array[Node] = turn.ability.get_children().filter(func(node): return node is AbilityRange)
	ar = filtered[0]
	select_tiles_in_range()
	stat_panel_controller.show_primary(turn.actor)
	if(ar.direction_oriented):
		refresh_secondary_stat_panel(pos)
	
	if driver.current == Drivers.Dri.Computer:
		computer_highlight_target()


func exit() -> void:
	super()
	deselect_tiles(tiles)
	await stat_panel_controller.hide_primary()
	await stat_panel_controller.hide_secondary()


func computer_highlight_target() -> void:
	if ar.direction_oriented:
		change_direction(Directions.to_vector(turn.plan.attack_direction))
		await get_tree().create_timer(0.25).timeout
	else:
		var cursor_pos: Vector2i = pos
		while cursor_pos != turn.plan.fire_location:
			if cursor_pos.x < turn.plan.fire_location.x:
				cursor_pos.x += 1
			if cursor_pos.x > turn.plan.fire_location.x:
				cursor_pos.x -= 1
			if cursor_pos.y < turn.plan.fire_location.y:
				cursor_pos.y += 1
			if cursor_pos.y > turn.plan.fire_location.y:
				cursor_pos.y -= 1
			select_tile(cursor_pos)
			await get_tree().create_timer(0.25).timeout
	await get_tree().create_timer(0.5).timeout
	_owner.change_state(confirmAbilityTargetState)


func OnMove(e: Vector2i) -> void:
	var rotatedPoint = _owner.camera_controller.adjust_movement(e)
	if(ar.direction_oriented):
		change_direction(rotatedPoint)
	else:
		select_tile(rotatedPoint + pos)
		refresh_secondary_stat_panel(pos)


func OnFire(e: int) -> void:
	if(e == 0):
		if(ar.direction_oriented || tiles.has(level.get_tile(pos))):
			_owner.state_machine.change_state(confirmAbilityTargetState)
	elif e > 0:
		_owner.state_machine.change_state(categorySelectionState)


func on_mouse_click(_tile_pos: Tile, _button: int) -> void:
	if _tile_pos:
		if _button == 0 || _button == 2:
			select_tile(_tile_pos.pos)
			refresh_primary_stat_panel(_owner.level.pos)
		if _button != 2:
			OnFire(_button)


func change_direction(p: Vector2i) -> void:
	var dir: Directions.Dirs = Directions.to_dir(p)
	if(turn.actor.dir != dir):
		deselect_tiles(tiles)
		turn.actor.dir = dir
		turn.actor.match_with_tile()
		select_tiles_in_range()


func select_tiles_in_range() -> void:
	tiles = ar.get_tiles_in_range(level)
	select_tiles(tiles)


#func Zoom(scroll: int):
	#_owner.cameraController.Zoom(scroll)
  #
#func Orbit(direction: Vector2):
	#_owner.cameraController.Orbit(direction)
