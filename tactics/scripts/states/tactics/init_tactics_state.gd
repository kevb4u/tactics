extends TacticsState

func OnMove(e: Vector2i):
	var rotatedPoint: Vector2i = e #_owner.camera_controller.adjust_movement(e)
	select_tile(rotatedPoint + _owner.pos)
	#refresh_primary_stat_panel(_owner.pos)
	pass


func OnFire(e: int):
	print(e)
	pass


func on_mouse_click(_tile_pos: Tile, _button: int) -> void:
	return
