class_name Level extends Node2D

@export var floor_tile_map: IsometricTileMap
@onready var isometric_tile_map_sort: IsometricTileMapSort = $IsometricTileMapSort

## GAME BOARD
@export var marker: Node2D
@export var facing_indicator: FacingIndicator

var tiles: Dictionary[Vector2i, Tile]
var pos: Vector2i
var _old_pos: Vector2i
var _min: Vector2i: 
	get:
		return floor_tile_map.astar.region.position

var _max: Vector2i:
	get:
		return floor_tile_map.astar.region.position + floor_tile_map.astar.size

func _ready() -> void:
	init_game_board()


func init_game_board() -> void:
	tiles = $IsometricTileMapSort.tiles
	pos = Vector2i(0,0)
	_old_pos = pos
	_update_marker()


## GAME BOARD CODE
func _process(_delta) -> void:
	if pos != _old_pos:
		_old_pos = pos
		_update_marker()


func _update_marker() -> void:
	if tiles.has(pos):
		var t: Tile = tiles[pos]
		var center: Vector3 = t.center()
		marker.position = Vector2(center.x, center.z - center.y)
	else:
		marker.position = floor_tile_map.map_to_local(pos)


func search(start: Tile, end: Tile, add_tile: Callable) -> Array[Tile]:
	var retValue: Array[Tile] = []
	retValue.append(start)
	clear_search()
	var checkNext = []
	
	start.distance = 0
	checkNext.push_back(start)
	var _dirs = [Vector2i(0,1), Vector2i(0,-1), Vector2i(1,0), Vector2i(-1,0)]
	
	while checkNext.size() > 0:
		var t: Tile = checkNext.pop_front()
		#Add more code here
		#_dirs.shuffle() #Optional. May impact performance
		
		for i in _dirs.size():
			var next:Tile = get_tile(t.pos + _dirs[i])
			if next == null || next.distance <= t.distance + 1:
				continue
			#More code here
			if add_tile.call(t, next, end):
				next.distance = t.distance + 1
				next.prev = t
				checkNext.push_back(next)
				retValue.append(next)
	return retValue


func range_search(start: Tile, end: Tile, add_tile: Callable, _range: int) -> Array[Tile]:
	var ret_value: Array[Tile] = []
	clear_search()
	start.distance = 0
	
	for y in range(-_range, _range+1):
		for x in range(-_range + abs(y), _range - abs(y) +1):
			var next: Tile = get_tile(start.pos + Vector2i(x,y))
			if next == null:
				continue
				
			if next == start:
				ret_value.append(start)
			elif add_tile.call(start, next, end):
				next.distance = (abs(x) + abs(y))
				next.prev = start
				ret_value.append(next)
	
	return ret_value


func clear() -> void:
	for key in tiles:
		tiles[key].free()
	tiles.clear()


func clear_search() -> void:
	for key in tiles:
		tiles[key].prev = null
		tiles[key].distance = Global.max_signed_int_32


func select_tiles(_tiles: Array[Tile]) -> void:
	for t in _tiles:
		t.select_tile()


func deselect_tiles(_tiles: Array[Tile]) -> void:
	for t in _tiles:
		t.deselect_tile()


func get_tile(p: Vector2i) -> Tile:
	return tiles[p] if tiles.has(p) else null


func get_mouse_position() -> Vector2:
	return floor_tile_map.get_local_mouse_position()


func get_tile_with_height(_pos: Vector2) -> Tile:
	var map_pos: Vector2i = floor_tile_map.local_to_map(_pos)
	var ret_value: Tile = null
	for i in isometric_tile_map_sort.get_children().size():
		var child := isometric_tile_map_sort.get_child(i)
		if child is IsometricTileMap:
			var tile_data: TileData = child.get_cell_tile_data(map_pos)
			if tile_data:
				var tile_pos: Vector2i = map_pos + Vector2i(i, i)
				if tiles.has(tile_pos):
					ret_value = tiles[tile_pos]
	return ret_value


func get_tile_mouse_position() -> Tile:
	return get_tile_with_height(floor_tile_map.get_local_mouse_position())

## START OF NAVIGATION CODE
func get_astar_path(start: Vector2, end: Vector2) -> Array[Vector2]:
	return floor_tile_map.get_astar_path(start, end)


func get_astar_path_3d(start: Vector2i, end: Vector2i) -> Array[Vector2i]:
	return floor_tile_map.get_astar_path_3d(start, end)


#func set_solid(solid_position: Vector2) -> void:
	#floor_tile_map.set_solid(solid_position)


func local_to_map(local_position: Vector2) -> Vector2i:
	return floor_tile_map.local_to_map(local_position)


func map_to_local(map_location: Vector2i) -> Vector2:
	return floor_tile_map.map_to_local(map_location)
