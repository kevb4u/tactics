class_name SimpleInteraction extends BaseInteraction

class PerformerInfo:
	var elapse_time : float
	var on_completed : Callable

@export var max_simultaneous_users : int = 1

var current_performers : Dictionary[CommonAIBase, PerformerInfo]
var num_current_users = 0:
	set(value):
		print("Trying to map num_current_users")
	get():
		return current_performers.size()

var performers_to_clean_up : Array[CommonAIBase]

func can_perform() -> bool:
	return num_current_users < max_simultaneous_users


func lock_interaction(performer : CommonAIBase) -> bool:
	if num_current_users >= max_simultaneous_users:
		printerr(performer.name + " trying to lock " + display_name + " which is aleady at max users.")
		return false
	
	if current_performers.has(performer):
		printerr(performer.name + " tried to lock " + display_name + " multiple times.")
		return false
	
	current_performers[performer] = null
	#print(performer.name + " locked " + display_name)
	return true


func perform(_performer : CommonAIBase, _on_completed : Callable) -> bool:
	if not current_performers.has(_performer):
		printerr(_performer.name + " trying to preform interaction " + display_name + " which it has not locked.")
		return false
	
	start_animation(_performer)
	#print(_performer.name + " preform " + display_name)
	# Check the Interaction Type
	if interaction_type == EInteractionType.Instantaneous:
		if stat_changes.size() > 0:
			apply_interaction_effects(_performer, 1, true)
		_on_interaction_completed(_performer, _on_completed)
	elif interaction_type == EInteractionType.OverTime || interaction_type == EInteractionType.AfterTime:
		var p : PerformerInfo = PerformerInfo.new()
		p.elapse_time = 0
		p.on_completed = _on_completed
		current_performers[_performer] = p
	return true


func _on_interaction_completed(performer : CommonAIBase, on_compeleted : Callable) -> void:
	on_compeleted.call(self)
	if current_performers.has(performer) and not performers_to_clean_up.has(performer):
		print_rich(performer.name + "[color=yellow]< did not unlock in their onCompleted handler for >" + display_name)
		performers_to_clean_up.append(performer)


func unlock_interaction(performer : CommonAIBase) -> bool:
	if current_performers.has(performer):
		#print(performer.name + " unlocked " + display_name)
		performers_to_clean_up.append(performer)
		return true
	
	printerr(performer.name + " trying to unlock " + display_name + " which it did not lock.")
	return false

func _process(delta: float) -> void:
	# update any current performers
	for kvp in current_performers:
		var performer : CommonAIBase = kvp
		var performer_info : PerformerInfo = current_performers[kvp]
		
		if performer_info == null:
			continue
		
		var previous_elapse_time : float = performer_info.elapse_time
		performer_info.elapse_time = min(performer_info.elapse_time + delta, duration)
		
		var is_final_tick : bool = performer_info.elapse_time >= duration
		var continue_interaction : bool = true
		
		if (stat_changes.size() > 0 and 
			((interaction_type == EInteractionType.OverTime) or
			(interaction_type == EInteractionType.AfterTime and is_final_tick))):
				continue_interaction = apply_interaction_effects(performer, (performer_info.elapse_time - previous_elapse_time) / duration, is_final_tick)
		
		# interaction complete?
		if not continue_interaction || is_final_tick:
			_on_interaction_completed(performer, performer_info.on_completed)
	
	# clean up any performers that are finished
	for perfomer in performers_to_clean_up:
		current_performers.erase(perfomer)
	performers_to_clean_up.clear()
	pass
