class_name BattleMessageController extends Node

signal finished

const invisible_color: Color = Color(1, 1, 1, 0)

@export var label: Label
@export var panel: Panel


func _ready() -> void:
	panel.modulate = invisible_color


func display(message: String) -> void:
	label.text = message
	panel.modulate = Color.WHITE
	
	var tween: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(panel, "modulate", Color.WHITE, 0.5)
	await tween.finished
	
	await get_tree().create_timer(1).timeout
	
	var tween_out: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween_out.tween_property(panel, "modulate", invisible_color, 0.5)
	await tween_out.finished
	
	finished.emit()
