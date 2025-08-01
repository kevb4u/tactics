class_name ValueChangeException extends BaseException

var from_value: float
var to_value: float
var delta: float :
	get:
		return to_value - from_value
var modifiers: Array[ValueModifier] = []

func _init(_from_value: float, _to_value: float) -> void:
	super(true)
	from_value = _from_value
	to_value = _to_value


func add_modifier(m: ValueModifier) -> void:
	modifiers.append(m)


func get_modified_value() -> float:
	if(modifiers.size() == 0):
		return to_value
	
	var value = to_value
	
	modifiers.sort_custom(compare)
	for modifier in modifiers:
		value = modifier.modify(from_value, value)
	
	return value


func compare(a: ValueModifier, b: ValueModifier) -> bool:
	return a.sort_order < b.sort_order
