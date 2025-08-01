class_name InteractionOutcome extends Resource

@export var description : String
@export_range(0, 1) var weighting : float = 1.0
@export var stat_multiplier : float = 1.0
@export var abandon_interaction : bool = false
@export var stat_changes : Array[InteractionStatChange]
@export var memories_caused : Array[MemoryFragment]

var normalized_wieghting : float = -1.0
