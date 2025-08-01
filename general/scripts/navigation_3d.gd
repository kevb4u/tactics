class_name Navigation3D extends Node

signal finished

enum state { processing, tween, finished }
var current_state: state = state.finished

var entity: Entity3D

var astar_path: Array[Vector2i]
var destination: Vector2: set = _set_destination
var target_node: Node2D

func _ready() -> void:
	if get_parent() is Entity3D:
		entity = get_parent()
	else:
		printerr("Navigation found no Parent Entity")
	process_mode = Node.PROCESS_MODE_DISABLED


func _process(_delta: float) -> void:
	if current_state == state.tween:
		return
	if astar_path.is_empty() and current_state == state.processing:
		entity.direction = Vector3.ZERO
		## TWEEN FOR NON-GRID MOVEMENT
		#var tween: Tween = create_tween()
		#tween.tween_property(entity, "global_position", destination, 0.1)
		#tween.finished.connect(_on_finished_tween)
		#current_state = state.tween
		return
	
	if target_node != null:
		if destination != target_node.global_position:
			destination = target_node.global_position
	
	var target_position = astar_path.front()
	
	var pos_2d = Vector2(entity.global_position.x, entity.global_position.z)
	var dir_2d = pos_2d.direction_to(target_position).normalized()
	entity.direction = Vector3(dir_2d.x, 0, dir_2d.y)
	
	## GO TO NEXT PATH IF CLOSE ENOUGH
	if pos_2d.distance_to(target_position) < 0.2:
		# Adjust to tile height
		var tile: Tile = Global.get_tile_3d(target_position)
		var new_height: float = tile.height
		if entity.global_position.y != new_height:
			var jumperTween = create_tween()
			jumperTween.tween_property(
				entity,
				"global_position:y",
				new_height,
				.1
			).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		entity.unit.place(tile)
		
		if astar_path.size() == 1:
			## TWEEN FOR GRID MOVEMENT
			var tween: Tween = create_tween()
			current_state = state.tween
			tween.finished.connect(_on_finished_tween)
			var target_position_3d: Vector3 = Vector3(target_position.x, new_height, target_position.y)
			tween.tween_property(entity, "global_position", target_position_3d, 0.1)
		astar_path.pop_front()


func move(target_location: Vector2) -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	current_state = state.processing
	destination = target_location
	pass


func stop() -> void:
	astar_path.clear()
	_on_finished_tween()


func is_finished() -> bool:
	return current_state == state.finished


func _on_finished_tween() -> void:
	if astar_path.size() != 0:
		return
	process_mode = Node.PROCESS_MODE_DISABLED
	entity.direction = Vector3.ZERO
	target_node = null
	current_state = state.finished
	place(Global.get_tile_3d(Vector2(entity.global_position.x, entity.global_position.z)))
	finished.emit()


func place(tile: Tile) -> void:
	if tile == null:
		return
	entity.unit.place(tile)
	entity.unit.match_with_tile()


# TODO: fix get_path into 3d not 2d
func _set_destination(value: Vector2i) -> void:
	if entity == null:
		return
	var pos_2d = Vector2i(entity.global_position.x, entity.global_position.z)
	var distance: float = pos_2d.distance_to(value)
	var _temp_path: Array[Vector2i] = []
	var og_value: Vector2 = value
	## find that closet path it can go to, spread out in a spiral
	# Algorithm: https://stackoverflow.com/questions/398299/looping-in-a-spiral
	var X: int = distance + 2
	var Y: int = distance + 1
	var x: int = 0
	var y: int = 0
	var dx: int = 0
	var dy: int = -1
	for i in range(max(X, Y)**2):
		if ((-X/2 < x) and (x <= X/2)) and ((-Y/2 < y) and (y <= Y/2)):
			## DO STUFF
			value = og_value + Vector2(x, y)
			_temp_path = Global.get_astar_path_3d(pos_2d, value)
			if _temp_path.size() != 0:
				break
		if x == y or (x < 0 and x == -y) or (x > 0 and x == 1-y):
			var temp: int = dx
			dx = -dy
			dy = temp
		x = x+dx
		y = y+dy
	
	## Override path only if there is a path
	if _temp_path.size() != 0:
		astar_path = _temp_path
	if astar_path.size() != 0:
		destination = value
	else:
		destination = Vector2(entity.global_position.x, entity.global_position.z)
		_on_finished_tween()
	pass
