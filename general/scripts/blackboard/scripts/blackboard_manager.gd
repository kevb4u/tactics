class_name BlackboardManager extends Node

#enum EBlackboardKey {
	#character_focus_object,
	#
	#household_objects_in_use,
	#
	#memories_short_term,
	#memories_long_term
#}

class Blackboard:
	var interger_values: Dictionary[FastKey, int]
	var float_values: Dictionary[FastKey, float]
	var bool_values: Dictionary[FastKey, bool]
	var string_values: Dictionary[FastKey, String]
	var vector2_values: Dictionary[FastKey, Vector2]
	var array_values: Dictionary[FastKey, Array]
	var node_values: Dictionary[FastKey, Node]
	var generic_values: Dictionary#[FastKey, Object]
	var ai_stat_values: Dictionary[AIStat, float]
	
	func get_int(key : FastKey) -> int:
		return _get_generic(interger_values, key)
	
	func get_float(key : FastKey) -> float:
		return _get_generic(float_values, key)
	
	func get_bool(key : FastKey) -> bool:
		return _get_generic(bool_values, key)
	
	func get_string(key : FastKey) -> String:
		return _get_generic(string_values, key)
	
	func get_vector2(key : FastKey) -> Vector2:
		return _get_generic(vector2_values, key)
	
	func get_array(key : FastKey) -> Array:
		return _get_generic(array_values, key)
	
	func get_node_value(key : FastKey) -> Node:
		return _get_generic(node_values, key)
	
	func get_generic(key : FastKey) -> Variant:
		return _get_generic(generic_values, key)
	
	func _get_generic(key_set : Dictionary, key : FastKey) -> Variant:
		if not key_set.has(key):
			printerr("Could not find value for " + str(key) + " in " + str(typeof(key)) + " dictionary")
		return key_set[key]
	
	func set_generic(key : FastKey, value) -> void:
		generic_values[key] = value
	
	func get_ai_stat(linked_stat: AIStat) -> float:
		if not ai_stat_values.has(linked_stat):
			printerr("Could not find value for " + str(linked_stat.display_name) + " in ai_stat_values")
		return ai_stat_values[linked_stat]
	
	func set_ai_stat(linked_stat: AIStat, value : float) -> void:
		ai_stat_values[linked_stat] = value
	
	func try_get(key : FastKey, value, default_value = null) -> Dictionary:
		var result : Dictionary = {result = default_value, did_get = false}
		
		match typeof(value):
			TYPE_INT:
				if interger_values.has(key):
					result.result = interger_values[key]
					result.did_get = true
				elif default_value == null:
					result.result = 0
			TYPE_FLOAT:
				if float_values.has(key):
					result.result = float_values[key]
					result.did_get = true
				elif default_value == null:
					result.result = 0.0
			TYPE_BOOL:
				if bool_values.has(key):
					result.result = bool_values[key]
					result.did_get = true
				elif default_value == null:
					result.result = false
			TYPE_STRING:
				if string_values.has(key):
					result.result = string_values[key]
					result.result = true
				elif default_value == null:
					result.result = ""
			TYPE_VECTOR2:
				if vector2_values.has(key):
					result.result = vector2_values[key]
					result.did_get = true
				elif default_value == null:
					result.result = Vector2.ZERO
			TYPE_ARRAY:
				if array_values.has(key):
					result.result = array_values[key]
					result.did_get = true
				elif default_value == null:
					result.result = []
			TYPE_OBJECT, _:
				if node_values.has(key):
					result.result = node_values[key]
					result.did_get = true
				elif generic_values.has(key):
					result.result = generic_values[key]
					result.did_get = true
					#print("value of OBJECT a(n) %s" % value.get_class())
		
		if result.did_get == false and generic_values.has(key):
			result.result = generic_values[key]
			print("Found in Generic of type::" + str(typeof(value)) + ":: with key:: " + str(key))
		
		return result
	
	func set_value(key : FastKey, value) -> void:
		match typeof(value):
			TYPE_INT:
				interger_values[key] = value
			TYPE_FLOAT:
				float_values[key] = value
			TYPE_BOOL:
				bool_values[key] = value
			TYPE_STRING:
				string_values[key] = value
			TYPE_VECTOR2:
				vector2_values[key] = value
			TYPE_ARRAY:
				array_values[key] = value
			TYPE_OBJECT:
				if value is Node:
					node_values[key] = value
				else:
					generic_values[key] = value
					print("SET GENERIC::" + str(generic_values.size()))
				#print("value is a(n) %s" % value.get_class())
	
	
	func save_blackboard() -> Dictionary:
		return {
			"interger_values": interger_values,
			"float_values": float_values,
			"bool_values": bool_values,
			"string_values": string_values,
			"vector2_values": vector2_values,
			"array_values": array_values,
		}
	
	func load_blackboard(data: Dictionary) -> void:
		load_data(data["interger_values"])
		load_data(data["float_values"])
		load_data(data["bool_values"])
		load_data(data["string_values"])
		# TODO: DIFFERENT LOAD FOR VECTOR
		load_data(data["vector2_values"])
		load_data(data["array_values"])
	
	func load_data(data: Dictionary) -> void:
		for key in data:
			var blackboard_key: FastKey = FastKey.get_or_register_key(str(key))
			set_value(blackboard_key, data[key])
	pass


static var individual_blackboards : Dictionary[int, Blackboard]
static var shared_blackboards : Dictionary[int, Blackboard]

static func get_individual_blackboard(requestor : Node) -> Blackboard:
	#if not individual_blackboards.has(requestor):
		#individual_blackboards[requestor] = Blackboard.new()
	#return individual_blackboards[requestor]
	return get_individual_blackboard_via_key(get_node_key(requestor))


static func get_individual_blackboard_via_key(key: int) -> Blackboard:
	if not individual_blackboards.has(key):
		individual_blackboards[key] = Blackboard.new()
	return individual_blackboards[key]


static func get_shared_blackboard(unique_id : int) -> Blackboard:
	if not shared_blackboards.has(unique_id):
		shared_blackboards[unique_id] = Blackboard.new()
	return shared_blackboards[unique_id]


static func get_node_key(requestor: Node) -> int:
	var _key: String = Global.game_controller.current_2d_scene.scene_file_path
	if requestor.get_parent():
		if requestor.get_parent().get_parent():
			_key += requestor.get_parent().get_parent().name
		_key += requestor.get_parent().name
	_key += requestor.name
	return _key.hash()


static func save_blackboard() -> Dictionary:
	var save_file: Dictionary
	for b in individual_blackboards:
		save_file[b] = individual_blackboards[b].save_blackboard()
	return save_file


static func load_blackboard(save_file: Dictionary) -> void:
	for key in save_file:
		var blackboard: Blackboard = get_individual_blackboard_via_key(int(key))
		blackboard.load_blackboard(save_file[key])
