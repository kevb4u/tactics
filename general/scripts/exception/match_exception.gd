class_name MatchException extends BaseException

var attacker: Unit
var target: Unit

func _init(_attacker: Unit, _target: Unit) -> void:
	super(false)
	attacker = _attacker
	target = _target
