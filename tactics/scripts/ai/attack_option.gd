class_name AttackOption extends Node

class Mark:
	var tile: Tile
	var is_match: bool
	
	func _init(_tile: Tile, _is_match: bool) -> void:
		tile = _tile
		is_match = _is_match

var target: Tile
var direction: Directions.Dirs
var area_targets: Array[Tile]
var is_caster_match: bool
var best_move_tile: Tile
var best_angle_based_score: int
var marks: Array[Mark]
var move_targets: Array[Tile]

func add_move_target(tile: Tile) -> void:
	## Dont allow moving to a tile that would negatively affect the caster
	if not is_caster_match and area_targets.has(tile):
		return
	move_targets.append(tile)


func add_mark(tile: Tile, is_match: bool) -> void:
	marks.append(Mark.new(tile, is_match))


func get_score(caster: Unit, ability: Ability) -> int:
	get_best_move_target(caster, ability)
	if best_move_tile == null:
		return 0
	
	var score: int = 0
	
	for i in marks.size():
		if marks[i].is_match:
			score += 1
		else:
			score -= 1
	
	if is_caster_match and area_targets.has(best_move_tile):
		score += 1
	
	return score


func get_best_move_target(caster: Unit, ability: Ability) -> void:
	if move_targets.size() == 0:
		return
	
	if is_ability_angle_based(ability):
		best_angle_based_score = -Global.max_signed_int_32
		var start_tile: Tile = caster.tile
		var start_direction: Directions.Dirs = caster.dir
		caster.dir = direction
		
		var best_options: Array[Tile]
		
		for i in move_targets.size():
			caster.place(move_targets[i])
			var score: int = get_angle_based_score(caster)
			
			if score > best_angle_based_score:
				best_angle_based_score = score
				best_options.clear()
			if score == best_angle_based_score:
				best_options.append(move_targets[i])
		
		caster.place(start_tile)
		caster.dir = start_direction
		
		filter_best_moves(best_options)
		best_move_tile = best_options[randi_range(0, best_options.size() - 1)]
	else:
		best_move_tile = move_targets[randi_range(0, move_targets.size() - 1)]


func is_ability_angle_based(ability: Ability) -> bool:
	for i in ability.get_child_count():
		var component: Node = ability.get_child(i)
		for j in component.get_child_count():
			if component.get_child(j) is HitRate:
				var hit_rate: HitRate = component.get_child(j)
				if hit_rate.is_angle_based():
					return true
	return false


func get_angle_based_score(caster: Unit) -> int:
	var score: int = 0
	for i in marks.size():
		var value: int = 1 if marks[i].is_match else -1
		var multiplier: int = multiplier_for_angle(caster, marks[i].tile)
		score += value * multiplier
	return score


func multiplier_for_angle(caster: Unit, tile: Tile) -> int:
	if tile.content == null:
		return 0
	
	var defender: Unit = tile.content
	if defender == null:
		return 0
	
	var facing: Facing.Dir = caster.get_facing(defender)
	if facing == Facing.Dir.Back:
		return 90
	if facing == Facing.Dir.Side:
		return 75
	return 50


func filter_best_moves(list: Array[Tile]) -> void:
	if not is_caster_match:
		return
	
	var can_target_self: bool = false
	for i in list.size():
		if area_targets.has(list[i]):
			can_target_self = true
			break
	
	if can_target_self:
		var i: int = list.size() - 1
		while i >= 0:
			if not area_targets.has(list[i]):
				list.remove_at(i)
			i -= 1
