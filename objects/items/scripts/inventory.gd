class_name Inventory extends Node

var _owner: Unit
var consumables: Dictionary[ItemResource, Item]
var equippable: Array[Item]

func _ready() -> void:
	_owner = get_parent()
	child_entered_tree.connect(_on_child_enter)


func _on_child_enter(node: Node) -> void:
	if node is Item:
		if consumables.has(node.item_resource):
			consumables[node.item_resource].quantity += 1
		else:
			if node.item_resource.type == ItemType.TYPE.Consumable:
				consumables[node.item_resource] = node
			elif node.item_resource.type == ItemType.TYPE.Equippable:
				equippable.append(node)
			node.quantity = 1


func use_item(item_index: int) -> void:
	if get_child(item_index):
		get_child(item_index).use(_owner)
	# TODO: remove from array
