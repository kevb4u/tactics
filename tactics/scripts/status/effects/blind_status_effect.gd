class_name BlindStatusEffect extends StatusEffect

## Connect to CTR stat
func on_enable() -> void:
	Global.get_or_register_signal(HitRate.status_check_notification_key).connect(on_hit_rate_status_check)


func on_disable() -> void:
	Global.get_or_register_signal(HitRate.status_check_notification_key).disconnect(on_hit_rate_status_check)


## Handler method for hit rate
func on_hit_rate_status_check(args: Info.Info3) -> void:
	var _owner: Unit = get_node("../../../")
	if _owner == args.arg0:
		## Attacker is Blind
		args.arg2 += 50
	elif _owner == args.arg1:
		## Defender is Blind
		args.arg2 -= 20
