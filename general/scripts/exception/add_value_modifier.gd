class_name AddValueModifier extends ValueModifier

var to_add: float

func _init(_sort_order: int, _to_add: float):
	super(_sort_order)
	to_add = _to_add


func modify(_from_value: float, to_value: float) -> float:
	return to_value + to_add
