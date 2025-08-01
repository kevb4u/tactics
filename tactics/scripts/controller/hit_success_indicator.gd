class_name HitSuccessIndicator extends Node

const show_key: String = "Show"
const hide_key: String = "Hide"

@export var panel: LayoutAnchor
@export var arrow: Texture2D
@export var hit_rate_label: Label

func _ready() -> void:
	panel.visible = false


func set_stats(chance: int, amount: int) -> void:
	#print(str(chance / 100.0))
	hit_rate_label.text = "{0}% {1}pt(s)".format([chance, amount])


func show() -> void:
	panel.visible = true
	set_panel_pos(show_key)
	pass


func hide() -> void:
	panel.visible = false
	set_panel_pos(hide_key)
	pass


func set_panel_pos(_pos: String) -> void:
	pass
	#await panel
