class_name Directions


enum Dirs
{
	SOUTH = 0,
	EAST = 1,
	NORTH = 2,
	WEST = 3,
}


static func to_vector(d: Dirs) -> Vector2i:
	#SOUTH,EAST,NORTH,WEST 
	var _dirs = [Vector2i(0,1), Vector2i(1,0), Vector2i(0,-1), Vector2i(-1,0)]
	return _dirs[d]


static func to_dir(p: Vector2i) -> Dirs:
	if(p.y < 0):
		return Dirs.NORTH
	if(p.x < 0):
		return Dirs.WEST
	if(p.y > 0):
		return Dirs.SOUTH
	return Dirs.EAST


static func get_directions(t1: Tile, t2: Tile):
	var dir: Directions.Dirs
	var toTile: Vector2i = t1.pos - t2.pos
	if abs(toTile.x) > abs(toTile.y):
		dir = Directions.Dirs.EAST if toTile.x < 0 else Directions.Dirs.WEST
	else:
		dir = Directions.Dirs.SOUTH if toTile.y < 0 else Directions.Dirs.NORTH
	
	return dir


static func ToEuler(d: Dirs):
	return Vector3(0, d * 90, 0)
