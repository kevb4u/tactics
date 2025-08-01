class_name CameraController3D extends Node3D

#var _owner: BattleController

@export var _follow_speed: float = 3.0
var _follow: Node3D

func _ready() -> void:
	#_owner = get_node("../")
	add_listeners()


func start_battle() -> void:
	set_follow(Global.game_controller.current_3d_scene.marker)


func start_overworld() -> void:
	set_follow(Global.game_controller.player_manager.player_3d)


func _process(delta) -> void:
	if _follow:
		self.position = self.position.lerp(_follow.position, _follow_speed * delta)


func adjust_movement(originalPoint: Vector2i) -> Vector2i:
	var angle = 0#rad_to_deg($Heading.rotation.y)
	if ((angle >= -45 && angle < 45) || ( angle < -315 || angle >= 315)):
		return originalPoint
	elif ((angle >= 45 && angle < 135) || ( angle >= -315 && angle < -225 )):
		return Vector2i( originalPoint.y, originalPoint.x * -1)
	elif ((angle >= 135 && angle < 225) || ( angle >= -225 && angle < -135 )):
		return Vector2i(originalPoint.x * -1, originalPoint.y * -1)
	elif ((angle >= 225 && angle < 315) || ( angle >= -135 && angle < -45 )):
		return Vector2i(originalPoint.y * -1, originalPoint.x)
	else:
		print("Camera angle is wrong: " + str(angle))
		return originalPoint


func set_follow(follow: Node3D) -> void:
	if follow:
		_follow = follow


func _exit_tree() -> void:
	remove_listeners()


func add_listeners() -> void:
	pass


func remove_listeners() -> void:
	pass
