extends BattleState

@export var commandSelectionState: State
var index:int = -1

func enter():
	super()
	change_current_unit()


func change_current_unit():
	turn_controller.round_resume.emit()
	select_tile(turn.actor.tile.pos)
	_owner.state_machine.change_state(commandSelectionState)
