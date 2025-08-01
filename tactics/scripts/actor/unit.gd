class_name Unit extends GameObject

@onready var movement: Movement = $Movement
@onready var inventory: Inventory = $Inventory
@onready var equipment: Equipment = $Equipment
@onready var alliance: Alliance = $Allliance
@onready var status: Status = $Status
@onready var ability_catalog: AbilityCatalog = $AbilityCatalog

@onready var job: Job = $Job


var entity: Entity:
	set(value):
		entity = value
		sprite_2d = entity.sprite

var entity_3d: Entity3D:
	set(value):
		entity_3d = value
		sprite_3d = entity_3d.sprite

var dir: Directions.Dirs = Directions.Dirs.NORTH: set = _on_dir_change

func _ready() -> void:
	job.employ()
	job.load_default_stats()


func move(target: Tile) -> void:
	if target == null:
		return
	if movement.is_active:
		if movement.walk_tween.finished.is_connected(movement.done_move_tile):
			movement.walk_tween.finished.disconnect(movement.done_move_tile)
		elif movement.walk_tween.finished.is_connected(create_movement):
			movement.walk_tween.finished.disconnect(create_movement)
		movement.walk_tween.finished.connect(create_movement.bind(target))
	else:
		create_movement(target)


func create_movement(target: Tile) -> void:
	movement.get_tiles_in_range(Global.game_controller.current_2d_scene, target)
	movement.traverse(target)


func get_facing(target: Unit) -> Facing.Dir:
	return Facing.get_facing(self, target)


func _on_dir_change(value: Directions.Dirs) -> void:
	dir = value
	match value:
		Directions.Dirs.NORTH:
			sprite_2d.flip_h = false
			sprite_2d.frame = 16
		Directions.Dirs.SOUTH:
			sprite_2d.flip_h = false
			sprite_2d.frame = 0
		Directions.Dirs.EAST:
			sprite_2d.flip_h = false
			sprite_2d.frame = 32
		Directions.Dirs.WEST:
			sprite_2d.flip_h = true
			sprite_2d.frame = 32
	sync_sprite()
