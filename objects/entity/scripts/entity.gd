class_name Entity extends EventInteractable

var ENTITY_3D := preload("uid://dc31ehk2tr85o")

@onready var sprite: Sprite2D = $Sprite2D
@onready var unit: Unit = $Unit
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var individual_blackboard: BlackboardManager.Blackboard

func _ready() -> void:
	super()
	z_index = 0
	unit.entity = self
	individual_blackboard = BlackboardManager.get_individual_blackboard(self)
	
	Global.game_controller.save_manager.on_save.connect(on_save)
	Global.game_controller.save_manager.on_load.connect(on_load)


func init() -> void:
	if unit.entity_3d == null:
		var entity_3d: Entity3D = ENTITY_3D.instantiate()
		Global.game_controller.current_3d_scene.add_child(entity_3d)
		entity_3d.sync(self)
	Global.game_controller.level_loaded.disconnect(init)


func on_save() -> void:
	individual_blackboard.set_value(FastKey.get_or_register_key("pos_x"), global_position.x)
	individual_blackboard.set_value(FastKey.get_or_register_key("pos_y"), global_position.y)
	individual_blackboard.set_value(FastKey.get_or_register_key("stats"), [])


func on_load() -> void:
	var pos_x: float = individual_blackboard.get_float(FastKey.get_or_register_key("pos_x"))
	var pos_y: float = individual_blackboard.get_float(FastKey.get_or_register_key("pos_y"))
	global_position = Vector2(pos_x, pos_y)
