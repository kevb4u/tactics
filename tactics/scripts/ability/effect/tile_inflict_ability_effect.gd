class_name TileInflictAbilityEffect extends BaseAbilityEffect

#@export var status_name: String
@export var status_script: Script
@export var duration: int

func predict(_target: Tile) -> int:
	return 0


func apply(target: Tile) -> int:
	var status_effect = Node.new()
	status_effect.set_script(status_script)
	
	var condition: TileDurationStatusCondition = TileDurationStatusCondition.new()
	target.change_status(status_effect, condition)
	condition.duration = duration
	return 0
