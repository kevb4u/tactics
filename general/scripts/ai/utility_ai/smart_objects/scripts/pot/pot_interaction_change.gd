class_name PotInteractionChange extends SimpleInteraction

var smart_object_pot : SmartObject_Pot

func _ready() -> void:
	for c in get_parent().get_children():
		if c is SmartObject_Pot:
			smart_object_pot = c
			break
	if smart_object_pot == null:
		printerr("NO SMART OBJECT POT ON::" + get_parent().name)
	pass

func perform(_performer : CommonAIBase, _on_completed : Callable) -> bool:
	smart_object_pot.toggle_state()
	return super.perform(_performer, _on_completed)
	
