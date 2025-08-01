class_name ComputerPlayer extends Node

var bc: BattleController
var actor: Unit:
	get():
		return bc.turn.actor

var alliance: Alliance:
	get():
		return actor.alliance

var nearest_foe: Unit


func init() -> void:
	bc = Global.game_controller.battle_controller


func evaluate() -> PlanOfAttack:
	## Create and fill out a plan of attack
	var poa: PlanOfAttack = PlanOfAttack.new()
	
	## Step 1: Decide what ability to use
	var pattern: AttackPattern = actor.get_node("AttackPattern")
	if pattern:
		pattern.pick(poa)
	else:
		default_attack_pattern(poa)
	
	### Step 2: Determine where to move and aim to best use the ability
	if is_position_independent(poa):
		plan_position_independent(poa)
	elif is_direction_independent(poa):
		plan_direction_independent(poa)
	else:
		plan_direction_dependent(poa)
	
	if poa.ability == null:
		move_toward_opponent(poa)
	
	## Return the completed plan
	return poa


func default_attack_pattern(poa: PlanOfAttack) -> void:
	## Just get the first "Attack" ability
	poa.ability = actor.get_node("Attack")
	poa.targets = Targets.Target.Foe


func is_position_independent(poa: PlanOfAttack) -> bool:
	var range: AbilityRange = poa.ability.ability_range
	return range.is_position_oriented() == false


func plan_position_independent(poa: PlanOfAttack) -> void:
	var move_options: Array[Tile] = get_move_options()
	var tile: Tile = move_options[randi_range(0, move_options.size() - 1)]
	poa.move_location = tile.pos
	poa.fire_location = tile.pos


func is_direction_independent(poa: PlanOfAttack) -> bool:
	var range: AbilityRange = poa.ability.ability_range
	return not range.direction_oriented


func plan_direction_independent(poa: PlanOfAttack) -> void:
	var start_tile: Tile = actor.tile
	var map: Dictionary[Tile, AttackOption]
	var ar: AbilityRange = poa.ability.ability_range
	var move_options: Array[Tile] = get_move_options()
	
	for i in move_options.size():
		var move_tile: Tile = move_options[i]
		actor.place(move_tile)
		var fire_options: Array[Tile] = ar.get_tiles_in_range(bc.level)
		
		for j in fire_options.size():
			var fire_tile: Tile = fire_options[j]
			var ao: AttackOption = null
			if map.has(fire_tile):
				ao = map[fire_tile]
			else:
				ao = AttackOption.new()
				map[fire_tile] = ao
				ao.target = fire_tile
				ao.direction = actor.dir
				rate_fire_location(poa, ao)
			
			ao.add_move_target(move_tile)
	
	actor.place(start_tile)
	var list: Array[AttackOption] = map.values()
	pick_best_option(poa, list)


func plan_direction_dependent(poa: PlanOfAttack) -> void:
	var start_tile: Tile = actor.tile
	var start_direction: Directions.Dirs = actor.dir
	var list: Array[AttackOption]
	var move_options: Array[Tile] = get_move_options()
	
	for i in move_options.size():
		var move_tile: Tile = move_options[i]
		actor.place(move_tile)
		
		for j in 4:
			actor.dir = j
			var ao: AttackOption = AttackOption.new()
			ao.target = move_tile
			ao.direction = actor.dir
			rate_fire_location(poa, ao)
			ao.add_move_target(move_tile)
			list.append(ao)
	
	actor.place(start_tile)
	actor.dir = start_direction
	pick_best_option(poa, list)


## Start from the foe position and work backwards until
## it reaches a point in our move_options
func move_toward_opponent(poa: PlanOfAttack) -> void:
	var move_options: Array[Tile] = get_move_options()
	find_nearest_foe()
	if nearest_foe != null:
		var to_check: Tile = nearest_foe.tile
		while to_check != null:
			if move_options.has(to_check):
				poa.move_location = to_check.pos
				return
			to_check = to_check.prev
	
	poa.move_location = actor.tile.pos


func get_move_options() -> Array[Tile]:
	return actor.movement.get_tiles_in_range(bc.level, null)


func rate_fire_location(poa: PlanOfAttack, option: AttackOption) -> void:
	var area: AbilityArea = poa.ability.ability_area
	var tiles: Array[Tile] = area.get_tiles_in_area(bc.level, option.target.pos)
	option.area_targets = tiles
	option.is_caster_match = is_ability_target_match(poa, actor.tile)
	
	for i in tiles.size():
		var tile: Tile = tiles[i]
		if actor.tile == tiles[i] || not poa.ability.is_target(tile):
			continue
		
		var is_match: bool = is_ability_target_match(poa, tile)
		option.add_mark(tile, is_match)


func pick_best_option(poa: PlanOfAttack, list: Array[AttackOption]) -> void:
	var best_score: int = 1
	var best_options: Array[AttackOption]
	
	## It scores each attack option based on having more marks 
	## which are matches than marks which are not matches
	for i in list.size():
		var option: AttackOption = list[i]
		var score: int = option.get_score(actor, poa.ability)
		if score > best_score:
			best_score = score
			best_options.clear()
			best_options.append(option)
		elif score == best_score:
			best_options.append(option)
	
	if best_options.size() == 0:
		## Clear ability as a sign not to perform it
		poa.ability = null
		return
	
	## Some of those locations may be from the front, 
	## while others may be from the back. If I can pick,
	## I would want to pick an angle from the back so 
	## that my chances of the attack hitting are greater.
	var final_picks: Array[AttackOption]
	best_score = 0
	
	for i in best_options.size():
		var option: AttackOption = best_options[i]
		var score: int = option.best_angle_based_score
		if score > best_score:
			best_score = score
			final_picks.clear()
			final_picks.append(option)
		elif score == best_score:
			final_picks.append(option)
	
	var choice: AttackOption = final_picks[randi_range(0, final_picks.size() - 1)]
	poa.fire_location = choice.target.pos
	poa.attack_direction = choice.direction
	poa.move_location = choice.best_move_tile.pos


func is_ability_target_match(poa: PlanOfAttack, tile: Tile) -> bool:
	var is_match: bool = false
	
	if poa.target == Targets.Target.Tile:
		is_match = true
	elif poa.target != Targets.Target.None:
		var other: Alliance = tile.content.alliance
		if other != null and alliance.is_match(other, poa.target):
			is_match = true
		
	return is_match


func find_nearest_foe() -> void:
	nearest_foe = null
	bc.level.search(actor.tile, null, delegate)


func delegate(arg1: Tile, arg2: Tile, _target: Tile) -> bool:
	if (nearest_foe == null and arg2.content != null and arg2.content is Unit):
		var other: Alliance = arg2.content.alliance
		if other != null and alliance.is_match(other, Targets.Target.Foe):
			var unit: Unit = arg2.content
			var stats: Stats = unit.get_node("Stats")
			if stats.get_stat(StatTypes.Stat.HP) > 0:
				nearest_foe = unit
				return true
	return nearest_foe == null


func determine_end_facing_direction() -> Directions.Dirs:
	var dir: Directions.Dirs = randi_range(0, 3)
	find_nearest_foe()
	if nearest_foe != null:
		var start: Directions.Dirs = actor.dir
		for i in 4:
			actor.dir = i
			if nearest_foe.get_facing(actor) == Facing.Dir.Front:
				dir = actor.dir
				break
		actor.dir = start
	return dir
