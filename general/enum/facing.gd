class_name Facing

# B S S S F
# B B S F F
# B B > F F
# B B S F F
# B S S S F

enum Dir {
	Front,
	Side,
	Back,
}


static func get_facing(attacker: Unit, target: Unit) -> Dir:
	var target_direction: Vector2 = Directions.to_vector(target.dir)
	var approach_direction: Vector2 = ((target.tile.pos - attacker.tile.pos) as Vector2).normalized();
	var dot: float = target_direction.dot(approach_direction)
	if dot >= 0.45:
		return Dir.Back;
	if dot <= -0.45:
		return Dir.Front;
	return Dir.Side
