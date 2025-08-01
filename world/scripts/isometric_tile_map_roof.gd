@tool
class_name IsometricTileMapRoof extends IsometricTileMap

@export_tool_button("Bake Transparent Collision") var bake = bake_transparent_collsion
@export var roof_height: int = 4
@onready var area_2d: Area2D = $Area2D
@onready var collision_polygon_2d: CollisionPolygon2D = $Area2D/CollisionPolygon2D

func _ready() -> void:
	super()
	bake_transparent_collsion()
	z_index = 1
	area_2d.body_entered.connect(_on_body_enter)
	area_2d.body_exited.connect(_on_body_exit)


func bake_transparent_collsion() -> void:
	var polygon := []
	spiral(get_used_rect().size.x, get_used_rect().size.y, polygon)
	collision_polygon_2d.polygon = polygon


#TODO: ONLY CAN DO EVEN SIZE SQUARES
# FIX SO IT SNAKES AROUND THE OUTER EDGE ONLY
func spiral(X: int, Y: int, polygon: Array):
	var x_offset: int = X / 2 + (X % 2 - 1)
	var y_offset: int = Y / 2 + (Y % 2 - 1)
	var x: int = 0
	var y: int = 0
	var dx: int = 0
	var dy: int = -1
	for i in range(max(X, Y)**2):
		if ((-X/2 < x) and (x <= X/2)) and ((-Y/2 < y) and (y <= Y/2)):
			#print(x + x_offset, y + y_offset)
			## DO STUFF
			add_points_to_polygon(x + x_offset, y + y_offset, polygon)
		if x == y or (x < 0 and x == -y) or (x > 0 and x == 1-y):
			var temp: int = dx
			dx = -dy
			dy = temp
		x = x+dx
		y = y+dy


func add_points_to_polygon(x: int, y: int, polygon: Array) -> void:
	var tile_position: Vector2i = get_used_rect().position + Vector2i(x, y)
	var tile_data := get_cell_tile_data(tile_position)
	var tile_data_N := get_cell_tile_data(tile_position + Vector2i.UP)
	var tile_data_S := get_cell_tile_data(tile_position + Vector2i.DOWN)
	var tile_data_E := get_cell_tile_data(tile_position + Vector2i.RIGHT)
	var tile_data_W := get_cell_tile_data(tile_position + Vector2i.LEFT)
	#var tile_data_NE := get_cell_tile_data(tile_position + Vector2i.UP + Vector2i.RIGHT)
	#var tile_data_SE := get_cell_tile_data(tile_position + Vector2i.DOWN + Vector2i.RIGHT)
	#var tile_data_NW := get_cell_tile_data(tile_position + Vector2i.UP + Vector2i.LEFT)
	#var tile_data_SW := get_cell_tile_data(tile_position + Vector2i.DOWN + Vector2i.LEFT)
	var tile_size_y: int = tile_set.tile_size.y
	
	# TODO: ADD IN ALL THE OPTIONS
	if tile_data and tile_data_N == null and tile_data_S == null and tile_data_E == null and tile_data_W == null:
		polygon.append(map_to_local(tile_position) + Vector2(0, 8)   + Vector2(0, tile_size_y * roof_height))
		polygon.append(map_to_local(tile_position) + Vector2(16, 0)  + Vector2(0, tile_size_y * roof_height))
		polygon.append(map_to_local(tile_position) + Vector2(0, -8)  + Vector2(0, tile_size_y * roof_height))
		polygon.append(map_to_local(tile_position) + Vector2(-16, 0) + Vector2(0, tile_size_y * roof_height))
	elif tile_data and tile_data_N and tile_data_S == null and tile_data_E and tile_data_W == null:
		polygon.append(map_to_local(tile_position) + Vector2(-16, 0) + Vector2(0, tile_size_y * roof_height))
	elif tile_data and tile_data_N == null and tile_data_S and tile_data_E and tile_data_W == null:
		polygon.append(map_to_local(tile_position) + Vector2(0, -8)  + Vector2(0, tile_size_y * roof_height))
	elif tile_data and tile_data_N == null and tile_data_S and tile_data_E == null and tile_data_W:
		polygon.append(map_to_local(tile_position) + Vector2(16, 0)  + Vector2(0, tile_size_y * roof_height))
	elif tile_data and tile_data_N and tile_data_S == null and tile_data_E == null and tile_data_W:
		polygon.append(map_to_local(tile_position) + Vector2(0, 8)   + Vector2(0, tile_size_y * roof_height))


func _on_body_enter(_body: Node2D) -> void:
	if _body == Global.game_controller.player_manager.player:
		modulate = Color(1,1,1,0.1)


func _on_body_exit(_body: Node2D) -> void:
	if _body == Global.game_controller.player_manager.player:
		modulate = Color(1,1,1,1)
