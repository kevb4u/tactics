@tool
class_name Chest extends Interactable

@export_tool_button("Snap_to_grid") var snap = snap_to_grid

@onready var game_object: GameObject = $GameObject
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var item: ItemResource

var individual_blackboard: BlackboardManager.Blackboard
var is_open_key: FastKey

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	z_index = 0
	individual_blackboard = BlackboardManager.get_individual_blackboard(self)
	is_open_key = FastKey.get_or_register_key("is_open")
	var result: Dictionary = individual_blackboard.try_get(is_open_key, false, false)
	if result.result:
		animation_player.play("open")
	
	game_object.sprite_2d = $Sprite2D
	
	Global.game_controller.save_manager.on_save.connect(on_save)
	Global.game_controller.save_manager.on_load.connect(on_load)
	Global.game_controller.level_loaded.connect(init)


func init() -> void:
	var _temp_parent: Node3D = Node3D.new()
	var sprite_3d: Sprite3D = Sprite3D.new()
	sprite_3d.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	sprite_3d.alpha_cut = SpriteBase3D.ALPHA_CUT_OPAQUE_PREPASS
	sprite_3d.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	_temp_parent.add_child(sprite_3d)
	Global.game_controller.current_3d_scene.add_child(_temp_parent)
	game_object.sprite_3d = sprite_3d


func interact(interacter: Entity) -> void:
	var result: Dictionary = individual_blackboard.try_get(is_open_key, false, false)
	if result.result:
		return
	individual_blackboard.set_value(is_open_key, true)
	animation_player.play("opening")
	await animation_player.animation_finished
	if item:
		var _item: Item = Item.new(item)
		interacter.unit.inventory.add_child(_item)


func snap_to_grid() -> void:
	global_position = Vector2i(global_position.x, global_position.y)


func on_save() -> void:
	var result: Dictionary = individual_blackboard.try_get(is_open_key, false, false)
	individual_blackboard.set_value(is_open_key, result.result)


func on_load() -> void:
	var result: Dictionary = individual_blackboard.try_get(is_open_key, false, false)
	if result.result:
		animation_player.play("open")
	else:
		animation_player.play("closed")
