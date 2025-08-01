class_name GameObject extends Node

signal changed_tile(new_tile: Tile)

var sprite_2d: Sprite2D:
	set(value):
		og_offset = value.offset.y
		sprite_2d = value

var sprite_3d: Sprite3D:
	set(value):
		sprite_3d = value
		call_deferred("init")

var tile: Tile
var og_offset: float

func init() -> void:
	var tile: Tile = Global.get_tile_with_height(sprite_2d.get_parent().global_position)
	place(tile)
	match_with_tile()
	if sprite_2d.frame_changed.is_connected(sync_sprite) == false:
		sprite_2d.frame_changed.connect(sync_sprite)
	sync_sprite()


func place(target: Tile) -> void:
	#Make sure old tile location is not still pointing to this unit
	if tile != null && tile.content == self:
		tile.content = null
	
	#Link unit and tile references
	tile = target
	changed_tile.emit(target)
	
	if target != null:
		target.content = self


func match_with_tile() -> void:
	sprite_2d.get_parent().global_position = Global.map_to_local(tile.pos)
	sprite_2d.offset.y = (tile.height * -16) + og_offset
	sprite_3d.get_parent().global_position = Vector3(tile.pos.x, tile.height, tile.pos.y)


func sync_sprite() -> void:
	sprite_3d.texture = sprite_2d.texture
	sprite_3d.hframes = sprite_2d.hframes
	sprite_3d.vframes = sprite_2d.vframes
	sprite_3d.flip_h = sprite_2d.flip_h
	sprite_3d.frame = sprite_2d.frame
	sprite_3d.offset.y = -og_offset
	sprite_3d.pixel_size = 0.045
	sprite_3d.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	sprite_3d.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
