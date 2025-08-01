class_name TeleportMovement extends Movement

func traverse(tile: Tile):
	unit.place(tile)
	unit.match_with_tile()
	#var spinTween = create_tween()
	#spinTween.tween_property(
		#jumper,
		#"rotation",
		#Vector3(0,360, 0),
		#.5
	#).set_trans(Tween.TRANS_LINEAR)
	#var scaleTween = create_tween()
	#scaleTween.tween_property(
		#jumper,
		#"scale",
		#Vector3(0,0,0),
		#0.5
	#)
	#await scaleTween.finished
	#unit.position = tile.center()
	#spinTween = create_tween()
	#spinTween.tween_property(
		#jumper,
		#"rotation",
		#Vector3(0,0, 0),
		#.5
	#).set_trans(Tween.TRANS_LINEAR)
	#scaleTween = create_tween()
	#scaleTween.tween_property(
		#jumper,
		#"scale",
		#Vector3(1,1,1),
		#0.5
	#)  
	#await scaleTween.finished


func get_tiles_in_range(level: Level, target: Tile) -> Array[Tile]:
	var ret_value: Array[Tile] = level.range_search(unit.tile, target, expanded_search, range)
	filter(ret_value)
	return ret_value


func expanded_search(from: Tile, to: Tile, _target: Tile):
	return abs(from.pos.x - to.pos.x) + abs(from.pos.y - to.pos.y) <= range
