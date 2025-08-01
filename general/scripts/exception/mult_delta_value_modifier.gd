class_name MultDeltaModifier extends ValueModifier

var to_multiply: float

func _init(_sort_order: int, _to_multiply: float):
	super(_sort_order)
	to_multiply = _to_multiply


func modify(from_value: float, to_value: float) -> float:
	var delta: float = to_value - from_value
	return from_value + delta * to_multiply
