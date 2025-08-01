class_name SnowStatusEffect extends StatusEffect

var tile: Tile

func on_enable() -> void:
	tile.change_tile(25)


func on_disable() -> void:
	tile.change_tile(tile.default_cell)
