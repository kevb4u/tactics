class_name Navigation extends Node

signal finished

enum state { processing, tween, finished }
var current_state: state = state.finished

var entity: Entity

var astar_path: Array[Vector2]
var destination: Vector2: set = _set_destination
var target_node: Node2D

func _ready() -> void:
	if get_parent() is Entity:
		entity = get_parent()
	else:
		printerr("Navigation found no Parent Entity")
	process_mode = Node.PROCESS_MODE_DISABLED


func _process(_delta: float) -> void:
	if current_state == state.tween:
		return
	if astar_path.is_empty() and current_state == state.processing:
		entity.direction = Vector2.ZERO
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
	
	entity.direction = entity.global_position.direction_to(target_position).normalized()
	entity.cardinal_direction = entity.direction
	
	## GO TO NEXT PATH IF CLOSE ENOUGH
	if entity.global_position.distance_to(target_position) < 5:
		# Adjust to tile height
		var tile: Tile = Global.get_tile(target_position)
		var new_height: float = -tile.center().y + entity.unit.og_offset
		if entity.sprite.offset.y != new_height:
			var jumperTween = create_tween()
			jumperTween.tween_property(
				entity.sprite,
				"offset:y",
				new_height,
				.1
			).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		entity.place(tile)
		
		if astar_path.size() == 1:
			## TWEEN FOR GRID MOVEMENT
			var tween: Tween = create_tween()
			current_state = state.tween
			tween.finished.connect(_on_finished_tween)
			tween.tween_property(entity, "global_position", target_position, 0.1)
		astar_path.pop_front()


func move(target_location: Vector2) -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	current_state = state.processing
	destination = target_location


func stop() -> void:
	astar_path.clear()
	_on_finished_tween()


func is_finished() -> bool:
	return current_state == state.finished

func _on_finished_tween() -> void:
	if astar_path.size() != 0:
		return
	process_mode = Node.PROCESS_MODE_DISABLED
	entity.direction = Vector2.ZERO
	target_node = null
	current_state = state.finished
	finished.emit()
	pass

func _set_destination(value: Vector2) -> void:
	if entity == null:
		return
	var distance: float = entity.global_position.distance_to(value)
	var _temp_path: Array[Vector2] = []
	var og_value: Vector2 = value
	## find that closet path it can go to, spread out in a spiral
	# Algorithm: https://stackoverflow.com/questions/398299/looping-in-a-spiral
	var X: int = distance / 32 + 2
	var Y: int = distance / 16 + 1
	var x: int = 0
	var y: int = 0
	var dx: int = 0
	var dy: int = -1
	for i in range(max(X, Y)**2):
		if ((-X/2 < x) and (x <= X/2)) and ((-Y/2 < y) and (y <= Y/2)):
			## DO STUFF
			value = og_value + Vector2(x * 32, y * 16)
			_temp_path = Global.get_astar_path(entity.global_position, value)
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
		destination = entity.global_position
		_on_finished_tween()
	pass
