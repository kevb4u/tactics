class_name ClampValueModifier extends ValueModifier

var minimum: float
var maximum: float

func _init(_sort_order: int, _min: float, _max: float) -> void:
	super(_sort_order)
	minimum = _min
	maximum = _max


func modify(_from_value: float, to_value: float) -> float:
	return clamp(to_value, minimum, maximum)
