class_name SceneComponent extends Node

signal finished
var _owner: Node

func start() -> void:
	finish()


func finish() -> void:
	finished.emit()
