class_name MultValueModifier extends ValueModifier

var to_multiply: float

func _init(_sort_order: int, _to_multiply: float):
	super(_sort_order)
	to_multiply = _to_multiply


func modify(_from_value: float, to_value: float) -> float:
	return to_value * to_multiply
