class_name HitRate extends Node

#signal automatic_hit_check_notification(exc: MatchException)
#signal automatic_miss_check_notification(exc: MatchException)
#signal status_check_notification(args: Info.Info3)

static var automatic_hit_check_notification_key: FastKey = FastKey.get_or_register_key("automatic_hit_check_notification")
static var automatic_miss_check_notification_key: FastKey = FastKey.get_or_register_key("automatic_miss_check_notification")
static var status_check_notification_key: FastKey = FastKey.get_or_register_key("status_check_notification")

var _attacker: Unit

func _ready() -> void:
	var _owner: Node = get_parent()
	while _attacker == null:
		if _owner is Unit:
			_attacker = _owner
		else:
			_owner = _owner.get_parent()


func calculate(_target: Tile) -> int:
	return 100


func automatic_hit(attacker: Unit, target: Unit) -> bool:
	var exc: MatchException = MatchException.new(attacker, target)
	Global.get_or_register_signal(automatic_hit_check_notification_key).emit(exc)
	return exc.toggle


func automatic_miss(attacker: Unit, target: Unit) -> bool:
	var exc: MatchException = MatchException.new(attacker, target)
	Global.get_or_register_signal(automatic_miss_check_notification_key).emit(exc)
	return exc.toggle


func adjust_for_status_effect(attacker: Unit, target: Unit, rate: int) -> int:
	var args: Info.Info3 = Info.Info3.new(attacker, target, rate)
	Global.get_or_register_signal(status_check_notification_key).emit(args)
	return args.arg2


func final(evade: int) -> int:
	return 100 - evade


func is_angle_based() -> bool:
	return true
