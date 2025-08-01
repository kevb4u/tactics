class_name TurnOrderController extends Node

const show_key: String = "Show"
const hide_key: String = "Hide"

@export var turn_order_panel: TurnOrderPanel

func show() -> void:
	_enable_node(turn_order_panel)
	await turn_order_panel.set_position(show_key, true)
	scroll_to_bottom_in_n_frames(turn_order_panel, 3)


func scroll_to_bottom_in_n_frames(scroll_container, n: int):
	if n <= 0:
		@warning_ignore("narrowing_conversion")
		scroll_container.scroll_horizontal = scroll_container.get_h_scroll_bar().max_value
	else:
		scroll_to_bottom_in_n_frames.call_deferred(scroll_container, n - 1)


func hide() -> void:
	await turn_order_panel.set_position(hide_key, true)
	turn_order_panel.set_position(hide_key, false)
	_disable_node(turn_order_panel)


func _enable_node(node: Node) -> void:
	node.process_mode = Node.PROCESS_MODE_INHERIT
	node.show()


func _disable_node(node: Node) -> void:
	node.process_mode = Node.PROCESS_MODE_DISABLED
	node.hide()

## This is the minimum value the CTR stat needs to hit
## before a character is able to take a turn.
static var turn_activation: int = 0

## This is the minimum value that CTR is set back once a turn is finished.
static var turn_cost: int = 500

## Additional amount that CTR is set back if a unit moves. 
## If they choose not to move, their next turn may come more quickly.
static var move_cost: int = 300

## Additional amount that CTR is set back if a unit takes an action. 
## If they choose not to take an action, their next turn may come more quickly.
static var action_cost: int = 200

signal round_began_notification
signal turn_check_notification(unit: Unit, exc: BaseException)
signal turn_began_notification(unit: Unit)
signal turn_completed_notification(unit: Unit)
signal round_ended_notification
signal round_resume

var og_ctr: int = 0

#TODO: FIGURE OUT IF THIS TURN SYSTEM IS RIGHT FOR MY GAME
func _ready() -> void:
	hide()


var tile_ctr: int

func turn_round() -> void:
	var bc: BattleController = get_parent()
	await round_resume
	
	## Reset the CTR stat to be zero
	var _units: Array[Unit] = bc.units.duplicate()
	for unit in _units:
		var s: Stats = unit.get_node("Stats")
		s.set_stat(StatTypes.Stat.CTR, 0)
	tile_ctr = 0
	
	## Start Turn loop
	while bc.in_battle:
		round_began_notification.emit()
		
		var units: Array[Unit] = bc.units.duplicate()
		for unit in units:
			var s: Stats = unit.get_node("Stats")
			s.set_stat(StatTypes.Stat.CTR, s.get_stat(StatTypes.Stat.CTR) - s.get_stat(StatTypes.Stat.SPD))
		tile_ctr -= 125
		
		update_turn_order(units.duplicate())
		
		for unit in units:
			if(can_take_turn(unit)):
				bc.turn.change(unit)
				turn_began_notification.emit(unit)
				var s: Stats = unit.get_node("Stats")
				og_ctr = s.get_stat(StatTypes.Stat.CTR)
				update_ctr(unit, true)
				await round_resume
				update_ctr(unit)
				turn_completed_notification.emit(unit)
				update_turn_order(units.duplicate())
		
		
		if tile_ctr <= turn_activation:
			Global.get_or_register_signal(Tile.tile_status_key).emit()
			tile_ctr += move_cost + action_cost + turn_cost
		
		round_ended_notification.emit()


func update_ctr(unit: Unit, max_cost: bool = false) -> void:
	var bc: BattleController = get_parent()
	var s: Stats = unit.get_node("Stats")
	var cost: int = turn_cost
	## TODO: cost = 0 if spell ability was used
	if bc.turn.has_unit_moved || max_cost:
		cost += move_cost
	if bc.turn.has_unit_acted || max_cost:
		cost += action_cost
	
	s.set_stat(StatTypes.Stat.CTR, og_ctr + cost, false)
	update_turn_order(bc.units.duplicate())


func update_turn_order(units: Array[Unit]) -> void:
	units.sort_custom(func(a,b): return get_counter(a) <= get_counter(b))
	turn_order_panel.update(units)


func can_take_turn(target: Unit) -> bool:
	var exc: BaseException = BaseException.new(get_counter(target) <= turn_activation)
	turn_check_notification.emit(target, exc)
	return exc.toggle


func get_counter(target: Unit) -> int:
	var s: Stats = target.get_node("Stats")
	return s.get_stat(StatTypes.Stat.CTR)
