class_name SlowStatusEffect extends StatusEffect

var stats: Stats
var modifier: float = 0.5

## Connect to CTR stat
func on_enable() -> void:
	stats = get_node("../../../Stats")
	stats.will_change_notification(StatTypes.Stat.CTR).connect(on_counter_will_change)


func on_disable() -> void:
	stats.will_change_notification(StatTypes.Stat.CTR).disconnect(on_counter_will_change)


## Half the CTR stat
func on_counter_will_change(sender: Stats, vce: ValueChangeException) -> void:
	vce.add_modifier(MultDeltaModifier.new(0, modifier))
