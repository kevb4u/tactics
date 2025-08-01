extends Node

const max_signed_int_32: int = 2147483647 #max signed 32bit number
const max_signed_int_64: int = 9223372036854775807 # Biggest value an int can store (-2^63 to 2^63 - 1)

var game_controller: GameController

func save_game() -> void:
	game_controller.save_manager.save_game()


func load_game() -> void:
	game_controller.save_manager.load_game()


func delete_save() -> void:
	game_controller.save_manager.delete_save()


func get_or_register_signal(key: FastKey) -> Signal:
	return game_controller.event_bus.get_or_register_signal(key)


func start_conversation(data: ConversationData) -> void:
	game_controller.conversation_controller.show(data)


func get_astar_path(start: Vector2, end: Vector2) -> Array[Vector2]:
	if game_controller.current_2d_scene is Level:
		return game_controller.current_2d_scene.get_astar_path(start, end)
	return []


func get_astar_path_3d(start: Vector2i, end: Vector2i) -> Array[Vector2i]:
	if game_controller.current_2d_scene is Level:
		return game_controller.current_2d_scene.get_astar_path_3d(start, end)
	return []


func get_mouse_position() -> Vector2:
	if game_controller.current_2d_scene is Level:
		return game_controller.current_2d_scene.get_mouse_position()
	return Vector2.ZERO


func get_tile_mouse_postion() -> Tile:
	if game_controller.current_2d_scene is Level:
		return game_controller.current_2d_scene.get_tile_mouse_position()
	return null


func get_tile_mouse_postion_3d() -> Tile:
	if game_controller.current_3d_scene is Level3D:
		return game_controller.current_3d_scene.get_tile_mouse_position()
	return null


func get_tile_3d(local_position: Vector2) -> Tile:
	if game_controller.current_2d_scene is Level:
		return game_controller.current_2d_scene.get_tile(local_position)
	return null


func get_tile(local_position: Vector2) -> Tile:
	if game_controller.current_2d_scene is Level:
		return game_controller.current_2d_scene.get_tile(local_to_map(local_position))
	return null


func get_tile_with_height(local_position: Vector2) -> Tile:
	if game_controller.current_2d_scene is Level:
		return game_controller.current_2d_scene.get_tile_with_height(local_position)
	return null


func local_to_map(local_position: Vector2) -> Vector2i:
	if game_controller.current_2d_scene is Level:
		return game_controller.current_2d_scene.local_to_map(local_position)
	return Vector2i.ZERO


func map_to_local(map_position: Vector2i) -> Vector2:
	if game_controller.current_2d_scene is Level:
		return game_controller.current_2d_scene.map_to_local(map_position)
	return Vector2.ZERO
