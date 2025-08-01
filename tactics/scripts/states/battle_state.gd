class_name BattleState extends State

var _owner: BattleController
var driver: Driver

var ability_menu_panel_controller: AbilityMenuPanelController:
	get:
		return _owner.ability_menu_panel_controller

var turn: Turn: 
	get:
		return _owner.turn

var turn_controller: TurnOrderController:
	get:
		return _owner.turn_order_controller

var units: Array[Unit]:
	get:
		return _owner.units

var stat_panel_controller: StatPanelController:
	get:
		return _owner.stat_panel_controller

var hit_success_indicator: HitSuccessIndicator:
	get:
		return _owner.hit_success_indicator

var pos: Vector2i:
	get:
		return _owner.level.pos

var level: Level:
	get:
		return _owner.level

var level_3d: Level3D:
	get:
		return _owner.level_3d


func _ready():
	_owner = get_node("../../")


func enter() -> void:
	driver = turn.actor.get_node("Driver") if turn.actor != null else null
	super()


func add_listeners():
	if driver == null || driver.current == Drivers.Dri.Human:
		_owner.input_controller.move_event.connect(OnMove)
		_owner.input_controller.button_event.connect(OnFire)
		_owner.input_controller.mouse_event.connect(on_mouse_click)
		_owner.input_controller.quit_event.connect(OnQuit)


func remove_listeners():
	if driver == null || driver.current == Drivers.Dri.Human:
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
	if _owner.level.pos == p and _owner.level_3d.pos == p:
		return
	
	_owner.level.pos = p
	_owner.level_3d.pos = p


func select_tiles(tiles: Array[Tile]) -> void:
	_owner.level.select_tiles(tiles)
	_owner.level_3d.select_tiles(tiles)


func deselect_tiles(tiles: Array[Tile]) -> void:
	_owner.level.deselect_tiles(tiles)
	_owner.level_3d.deselect_tiles(tiles)


func OnQuit():
	Global.game_controller.battle_controller.end_battle()
	#get_tree().quit()


func refresh_primary_stat_panel(p: Vector2i):
	var target: Unit = get_unit(p)
	if target != null:
		stat_panel_controller.show_primary(target)
	else:
		stat_panel_controller.hide_primary()


func refresh_secondary_stat_panel(p: Vector2i):
	var target: Unit = get_unit(p)
	if target != null:
		stat_panel_controller.show_secondary(target)
	else:
		stat_panel_controller.hide_secondary()


func get_unit(p: Vector2i) -> Unit:
	var t: Tile = _owner.level.get_tile(p)
	if t== null || t.content == null:
		return null
	if t.content is Unit:
		return t.content
	return null


func did_player_win() -> bool:
	return _owner.get_node("VictoryCondition").victor == AllianceType.Alliances.Hero


func is_battle_over() -> bool:
	return _owner.get_node("VictoryCondition").victor != AllianceType.Alliances.None
