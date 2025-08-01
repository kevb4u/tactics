class_name FacingIndicator extends Node

@export var enable_texture: Texture2D
@export var disable_texture: Texture2D
@export var directions: Array[Node]

func set_active(active: bool) -> void:
	for d in directions:
		d.visible = active


func set_direction(dir: Directions.Dirs) -> void:
	for d in directions:
		d.texture = disable_texture
	
	directions[dir].texture = enable_texture
