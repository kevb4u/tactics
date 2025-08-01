class_name Event extends Node

signal finished

@export var conditions: Array[Condition]
var scenes: Array[Scene]
var current_scene: int = 0
var _owner: Node

func _ready() -> void:
	_owner = get_parent()
	for c in get_children():
		if c is Scene:
			scenes.append(c)
			


func can_perform() -> bool:
	for condition in conditions:
		if condition.can_perform() == false:
			return false
	return true


func start() -> void:
	current_scene = 0
	start_scene()


func start_scene(scene_index: int = current_scene) -> void:
	scenes[scene_index].finished.connect(on_scene_finished)
	scenes[scene_index].start()


func on_scene_finished() -> void:
	scenes[current_scene].finished.disconnect(on_scene_finished)
	current_scene += 1
	if current_scene < scenes.size():
		start_scene()
	else:
		finish()


func finish() -> void:
	finished.emit()
