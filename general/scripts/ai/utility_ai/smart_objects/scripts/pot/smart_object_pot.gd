class_name SmartObject_Pot extends SmartObject

var is_changed : bool = false

func toggle_state() -> void:
	is_changed = not is_changed
	if is_changed:
		get_parent().modulate = Color.AQUA
	else:
		get_parent().modulate = Color.WHITE
	pass
