class_name NotSoSimpleAI extends CommonAIBase

const DIRECTIONS = [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]

@export var interaction_pick_size : int = 5
@export var pick_interaction_interval : float = 2.0
@export var avoid_in_use_objects : bool = true
var time_until_next_interaction_pick : float = -1.0

var wait_duration : float = (randf() * pick_interaction_interval + pick_interaction_interval * 0.5)

func _process(delta: float) -> void:
	super(delta)
	if Engine.is_editor_hint():
		return
	
	if currect_interaction == null:
		time_until_next_interaction_pick -= delta
		
		# time to pick an interaction
		if time_until_next_interaction_pick <= 0:
			wait_duration = (randf() * pick_interaction_interval + pick_interaction_interval * 0.5)
			time_until_next_interaction_pick = wait_duration
			pick_best_interaction()
		#elif entity.direction == Vector2.ZERO and time_until_next_interaction_pick <= wait_duration / 2.0:
			## wander in a direction
			#entity.direction = DIRECTIONS[randi_range(0, 3)]


var default_interaction_score : float = 0

func score_interaction(interaction : BaseInteraction) -> float:
	if interaction.stat_changes.size() == 0:
		return default_interaction_score
	
	var score : float = 0
	
	var recent_memories : Array[MemoryFragment] = individual_blackboard.get_generic(memories_short_term)
	var permenant_memories : Array[MemoryFragment] = individual_blackboard.get_generic(memories_long_term)
	
	for change in interaction.stat_changes:
		score += score_change(change.linked_stat, change.value, recent_memories, permenant_memories)
	
	return score


func score_change(linked_stat : AIStat, amount : float, recent_memories : Array[MemoryFragment], permenant_memories : Array[MemoryFragment]) -> float:
	var current_value : float = get_stat_value(linked_stat)
	
	current_value = modify_based_on_memories(current_value, linked_stat, recent_memories)
	current_value = modify_based_on_memories(current_value, linked_stat, permenant_memories)
	
	# TODO: CURVES??
	return (1.0 - current_value) * apply_traits_to(linked_stat, ETraitTarget.Type.score, amount)


func modify_based_on_memories(current_value : float, linked_stat : AIStat, memories : Array[MemoryFragment]) -> float:
	for memory in memories:
		for change in memory.stat_changes:
			if change.linked_stat == linked_stat:
				current_value *= change.value
	return current_value


class ScoredInteraction:
	var target_object : SmartObject
	var interaction : BaseInteraction
	var score : float


# Sort by Descending order
func _sort_scored_interaction(a: ScoredInteraction, b: ScoredInteraction) -> bool:
	if a == b:
		# Pick the one with higher priority is both have same score
		var a_priority: int = 0
		var b_priority: int = 0
		for _a in a.interaction.stat_changes:
			a_priority += _a.linked_stat.decay_rate
		for _b in b.interaction.stat_changes:
			b_priority += _b.linked_stat.decay_rate
		return a_priority > b_priority
	
	return a.score > b.score


func pick_best_interaction() -> void:
	var objects_in_use : Array[Node2D] = []
	var result : Dictionary = household_blackboard.try_get(FastKey.get_or_register_key("household_objects_in_use"), objects_in_use)
	if result.did_get:
		objects_in_use = result.result
	
	# loop through all the objects
	var scored_interactions : Array[ScoredInteraction]
	for smart_object in SmartObjectManager.registered_objects:
		# loop through all the interactions
		for interaction in smart_object.interaction:
			if not interaction.can_perform():
				continue
			
			# skip if someone else is using
			if avoid_in_use_objects and result.result != null and objects_in_use.has(interaction.get_parent()):
				continue
			
			var score : float = score_interaction(interaction)
			var scored_interaction : ScoredInteraction = ScoredInteraction.new()
			scored_interaction.target_object = smart_object
			scored_interaction.interaction = interaction
			scored_interaction.score = score
			scored_interactions.append(scored_interaction)
	
	if scored_interactions.is_empty():
		return
	
	# sort and pick from the best interaction
	scored_interactions.sort_custom(_sort_scored_interaction)
	
	var max_index = min(interaction_pick_size, scored_interactions.size())
	var selected_index = randi_range(0, max_index - 1)
	
	var selected_object : SmartObject = scored_interactions[selected_index].target_object
	var selected_interaction : BaseInteraction = scored_interactions[selected_index].interaction
	
	# can move to interaction?
	entity.unit.move(Global.get_tile(selected_object.interaction_point))
	
	currect_interaction = selected_interaction
	currect_interaction.lock_interaction(self)
	started_performing = false
