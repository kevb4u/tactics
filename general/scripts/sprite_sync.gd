class_name SpriteSync extends Sprite2D

func _ready() -> void:
	child_entered_tree.connect(on_child_enter)
	frame_changed.connect(on_frame_change)


func on_child_enter(child: Node) -> void:
	if child is Sprite2D or child is Sprite3D:
		#child.texture = texture
		child.hframes = hframes
		child.vframes = vframes
		child.frame = frame
		child.offset = offset
		child.flip_h = flip_h
		if child is Sprite3D:
			child.offset = -offset


func on_frame_change() -> void:
	for child in get_children():
		if child is Sprite2D or child is Sprite3D: 
			child.frame = frame
