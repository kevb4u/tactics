class_name MinValueModifier extends ValueModifier

var min: float

func _init(_sort_order: int, _min: float) -> void:
	super(_sort_order)
	min = _min


func modify(_from_value: float, to_value: float) -> float:
	return min(to_value, min)
