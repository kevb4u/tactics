class_name GrassStatusEffect extends StatusEffect

var tile: Tile

func on_enable() -> void:
	tile.change_tile(14)


func on_disable() -> void:
	tile.change_tile(tile.default_cell)
