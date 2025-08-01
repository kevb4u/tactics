class_name Equippable extends Node

## This holds the primary slot a item will equip to. 
## A sword might have the main hand as the primary, 
## while a shield might use the off hand slot as the primary.
@export var default_slots: EquipSlots.Slot

## Some items might have a secondary configuration to equip an item, 
## such as a sword that can be used either single or two handed. 
## Some weapons may also be equippable in the offhand to allow dual wielding
@export var secondary_slots: EquipSlots.Slot

## This is the actual current slot an item is equipped in.
var slots: EquipSlots.Slot

var is_equipped: bool

func on_equip() -> void:
	if is_equipped:
		return
	
	is_equipped = true
	
	var features: Array[Node] = self.get_parent().get_children()
	
	var filtered_array = features.filter(func(node):return node is Feature)
	for node in filtered_array:
		node.activate(self.get_parent().get_parent().get_parent())


func on_unequip() -> void:
	if not is_equipped:
		return
	
	is_equipped = false
	
	var features: Array[Node] = self.get_parent().get_children()
	
	var filtered_array = features.filter(func(node):return node is Feature)
	for node in filtered_array:
		node.deactivate()
