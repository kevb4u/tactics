class_name Item extends Node

@export var item_resource: ItemResource
@export var quantity: int = 1
var node: Node

func _ready() -> void:
	if item_resource.type == ItemType.TYPE.Consumable:
		node = Consumable.new()
	elif item_resource.type == ItemType.TYPE.Equippable:
		node = Equippable.new()
	add_child(node)
	
	var stat_modifier: StatModifierFeature = StatModifierFeature.new()
	stat_modifier.type = item_resource.stat
	stat_modifier.amount = item_resource.amount
	add_child(stat_modifier)


func _init(_item_resource: ItemResource = null) -> void:
	item_resource = _item_resource


func use(target: Unit) -> void:
	if item_resource.type == ItemType.TYPE.Consumable:
		node.consume(target)
		quantity -= 1
		if quantity <= 0:
			queue_free()
	elif item_resource.type == ItemType.TYPE.Equippable:
		target.equipment.equip(node, node.default_slots)
