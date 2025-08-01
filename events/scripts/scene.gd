class_name Scene extends Node

signal finished

var scene_components: Array[SceneComponent]
var _owner: Node

func _ready() -> void:
	_owner = get_parent().get_parent()
	for c in get_children():
		if c is SceneComponent:
			scene_components.append(c)
			c.finished.connect(finish)
			c._owner = _owner


func start() -> void:
	if scene_components.size() > 0:
		for s in scene_components:
			s.start()
	else:
		finish()


func finish() -> void:
	finished.emit()
