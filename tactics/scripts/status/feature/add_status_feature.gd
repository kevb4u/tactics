class_name AddStatusFeature extends Feature

var status_effect: StatusEffect
var status_condition: StatusCondition = StatusCondition.new()

func on_apply() -> void:
	var status: Status = target.get_node("Status")
	status_condition = status.add(status_effect, status_condition)


func on_remove() -> void:
	status_condition.remove()
