class_name MaxValueModifier extends ValueModifier

var max: float

func _init(_sort_order: int, _max: float) -> void:
	super(_sort_order)
	max = _max


func modify(_from_value: float, to_value: float) -> float:
	return max(to_value, max)
