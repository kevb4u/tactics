class_name MemoryFragment extends Resource

@export var name : String
@export var description : String
@export var duration : float = 0
@export var stat_changes : Array[InteractionStatChange]
@export var memories_contered : Array[MemoryFragment]

var occurrences : int = 0
var duration_remaining : float = 0

func tick(delta : float) -> bool:
	duration_remaining -= delta
	return duration_remaining > 0

func is_similar_to(other : MemoryFragment) -> bool:
	return name == other.name and description == other.description

func is_cancelled_by(other : MemoryFragment) -> bool:
	for fragment in memories_contered:
		if fragment.is_similar_to(other):
			return true
	return false

func reinforce(other : MemoryFragment) -> void:
	duration_remaining = max(duration_remaining, other.duration_remaining)
	occurrences += 1
	pass

func duplicate_memory() -> MemoryFragment:
	var new_memory : MemoryFragment = self.duplicate()
	new_memory.occurrences = 1
	new_memory.duration_remaining = duration
	return new_memory
