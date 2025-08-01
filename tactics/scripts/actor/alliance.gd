class_name Alliance extends Node

@export var type: AllianceType.Alliances
var confused: bool = false

func is_match(other: Alliance, targets: Targets.Target) -> bool:
	var _is_match: bool = false
	match targets:
		Targets.Target.Self:
			_is_match = other == self
		Targets.Target.Ally:
			_is_match = type == other.type
		Targets.Target.Foe:
			_is_match = (type != other.type) and other.type != AllianceType.Alliances.Neutral
	
	return not _is_match if confused else _is_match
