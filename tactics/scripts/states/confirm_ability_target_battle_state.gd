extends BattleState

@export var performAbilityState:State
@export var abilityTargetState:State

var tiles
var aa: AbilityArea
var index: int = 0
var targeters: Array[AbilityEffectTarget]

func enter() -> void:
	super()
	## Enable the AbilityPower to listen to the signals
	var ap: BaseAbilityPower = turn.ability.get_node("AbilityPower")
	ap.on_enable()
	
	var filtered = turn.ability.get_children().filter(func(node): return node is AbilityArea)
	aa = filtered[0]
	tiles = aa.get_tiles_in_area(level, pos)
	select_tiles(tiles)
	find_targets()
	refresh_primary_stat_panel(turn.actor.tile.pos)
	if turn.targets.size() > 0:
		## Only show this UI for Human controller units
		if driver.current == Drivers.Dri.Human:
			hit_success_indicator.show()
		set_target(0)
	
	## Only show this UI for AI controlled Units
	if driver.current == Drivers.Dri.Computer:
		computer_display_ability_selection()


func exit() -> void:
	super()
	deselect_tiles(tiles)
	
	await stat_panel_controller.hide_primary()
	await stat_panel_controller.hide_secondary()
	if driver.current == Drivers.Dri.Human:
		hit_success_indicator.hide()
	
	## Disable the AbilityPower to listen to the signals
	## Prevents different Abilities listening to the game event bus signal
	var ap: BaseAbilityPower = turn.ability.get_node("AbilityPower")
	ap.on_disable()


func computer_display_ability_selection() -> void:
	_owner.battle_message_contoller.display(turn.ability.name)
	await _owner.battle_message_contoller.finished
	_owner.change_state(performAbilityState)


func OnMove(e: Vector2i) -> void:
	if(e.x > 0 || e.y < 0):
		set_target(index + 1)
	else:
		set_target(index - 1)


func OnFire(e: int) -> void:
	if(e == 0):
		if (turn.targets.size() > 0):
			_owner.state_machine.change_state(performAbilityState)
	else:
		_owner.state_machine.change_state(abilityTargetState)


func on_mouse_click(_tile_pos: Tile, _button: int) -> void:
	if _button >= 0:
		OnFire(_button)


func find_targets() -> void:
	turn.targets = []
	#var children: Array[Node] = turn.ability.get_children()
	#targeters.assign(children.filter(func(node): return node is AbilityEffectTarget))
	targeters.assign(get_targeters(turn.ability))
	
	for tile in tiles:
		if(is_target(tile, targeters)):
			turn.targets.append(tile)


func get_targeters(node: Node) -> Array[AbilityEffectTarget]:
	var ret_value: Array[AbilityEffectTarget]
	for c in node.get_children():
		if c is AbilityEffectTarget:
			ret_value.append(c)
		else:
			ret_value.append_array(get_targeters(c))
	return ret_value


func is_target(tile: Tile, list: Array[AbilityEffectTarget]) -> bool:
	for item in list:
		if(item.is_target(tile)):
			return true
	return false


func set_target(target: int) -> void:
	index = target
	if index < 0:
		index = turn.targets.size() - 1
	elif index >= turn.targets.size():
		index = 0
	if turn.targets.size() > 0:
		refresh_secondary_stat_panel(turn.targets[index].pos)
		update_hit_success_indicator()
		#select_tile(turn.targets[index].pos)


func update_hit_success_indicator() -> void:
	var chance: int = 0
	var amount: int = 0
	var target: Tile = turn.targets[index]
	
	for i in targeters.size():
		if targeters[i].is_target(target):
			var hit_rate: HitRate = targeters[i].get_node("../HitRate")
			chance = hit_rate.calculate(target)
			
			var effect: BaseAbilityEffect = targeters[i].get_node("../AbilityEffect")
			amount = effect.predict(target)
			break
	
	hit_success_indicator.set_stats(chance, amount)


#func Zoom(scroll: int):
	#_owner.cameraController.Zoom(scroll)
  #
#func Orbit(direction: Vector2):
	#_owner.cameraController.Orbit(direction)
