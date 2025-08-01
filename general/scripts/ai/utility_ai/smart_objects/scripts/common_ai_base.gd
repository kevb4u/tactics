class_name CommonAIBase extends Node2D

var memories_short_term: FastKey = FastKey.get_or_register_key("memories_short_term")
var memories_long_term: FastKey = FastKey.get_or_register_key("memories_long_term")


@export var entity: Entity

@export var household_id : int = 1
@export_category("AI Stats")
@export var stats : Array[AIStatConfiguration]
@export var linked_ui : FeedbackUIPanel

@export_category("Traits")
@export var traits : Array[Trait]

@export_category("Memories")
@export var long_term_memories_threshhold : int = 2

var started_performing : bool = false

var individual_blackboard : BlackboardManager.Blackboard
var household_blackboard : BlackboardManager.Blackboard

var decay_rates : Dictionary[AIStat, float]
var stat_ui_panel : Dictionary[AIStat, AIStatPanel]

var currect_interaction : BaseInteraction:
	get():
		var interaction : BaseInteraction = null
		var result : Dictionary = individual_blackboard.try_get(FastKey.get_or_register_key("character_focus_object"), interaction)
		return result.result as BaseInteraction
	set(value):
		var previous_interaction : BaseInteraction = null
		var _result : Dictionary = individual_blackboard.try_get(FastKey.get_or_register_key("character_focus_object"), previous_interaction)
		previous_interaction = _result.result
		
		individual_blackboard.set_generic(FastKey.get_or_register_key("character_focus_object"), value)
		
		var objects_in_use : Array[Node2D] = []
		var result : Dictionary = household_blackboard.try_get(FastKey.get_or_register_key("household_objects_in_use"), objects_in_use)
		
		if result.did_get:
			objects_in_use = result.result
		
		# are we starting to use something?
		if value != null:
			# need to create array?
			if result.result == null:
				objects_in_use = []
			
			# not already in array? add and update the blackboard
			if not objects_in_use.has(value.get_parent()):
				objects_in_use.append(value.get_parent())
				household_blackboard.set_value(FastKey.get_or_register_key("household_objects_in_use"), objects_in_use)
		# we've stopped using something
		elif result.result != null:
			# attempt to remove
			if previous_interaction:
				if objects_in_use.has(previous_interaction.get_parent()):
					objects_in_use.erase(previous_interaction.get_parent())
					household_blackboard.set_value(FastKey.get_or_register_key("household_objects_in_use"), objects_in_use)


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	
	household_blackboard = BlackboardManager.get_shared_blackboard(household_id)
	individual_blackboard = BlackboardManager.get_individual_blackboard(self)
	
	individual_blackboard.set_generic(memories_short_term, [] as Array[MemoryFragment])
	individual_blackboard.set_generic(memories_long_term, [] as Array[MemoryFragment])
	
	# setup the stats
	for stat_config in stats:
		var linked_stat : AIStat = stat_config.linked_stat
		var initial_value : float = stat_config.override_initial_value if stat_config.override_defaults else linked_stat.initial_value
		var decay_rate : float = stat_config.override_decay_rate if stat_config.override_defaults else linked_stat.decay_rate
		
		individual_blackboard.set_ai_stat(linked_stat, initial_value)
		decay_rates[linked_stat] = decay_rate
		
		if linked_stat.is_visible:
			call_deferred("add_ai_panel", linked_stat, initial_value)
	
	#SaveManager.game_start_loading.connect(_on_game_start_loading)
	#LevelManager.level_load_started.connect(_on_level_load_start)
	_on_game_start_loading()
	Global.get_or_register_signal(BattleController.battle_start_key).connect(cancel)
	Global.get_or_register_signal(BattleController.battle_end_key).connect(start)
	start()


func _on_game_start_loading() -> void:
	if currect_interaction:
		currect_interaction.unlock_interaction(self)
		currect_interaction = null


func _on_level_load_start(_level_name : String) -> void:
	if currect_interaction:
		currect_interaction.unlock_interaction(self)
		currect_interaction = null


func add_ai_panel(linked_stat : AIStat, initial_value : float) -> void:
	#if stat_ui_panel:
	stat_ui_panel[linked_stat] = linked_ui.add_stat(linked_stat, initial_value)


func start() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT


func cancel() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


