class_name PlayerManager extends Node

var player: Entity
var player_3d: Entity3D

var prev_mouse_tile: Tile
var mouse_tile: Tile

var interactable: Interactable

func init() -> void:
	var PLAYER := preload("uid://xnpa5jbxrgsb")
	player = PLAYER.instantiate()
	player.name = "Player"


func start() -> void:
	add_to_level()
	await Global.game_controller.level_loaded
	player_3d = player.unit.entity_3d
	mouse_tile = Global.get_tile_mouse_postion_3d()
	prev_mouse_tile = mouse_tile


func add_to_level() -> void:
	if player.get_parent():
		player.get_parent().remove_child(player)
	Global.game_controller.world_2d.add_child(player)
	player.unit.movement.finished.connect(on_movement_finished)


func _unhandled_input(_event: InputEvent) -> void:
	mouse_tile = Global.get_tile_mouse_postion_3d()
	
	if Global.game_controller.battle_controller.in_battle == false:
		if Input.is_action_just_pressed("right_click"):
			if mouse_tile:
				Global.game_controller.current_3d_scene.pos = mouse_tile.pos
				
				if mouse_tile.content != null:
					if mouse_tile.content.get_parent() != null:
						if mouse_tile.content.get_parent() is Interactable:
							interactable = mouse_tile.content.get_parent()
				
				player.unit.move(mouse_tile)
		
		if prev_mouse_tile != mouse_tile:
			if prev_mouse_tile != null:
				prev_mouse_tile.deselect_tile()
			if mouse_tile != null:
				mouse_tile.select_tile()
		
		prev_mouse_tile = mouse_tile
	
	#if Input.is_action_just_pressed("up"):
		#player.unit.inventory.use_item(0)
	#elif Input.is_action_just_pressed("down"):
		#Global.game_controller.save_manager.load_game()
	#elif Input.is_action_just_pressed("left"):
		#player.unit.dir = Directions.Dirs.WEST
	#elif Input.is_action_just_pressed("right"):
		#player.unit.dir = Directions.Dirs.EAST


func on_movement_finished() -> void:
	if interactable:
		interactable.interact(player)
		interactable = null
