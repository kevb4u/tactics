class_name SimpleAI extends CommonAIBase

@export var pick_interaction_interval : float = 2.0
var time_until_next_interaction_pick : float = -1.0

func _process(delta: float) -> void:
	super(delta)
	if Engine.is_editor_hint():
		return
	if currect_interaction == null:
		time_until_next_interaction_pick -= delta
		
		# time to pick an interaction
		if time_until_next_interaction_pick <= 0:
			time_until_next_interaction_pick = pick_interaction_interval
			pick_random_interaction()
	pass

func pick_random_interaction() -> void:
	# pick random object
	var selected_object : SmartObject = SmartObjectManager.registered_objects.pick_random()
	
	# pick random interaction
	var selected_interaction : BaseInteraction = selected_object.interaction.pick_random()
	
	# can perform the interaction?
	if selected_interaction.can_perform():
		# can move to interaction?
		entity.navigation.move(selected_object.interaction_point)
		
		#if not astar_path.is_empty():
		currect_interaction = selected_interaction
		currect_interaction.lock_interaction(self)
		started_performing = false
	pass
