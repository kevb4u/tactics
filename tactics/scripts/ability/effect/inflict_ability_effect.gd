class_name InflictAbilityEffect extends BaseAbilityEffect

#@export var status_name: String
@export var status_script: Script
@export var duration: int

func predict(_target: Tile) -> int:
	return 0


func apply(target: Tile) -> int:
	var status_effect = Node.new()
	status_effect.set_script(status_script)
	
	var status: Status = target.content.get_node("Status")
	
	var condition: DurationStatusCondition = DurationStatusCondition.new()
	status.add(status_effect, condition)
	condition.duration = duration
	return 0
