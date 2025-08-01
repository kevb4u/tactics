class_name BaseAbilityMenuState extends BattleState

var menu_title: String
var menu_options: Array[String] = []

func enter() -> void:
	super()
	select_tile(turn.actor.tile.pos)
	
	if driver.current == Drivers.Dri.Human:
		await load_menu()


func exit() -> void:
	super()
	if driver.current == Drivers.Dri.Human:
		await ability_menu_panel_controller.hide()


func OnFire(e: int) -> void:
	if(e == 0):
		confirm(ability_menu_panel_controller.selection)
	else:
		cancel()


func OnMove(e: Vector2i) :
	if(e.x > 0 || e.y > 0):
		ability_menu_panel_controller.next()
	else:
		ability_menu_panel_controller.previous()


func on_mouse_click(_tile_pos: Tile, button: int) -> void:
	if button > 0:
		cancel()


func load_menu() -> void:
	pass


func confirm(_selection: int) -> void:
	pass


func cancel() -> void:
	pass
