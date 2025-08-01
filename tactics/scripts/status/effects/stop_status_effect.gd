class_name StopStatusEffect extends StatusEffect

var stats: Stats


## Connect to CTR stat
func on_enable() -> void:
	stats = get_node("../../../Stats")
	stats.will_change_notification(StatTypes.Stat.CTR).connect(on_counter_will_change)
	Global.get_or_register_signal(HitRate.automatic_hit_check_notification_key).connect(on_automatic_hit_check)


func on_disable() -> void:
	stats.will_change_notification(StatTypes.Stat.CTR).disconnect(on_counter_will_change)
	Global.get_or_register_signal(HitRate.automatic_hit_check_notification_key).disconnect(on_automatic_hit_check)


## Stop changes to CTR
func on_counter_will_change(sender: Stats, vce: ValueChangeException) -> void:
	vce.flip_toggle()


## Handler method for hit rate
func on_automatic_hit_check(exc: MatchException) -> void:
	var _owner: Unit = get_parent().get_parent().get_parent()
	if _owner == exc.target:
		exc.flip_toggle()
