extends BattleState

@export var endBattleState: State
@export var selectUnitState: State
@export var data: Array[ConversationData]
var current_conversation: int = 0

func _ready() -> void:
	super()


func add_listeners() -> void:
	super()
	_owner.conversation_controller.complete_event.connect(on_complete_conversation)


func remove_listeners() -> void:
	super()
	_owner.conversation_controller.complete_event.disconnect(on_complete_conversation)


func enter():
	super()
	if is_battle_over():
		if did_player_win():
			current_conversation = 2
		else:
			current_conversation = 1
	else:
		current_conversation = 0
	
	Global.start_conversation(data[current_conversation])


func exit() -> void:
	super()
	_owner.turn_order_controller.show()
	await _owner.conversation_controller.end()


func OnFire(e: int):
	super(e)
	_owner.conversation_controller.next()


func on_mouse_click(_tile_pos: Tile, _button: int) -> void:
	if _button >= 0:
		OnFire(_button)


func on_complete_conversation() -> void:
	if is_battle_over():
		_owner.state_machine.change_state(endBattleState)
	else:
		_owner.state_machine.change_state(selectUnitState)
