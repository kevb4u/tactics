extends BattleState

@export var cutSceneState: State
var enemy: Entity


func enter() -> void:
	super()
	init()


func init() -> void:
	#var p: Vector2i = _owner.level.tiles.keys()[0]
	#select_tile(p)
	
	init_unit(Global.game_controller.player_manager.player, AllianceType.Alliances.Hero)
	init_unit(enemy, AllianceType.Alliances.Enemy)
	add_attack_pattern(Global.game_controller.player_manager.player.unit, "")
	add_attack_pattern(enemy.unit, "attack_pattern")
	
	#TranslationServer.set_locale("ja")
	TranslationServer.set_locale("en")
	#TranslationServer.set_locale("es")
	
	add_victory_condition()
	_owner.auto_status_controller.on_enable()
	_owner.turn_order_controller.turn_round()
	_owner.state_machine.change_state(cutSceneState)


func init_unit(entity: Entity, alliance: AllianceType.Alliances) -> void:
	var entity_3d: Entity3D
	if entity:
		entity_3d = entity.unit.entity_3d
	else:
		entity = _owner.entity_prefrab.instantiate()
		Global.game_controller.current_2d_scene.add_child(entity)
		entity_3d = _owner.entity_3d_prefrab.instantiate()
		Global.game_controller.current_3d_scene.add_child(entity_3d)
		entity_3d.sync(entity)
	
	var job_list: Array[String] = ["Rogue", "Warrior", "Wizard"]
	var path = "res://tactics/data/jobs/"
	
	var unit: Unit = entity.unit
	unit.name = entity.name
	unit.entity_3d = entity_3d
	
	unit.alliance.type = alliance
	
	var s: Stats = unit.find_child("Stats")
	if s == null:
		s = Stats.new()
		unit.add_child(s)
		s.name = "Stats"
		s.set_stat(StatTypes.Stat.LVL, 1)
	
	
	var job: Job = unit.find_child("Job")
	if job == null:
		var full_path: String = path + job_list[0] + ".tscn"
		var scene: PackedScene = load(full_path)
		job = scene.instantiate()
		unit.add_child(job)
		job.employ()
		job.load_default_stats()
	
	var p: Vector2i = Global.local_to_map(entity.global_position)
	
	unit.place(_owner.level.get_tile(p))
	unit.match_with_tile()
	
	var _m = unit.find_child("Movement")
	_m.set_script(WalkMovement)
	_m.range = 5
	_m.jump_height = 1
	_m.set_process(true)
	
	units.append(unit)
	
	## Add level
	var rank: Rank = unit.find_child("Rank")
	if rank == null:
		rank = Rank.new()
		rank.name = "Rank"
		unit.add_child(rank)
		rank.init(10)
		
		## Add Health
		var health: Health = Health.new()
		unit.add_child(health)
		health.name = "Health"
		
		## Add Mana
		var mana: Mana = Mana.new()
		unit.add_child(mana)
		mana.name = "Mana"


func add_attack_pattern(unit: Unit, _name: String) -> void:
	var driver: Driver = Driver.new()
	unit.add_child(driver)
	driver.name = "Driver"
	if _name.is_empty():
		driver.normal = Drivers.Dri.Human
	else:
		driver.normal = Drivers.Dri.Computer
		var path = "res://tactics/data/attack_pattern/"
		var full_path: String = path + _name + ".tscn"
		var scene: PackedScene = load(full_path)
		var attack_pattern: AttackPattern = scene.instantiate()
		unit.add_child(attack_pattern)
		attack_pattern.name = "AttackPattern"


func add_victory_condition() -> void:
	var vc: DefeatTargetVictoryCondition = DefeatTargetVictoryCondition.new()
	_owner.add_child(vc)
	vc.on_enable()
	vc.name = "VictoryCondition"
	var enemy: Unit = units[units.size() - 1]
	vc.target = enemy
	var health: Health = enemy.get_node("Health")
	health.min_hp = 10
