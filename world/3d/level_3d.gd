class_name Level3D extends Node3D

@onready var grid_map: IsometricGridMap = $GridMap
@onready var marker: Node3D = $Marker
@onready var facing_indicator: FacingIndicator = $Marker/FacingIndicator

var tiles: Dictionary[Vector2i, Tile]
var pos: Vector2i
var _old_pos: Vector2i

#func _ready() -> void:
	#grid_map.global_position.x = -1.0
	#grid_map.global_position.y = -2.0
	#grid_map.global_position.z = -1.0

func sync(level: Level) -> void:
	tiles = level.tiles
	for key in tiles:
		tiles[key].grid_map = grid_map
	pos = level.pos
	_old_pos = pos


## GAME BOARD CODE
func _process(_delta: float) -> void:
	if pos != _old_pos:
		_old_pos = pos
		_update_marker()


func _update_marker() -> void:
	if tiles.has(pos):
		var t: Tile = tiles[pos]
		var center: Vector3 = Vector3(t.pos.x, t.height, t.pos.y)
		marker.position = center
	else:
		marker.position = Vector3(pos.x, 0, pos.y)


func get_tile_mouse_position() -> Tile:
	var camera:= get_viewport().get_camera_3d()
	var mouse_pos:= get_viewport().get_mouse_position()
	var ray_length = 200
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var space := camera.get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space.intersect_ray(ray_query)
	if result.has("position"):
		## offset for rounding issue and gridmap offset
		var _pos: Vector2i = Vector2i(floori(result.position.x + 0.5), floori(result.position.z + 0.5))
		if tiles.has(_pos):
			return tiles[_pos]
	return null


func select_tiles(_tiles: Array[Tile]) -> void:
	grid_map.select_tiles(_tiles)


func deselect_tiles(_tiles: Array[Tile]) -> void:
	grid_map.deselect_tiles(_tiles)


func create_from_isometric_tile_map_sort() -> void:
	grid_map._create_from_tile_map()
