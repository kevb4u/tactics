class_name TacticsState extends State

var _owner: Tactics

var units: Array[Unit]:
	get:
		return _owner.units

#var stat_panel_controller: StatPanelController:
	#get:
		#return _owner.stat_panel_controller

var pos: Vector2i:
	get:
		return _owner.pos

var level: Level:
	get:
		return _owner


func _ready() -> void:
	_owner = get_node("../../")


func add_listeners():
	_owner.input_controller.move_event.connect(OnMove)
	_owner.input_controller.button_event.connect(OnFire)
	_owner.input_controller.mouse_event.connect(on_mouse_click)
	_owner.input_controller.quit_event.connect(OnQuit)


func remove_listeners():
	_owner.input_controller.move_event.disconnect(OnMove)
	_owner.input_controller.button_event.disconnect(OnFire)
	_owner.input_controller.mouse_event.disconnect(on_mouse_click)
	_owner.input_controller.quit_event.disconnect(OnQuit)


func OnMove(_e: Vector2i):
	#print(e)
	pass


func OnFire(_e: int):
	#print(e)
	pass


func on_mouse_click(_tile_pos: Tile, _button: int) -> void:
	return


func select_tile(p: Vector2i):
	if level.pos == p:
		return
	
	level.pos = p


func OnQuit():
	pass
	#get_tree().quit()


#func refresh_primary_stat_panel(p: Vector2i):
	#var target: Unit = get_unit(p)
	#if target != null:
		#stat_panel_controller.show_primary(target)
	#else:
		#stat_panel_controller.hide_primary()


func get_unit(p: Vector2i) -> Unit:
	var t: Tile = level.get_tile(p)
	if t== null || t.content == null:
		return null
	if t.content is Unit:
		return t.content
	return null
