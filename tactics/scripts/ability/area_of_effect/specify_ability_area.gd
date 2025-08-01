extends AbilityArea

@export var horizontal: int = 2
@export var vertical: int = 999999
var tile: Tile

## After selecting the attack range it will then spread out as AOE
func get_tiles_in_area(level: Level, pos: Vector2i) -> Array[Tile]:
	tile = level.get_tile(pos)
	return level.range_search(tile, null, expand_search, horizontal)


func expand_search(from: Tile, to: Tile, _target: Tile) -> bool:
	return (from.distance + 1) <= horizontal && abs(to.height - tile.height) <= vertical
