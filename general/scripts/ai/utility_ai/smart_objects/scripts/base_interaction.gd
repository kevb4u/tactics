class_name BaseInteraction extends Node2D

enum EInteractionType { 
	Instantaneous = 0,
	OverTime = 1,
	AfterTime = 2
}

@export var display_name : String
@export var interaction_type : EInteractionType = EInteractionType.Instantaneous
@export var duration : float = 0.0
@export var stat_changes : Array[InteractionStatChange]
@export var animation_start_name : String = "idle_"
@export var interaction_outcomes : Array[InteractionOutcome] = [InteractionOutcome.new()]
var outcome_weightings_normalized : bool = false

func can_perform() -> bool:
	return true

func lock_interaction(_performer : CommonAIBase) -> bool:
	return false

func perform(_performer : CommonAIBase, _on_completed : Callable) -> bool:
	return false

func unlock_interaction(_performer : CommonAIBase) -> bool:
	return false

func apply_interaction_effects(_performer : CommonAIBase, _proportion : float, roll_for_outcomes : bool) -> bool:
	var abandon_interaction : bool = false
	
	var selected_outcome : InteractionOutcome = null
	if roll_for_outcomes and interaction_outcomes.size() > 0:
		# normalize outcomes when needed
		if not outcome_weightings_normalized:
			outcome_weightings_normalized = true
			var weighting_sum : float = 0
			for outcome in interaction_outcomes:
				weighting_sum += outcome.weighting
			
			for outcome in interaction_outcomes:
				outcome.normalized_wieghting = outcome.weighting / weighting_sum
		
		# pick outcome
		var random_roll : float = randf()
		for outcome in interaction_outcomes:
			if random_roll <= outcome.normalized_wieghting:
				selected_outcome = outcome
				if selected_outcome.abandon_interaction:
					abandon_interaction = true
				break
			random_roll -= outcome.normalized_wieghting
		
	var stat_multiplier : float = selected_outcome.stat_multiplier if selected_outcome != null else 1.0
	
	for stat_change in stat_changes:
		_performer.update_individual_stat(stat_change.linked_stat, stat_multiplier * stat_change.value * _proportion, ETraitTarget.Type.impact)
	
	if selected_outcome != null:
		#if selected_outcome.description.is_empty() == false:
			#print("Outcome was " + selected_outcome.description)
		# TODO: FIX BAD OUTCOMES. NOT ADDING CORRECTLY
		for stat_change in selected_outcome.stat_changes:
			_performer.update_individual_stat(stat_change.linked_stat, stat_change.value * _proportion, ETraitTarget.Type.impact)
		
		if selected_outcome.memories_caused.size() > 0:
			_performer.add_memories(selected_outcome.memories_caused)
			pass
	
	return not abandon_interaction


func start_animation(performer : CommonAIBase) -> void:
	var entity: Entity = performer.entity
	#if npc.animation_player.is_playing():
		#await npc.animation_player.animation_finished
	await get_tree().process_frame
	await get_tree().process_frame
	#entity.update_direction(global_position)
	if animation_start_name.is_empty() == false:
		if animation_start_name.ends_with("_"):
			entity.update_animation(animation_start_name.erase(animation_start_name.length() - 1, 1))
		else:
			entity.animation_player.play(animation_start_name)
	pass
