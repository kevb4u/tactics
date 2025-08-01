extends BattleState

@export var commandSelectionState: State
@export var endFacingState: State

func enter() -> void:
	super()
	sequence()


func sequence() -> void:
	var m: Movement = turn.actor.get_node("Movement")
	_owner.camera_controller.set_follow(turn.actor.entity)
	
	m.traverse(_owner.current_tile)
	await m.finished
	
	_owner.camera_controller.set_follow(_owner.level.marker)
	turn.has_unit_moved = true
	if turn.has_unit_acted:
		_owner.state_machine.change_state(endFacingState)
	else:
		_owner.state_machine.change_state(commandSelectionState)
