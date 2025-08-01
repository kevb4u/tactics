class_name Equipment extends Node

signal equipped_notification(equipement: Equipment, item: Equippable)
signal unequipped_notification(equipement: Equipment, item: Equippable)

var items: Array[Equippable]

func equip(item: Equippable, slots: EquipSlots.Slot) -> void:
	unequip_slots(slots)
	
	items.append(item)
	var item_parent: Item = item.get_parent()
	if item_parent.get_parent():
		item_parent.get_parent().remove_child(item_parent)
	self.add_child(item_parent)
	item.slots = slots
	item.on_equip()
	equipped_notification.emit(self, item)


func unequip_item(item: Equippable) -> void:
	item.on_unequip()
	item.slots = EquipSlots.Slot.NONE
	items.erase(item)
	var item_parent: Item = item.get_parent()
	self.remove_child(item_parent)
	var unit: Unit = get_parent()
	unit.inventory.add_child(item_parent)
	unequipped_notification.emit(self, item)


func unequip_slots(slots: EquipSlots.Slot) -> void:
	for i in range(items.size()-1,-1,-1):
		var item = items[i]
		if (item.slots & slots) != EquipSlots.Slot.NONE:
			unequip_item(item)


func get_item(slots: EquipSlots.Slot) -> Equippable:
	for i in items.size():
		var item: Equippable = items[i]
		if item.slots == slots and slots != EquipSlots.Slot.NONE:
			return item
	return null
