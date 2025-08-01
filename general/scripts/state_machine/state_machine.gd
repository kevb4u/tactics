class_name StateMachine extends Node

var _current_state: State

func change_state(new_state: State) -> void:
	if _current_state == new_state:
		return
	
	if _current_state:
		await _current_state.exit()
	_current_state = new_state
	
	if _current_state:
		await _current_state.enter()
	pass