func apply_traits_to(target_stat : AIStat, target_type : ETraitTarget.Type, current_value : float) -> float:
	for t in traits:
		current_value = t.apply(target_stat, target_type, current_value)
	return current_value


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	if currect_interaction != null:
		if entity.unit.movement.is_active == false and started_performing == false:
			# Turn to the object
			#npc.update_direction(currect_interaction.global_position)
			started_performing = true
			currect_interaction.perform(self, on_interaction_finished)
	
	## aply the decay rate
	for stat_config in stats:
		## MAX STAT = 1.0
		update_individual_stat(stat_config.linked_stat, -(delta / DayNightCycle.MINUTES_PER_DAY / decay_rates[stat_config.linked_stat]), ETraitTarget.Type.decay_rate)
	
	## tick recent memories
	var recent_memories : Array[MemoryFragment] = individual_blackboard.get_generic(memories_short_term)
	var memories_changed : bool = false
	var _size : int = recent_memories.size()
	for i in range(_size):
		var index : int = _size - i - 1
		if recent_memories[index].tick(delta) == false:
			#print("MEMORY " + recent_memories[index].name + " became forgotton!")
			recent_memories.remove_at(index)
			memories_changed = true
	
	if memories_changed:
		individual_blackboard.set_generic(memories_short_term, recent_memories)


func on_interaction_finished(interaction : BaseInteraction) -> void:
	interaction.unlock_interaction(self)
	currect_interaction = null


func update_individual_stat(linked_stat : AIStat, _amount : float, _target_type : ETraitTarget.Type) -> void:
	var adjusted_amount : float = apply_traits_to(linked_stat, _target_type, _amount)
	var new_value : float = clampf(get_stat_value(linked_stat) + adjusted_amount, 0, 1)
	individual_blackboard.set_ai_stat(linked_stat, new_value)
	if linked_stat.is_visible and stat_ui_panel:
		stat_ui_panel[linked_stat].on_stat_changed(new_value)


func get_stat_value(linked_stat : AIStat) -> float:
	return individual_blackboard.get_ai_stat(linked_stat)


func add_memories(memories_to_add : Array[MemoryFragment]) -> void:
	for memory in memories_to_add:
		add_memory(memory)


func add_memory(memory_to_add : MemoryFragment) -> void:
	var permanent_memories : Array[MemoryFragment] = individual_blackboard.get_generic(memories_long_term)
	# in long term memory already?
	var memory_to_cancel : MemoryFragment = null
	for memory in permanent_memories:
		if memory_to_add.is_similar_to(memory):
			return
		if memory.is_cancelled_by(memory_to_add):
			memory_to_cancel = memory
	
	# does this cancel a long term memory?
	if memory_to_cancel != null:
		permanent_memories.erase(memory_to_cancel)
		individual_blackboard.set_generic(memories_long_term, permanent_memories)
	
	var recent_memories : Array[MemoryFragment] = individual_blackboard.get_generic(memories_short_term)
	
	# does this cancel a recent memory?
	var existing_recent_memory : MemoryFragment = null
	memory_to_cancel = null
	for memory in recent_memories:
		if memory_to_add.is_similar_to(memory):
			existing_recent_memory = memory
		if memory.is_cancelled_by(memory_to_add):
			memory_to_cancel = memory
	
	# does this cancel a recent term memory?
	if memory_to_cancel != null:
		recent_memories.erase(memory_to_cancel)
		individual_blackboard.set_generic(memories_short_term, recent_memories)
	
	if existing_recent_memory == null:
		#print("MEMORY " + memory_to_add.name + " became recent!")
		recent_memories.append(memory_to_add.duplicate_memory())
		individual_blackboard.set_generic(memories_short_term, recent_memories)
	else:
		#print("MEMORY " + existing_recent_memory.name + " has been reinforced!")
		existing_recent_memory.reinforce(memory_to_add)
		
		if existing_recent_memory.occurrences >= long_term_memories_threshhold:
			permanent_memories.append(existing_recent_memory)
			recent_memories.erase(existing_recent_memory)
			
			individual_blackboard.set_generic(memories_long_term, permanent_memories)
			individual_blackboard.set_generic(memories_short_term, recent_memories)
			#print("MEMORY " + existing_recent_memory.name + " became permanet!")
