class_name EarthStatusEffect extends StatusEffect

var tile: Tile

func on_enable() -> void:
	tile.height_offset = 1
	tile.change_tile(10)
	tile.height_offset = 2
	tile.change_tile(10)
	if tile.content is Unit:
		(tile.content as Unit).match_with_tile()


func on_disable() -> void:
	tile.change_tile(-1)
	tile.height_offset = 1
	tile.change_tile(-1)
	tile.height_offset = 0
	if tile.content is Unit:
		(tile.content as Unit).match_with_tile()
