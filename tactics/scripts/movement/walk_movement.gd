class_name WalkMovement extends Movement


func traverse(tile: Tile):
	#Build a list of way points from unit's
	#starting tile to the destination Tile
	create_new_path(tile)


func create_new_path(tile: Tile) -> void:
	if path.size() > 1:
		var to: Tile = path[1]
		unit.place(to)
		unit.match_with_tile()
	path = []
	
	while tile != null:
		path.push_front(tile)
		tile = tile.prev
	
	if path.size() == 0:
		if is_active:
			done_move_tile()
		return
	
	# If the last tile has content, dont stand on it
	var last_tile: Tile = path[path.size() - 1]
	if last_tile.content != null:
		path.pop_back()
	
	if path.size() < 2:
		done_move_tile()
		return
	
	is_active = true
	#move to each waypoint in succession
	move_loop()


func move_loop() -> void:
	walk_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_LINEAR)
	walk_tween.finished.connect(done_move_tile)
	
	var from: Tile = path[0]
	var to: Tile = path[1]
	
	var dir: Directions.Dirs = Directions.get_directions(from, to)
	
	if unit.dir != dir:
		#This is where you would start playing turn animation if there is one
		turn(dir)
	
	unit.place(to)
	if from.height == to.height:
		#This is where you would start playing walk animation if there is one
		walk(to)
	else:
		#This is where you would start playing jump animation if there is one
		jump(to)


func walk(target: Tile):
	var center: Vector3 = target.center()
	
	walk_tween.tween_property(
		unit.entity,
		"position",
		Vector2(center.x, center.z),
		.2,
	)
	
	walk_tween.tween_property(
		unit.entity_3d,
		"position",
		Vector3(target.pos.x, target.height, target.pos.y),
		.2,
	)


func jump(target: Tile):
	var center: Vector3 = target.center()
	
	walk_tween.tween_property(
		unit.entity,
		"position",
		Vector2(center.x, center.z),
		.5,
	)
	
	walk_tween.tween_property(
		unit.entity_3d,
		"position:x",
		target.pos.x,
		.5,
	)
	walk_tween.tween_property(
		unit.entity_3d,
		"position:z",
		target.pos.y,
		.5,
	)
	
	var jumperTween = create_tween().set_parallel(true)
	jumperTween.tween_property(
		unit.entity.sprite,
		"offset:y",
		-center.y + unit.og_offset,
		.25
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	jumperTween.tween_property(
		unit.entity_3d,
		"position:y",
		target.height,
		.25
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func done_move_tile() -> void:
	path.pop_front()
	
	if path.size() > 1:
		move_loop()
	else:
		#When for loop is finished, return to idle animation if there is one
		path = []
		is_active = false
		finished.emit()


func expanded_search(from: Tile, to: Tile, target: Tile):
	#skip if the distance in height between the two tiles is more than the unit can jump
	if abs(from.height - to.height) > jump_height:
		return false
	
	#skip if the tile in occupied by an enemy
	if to.content != null and to != target:
		return false
	
	return super(from, to, target)
