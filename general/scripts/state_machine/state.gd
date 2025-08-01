class_name State extends Node

func enter() -> void:
	add_listeners()

func exit() -> void:
	remove_listeners()

func _exit_tree() -> void:
	remove_listeners()

func add_listeners() -> void:
	pass

func remove_listeners() -> void:
	pass
