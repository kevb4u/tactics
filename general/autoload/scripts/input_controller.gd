class_name InputController extends Node

signal move_event(point: Vector2i)
signal mouse_event(tile_pos: Tile, button: int)
signal button_event(button: int)
signal quit_event()

var buttons = ['button_1','button_2','button_3','button_4']

var _hor: Repeater = Repeater.new('left', 'right')
var _ver: Repeater = Repeater.new('up', 'down')


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_event.emit(Global.get_tile_mouse_postion_3d(), -1)


func _process(_delta) -> void:
	var x = _hor.update()
	var y = _ver.update()
	
	if x != 0 || y != 0:
		move_event.emit(Vector2i(x,y))
	
	for i in range(buttons.size()):
		if Input.is_action_just_pressed(buttons[i]):
			button_event.emit(i)
	
	if Input.is_action_just_pressed('esc'):
		quit_event.emit()
	
	if Input.is_action_just_pressed("left_click"):
		emit_mouse(0)
	elif Input.is_action_just_pressed("right_click"):
		emit_mouse(1)
	elif Input.is_action_just_pressed("middle_click"):
		emit_mouse(2)
	
	if Input.is_action_just_pressed("test"):
		Global.game_controller.player_manager.player.unit.inventory.use_item(0)


func emit_mouse(button: int) -> void:
	var mouse_tile: Tile = Global.get_tile_mouse_postion_3d()
	if mouse_tile == null:
		var battle_controller: BattleController = Global.game_controller.battle_controller
		if battle_controller.in_battle:
			mouse_tile = battle_controller.turn.start_tile
		else:
			mouse_tile = Global.game_controller.player_manager.player.unit.tile
	mouse_event.emit(mouse_tile, button)
