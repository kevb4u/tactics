class_name Entity3D extends CharacterBody3D

@onready var sprite: Sprite3D = $Sprite3D

var unit: Unit

var individual_blackboard: BlackboardManager.Blackboard

func _ready() -> void:
	individual_blackboard = BlackboardManager.get_individual_blackboard(self)
	Global.game_controller.save_manager.on_save.connect(on_save)
	Global.game_controller.save_manager.on_load.connect(on_load)


func sync(entity: Entity) -> void:
	unit = entity.unit
	unit.entity_3d = self


func on_save() -> void:
	individual_blackboard.set_value(FastKey.get_or_register_key("pos_x"), global_position.x)
	individual_blackboard.set_value(FastKey.get_or_register_key("pos_y"), global_position.y)
	individual_blackboard.set_value(FastKey.get_or_register_key("pos_z"), global_position.z)
	individual_blackboard.set_value(FastKey.get_or_register_key("stats"), [])


func on_load() -> void:
	var pos_x: float = individual_blackboard.get_float(FastKey.get_or_register_key("pos_x"))
	var pos_y: float = individual_blackboard.get_float(FastKey.get_or_register_key("pos_y"))
	var pos_z: float = individual_blackboard.get_float(FastKey.get_or_register_key("pos_z"))
	global_position = Vector3(pos_x, pos_y, pos_z)
