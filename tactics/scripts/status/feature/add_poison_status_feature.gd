class_name AddPoisonStatusFeature extends AddStatusFeature

func _init() -> void:
	status_effect = PoisonStatusEffect.new()


func on_apply() -> void:
	var status: Status = target.get_node("Status")
	status_condition = status.add(status_effect, status_condition)


func on_remove() -> void:
	status_condition.remove()
