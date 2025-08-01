class_name BattleController extends Node

static var battle_start_key: FastKey = FastKey.get_or_register_key("battle_start")
static var battle_end_key: FastKey = FastKey.get_or_register_key("battle_end")

@export var state_machine: StateMachine
@export var start_state: State
@export var entity_prefrab: PackedScene
@export var entity_3d_prefrab: PackedScene
@export var stat_panel_controller: StatPanelController
@export var turn_order_controller: TurnOrderController
@export var hit_success_indicator: HitSuccessIndicator
@export var auto_status_controller: AutoStatusController
@export var cpu: ComputerPlayer
@export var battle_message_contoller: BattleMessageController

var in_battle: bool = false
@onready var init_battle_state: Node = $StateMachine/InitBattleState

var input_controller: InputController
var camera_controller: CameraController
var camera_controller_3d: CameraController3D
var conversation_controller: ConversationController
var pool_controller: Node
var level: Level
var level_3d: Level3D
var facing_indicator_2d: FacingIndicator
var facing_indicator_3d: FacingIndicator

var current_unit: Unit
var current_tile: Tile:
	get:
		return level.get_tile(level.pos)

@export var ability_menu_panel_controller: AbilityMenuPanelController
var turn: Turn = Turn.new()
var units: Array[Unit] = []

func start_battle(enemy: Entity) -> void:
	if in_battle:
		return
	
	stat_panel_controller.visible = true
	in_battle = true
	turn = Turn.new()
	units = []
	#%Test.OnEnable()
	level = Global.game_controller.current_2d_scene
	level_3d = Global.game_controller.current_3d_scene
	facing_indicator_2d = level.facing_indicator
	facing_indicator_3d = level_3d.facing_indicator
	
	
	input_controller = Global.game_controller.input_controller
	camera_controller = Global.game_controller.camera_controller
	camera_controller_3d = Global.game_controller.camera_controller_3d
	conversation_controller = Global.game_controller.conversation_controller
	pool_controller = Global.game_controller.pool_controller
	ability_menu_panel_controller.init()
	cpu.init()
	
	camera_controller.start_battle()
	camera_controller_3d.start_battle()
	Global.get_or_register_signal(battle_start_key).emit()
	
	init_battle_state.enemy = enemy
	state_machine.change_state(start_state)


func change_state(new_state: State) -> void:
	state_machine.change_state(new_state)


func end_battle() -> void:
	auto_status_controller.on_disable()
	camera_controller.start_overworld()
	turn_order_controller.hide()
	await state_machine.change_state(null)
	Global.get_or_register_signal(battle_end_key).emit()
	in_battle = false
