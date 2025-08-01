class_name Tactics extends Level

@onready var state_machine: StateMachine = %StateMachine

@export var init_state: State
var input_controller: InputController

func start() -> void:
	
	input_controller = Global.game_controller.input_controller
	init_game_board()
	state_machine.change_state(init_state)
