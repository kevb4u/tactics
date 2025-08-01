class_name GameController extends Node

signal level_loaded

@onready var world_3d: Node3D = %World3D
@onready var world_2d: Node2D = %World2D
@onready var gui: CanvasLayer = %GUI

@onready var camera_controller: CameraController = %CameraController
@onready var camera_controller_3d: CameraController3D = %CameraController3D

@onready var input_controller: InputController = %InputController
@onready var pool_controller: Node = %PoolController
@onready var event_bus: EventBus = %EventBus

@onready var conversation_controller: ConversationController = %ConversationController
@onready var battle_controller: BattleController = %BattleController

@onready var day_night_cycle: DayNightCycle = %DayNightCycle

var current_3d_scene
var current_2d_scene
var current_gui_scene

@onready var scene_button: Button = %SceneButton

## AUTOLOAD
static var player_manager: PlayerManager = PlayerManager.new()
static var save_manager: SaveManager = SaveManager.new()

func _ready() -> void:
	Global.game_controller = self
	
	## AUTOLOAD INIT
	add_child(player_manager)
	player_manager.init()
	
	## Start main scene
	## Create Dummy 3D
	change_3d_scene("uid://cqnt014rpjpyu")
	## Create 2D that controls both 2d and 3d
	change_2d_scene("uid://bebg02ynxqq0e")
	change_gui_scene("uid://cetkmhctfs2u1")
	player_manager.start()
	level_loaded.emit()
	
	$GUI/DayNightCycleUI.init()
	camera_controller.start_overworld()
	camera_controller_3d.start_overworld()
	scene_button.pressed.connect(_on_scene_pressed)
	_on_scene_pressed()
	_on_scene_pressed()


func change_3d_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	if current_3d_scene != null:
		if delete:
			current_3d_scene.queue_free() # Remove node entirely
		elif keep_running:
			current_3d_scene.visible = false # Keeps in memory and running
		else:
			gui.remove_child(current_3d_scene) # Keeps in memory, does not run
	var new = load(new_scene).instantiate()
	current_3d_scene = new
	world_3d.add_child(new)


func change_2d_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	if current_2d_scene != null:
		if delete:
			current_2d_scene.queue_free() # Remove node entirely
		elif keep_running:
			current_2d_scene.visible = false # Keeps in memory and running
		else:
			gui.remove_child(current_2d_scene) # Keeps in memory, does not run
	var new = load(new_scene).instantiate()
	current_2d_scene = new
	world_2d.add_child(new)


func change_gui_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	if current_gui_scene != null:
		if delete:
			current_gui_scene.queue_free() # Remove node entirely
		elif keep_running:
			current_gui_scene.visible = false # Keeps in memory and running
		else:
			gui.remove_child(current_gui_scene) # Keeps in memory, does not run
	var new = load(new_scene).instantiate()
	current_gui_scene = new
	gui.add_child(new)


func _on_scene_pressed() -> void:
	if scene_button.text == "2d":
		(current_3d_scene as Level3D).grid_map.iso_tile_map_sort = (current_2d_scene as Level).isometric_tile_map_sort
		(current_3d_scene as Level3D).create_from_isometric_tile_map_sort()
		(current_3d_scene as Level3D).sync(current_2d_scene)
		world_2d.visible = false
		world_3d.visible = true
		$World2D/CameraController/Camera2D.make_current()
		scene_button.text = "3d"
	else:
		world_2d.visible = true
		world_3d.visible = false
		$World3D/CameraController3D/Han/Pitch/Camera3D.make_current()
		scene_button.text = "2d"
