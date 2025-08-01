class_name Repeater

## how often the button will register after being held in milliseconds
const _rate:int = 250

var _next: int
var _axisPos: String
var _axisNeg: String

func _init(negativeAxis: String, positiveAxis: String) -> void:
	_axisNeg = negativeAxis
	_axisPos = positiveAxis


func update() -> int:
	var ret_value: int = 0
	var value: int = roundi(Input.get_axis(_axisNeg, _axisPos))
	
	if value != 0:
		if Time.get_ticks_msec() > _next:
			ret_value = value
			_next = Time.get_ticks_msec() + _rate
	else:
		_next = 0
	
	return ret_value
