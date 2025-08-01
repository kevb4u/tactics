class_name FeedbackUIPanel extends Node2D

const AI_STAT_PANEL = preload("uid://b3qeqy8eqdfkj")

@onready var ai_stat_container: VBoxContainer = $Control/PanelContainer/AIStatContainer

func _ready() -> void:
	for c in ai_stat_container.get_children():
		ai_stat_container.remove_child(c)
	visible = false
	pass


func add_stat(link_stat : AIStat, initial_value : float) -> AIStatPanel:
	visible = true
	var ai_stat_panel : AIStatPanel = AI_STAT_PANEL.instantiate()
	ai_stat_container.add_child(ai_stat_panel)
	ai_stat_panel.bind(link_stat, initial_value)
	return ai_stat_panel
