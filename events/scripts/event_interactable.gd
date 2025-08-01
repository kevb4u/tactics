class_name EventInteractable extends Interactable

var game_object: GameObject
var events: Array[Event]

func _ready() -> void:
	z_index = 0
	for c in get_children():
		if c is Event:
			events.append(c)
		elif c is GameObject:
			game_object = c
	game_object.sprite_2d = $Sprite2D
	Global.game_controller.level_loaded.connect(init)
	


func init() -> void:
	var _temp_parent: Node3D = Node3D.new()
	var sprite_3d: Sprite3D = Sprite3D.new()
	_temp_parent.add_child(sprite_3d)
	Global.game_controller.current_3d_scene.add_child(_temp_parent)
	game_object.sprite_3d = sprite_3d


func interact(interacter: Entity) -> void:
	var e: Array[Event] = can_perform_events()
	if e.size() > 0:
		var event: Event = e.pick_random()
		event.start()


func can_perform_events() -> Array[Event]:
	var e: Array[Event]
	for _e in events:
		if _e.can_perform():
			e.append(_e)
	return e
