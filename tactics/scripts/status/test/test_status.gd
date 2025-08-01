extends Node

var cursedUnit: Unit
var cursedItem: Equippable
var step: int

func OnEnable():
	Global.game_controller.battle_controller.turn_order_controller.turn_check_notification.connect(OnTurnCheck)


func OnDisable():
	Global.game_controller.battle_controller.turn_order_controller.turn_check_notification.disconnect(OnTurnCheck)


func OnTurnCheck(target: Unit, exc: BaseException):
	if exc.toggle == false:
		return
	
	match step:
		0:
			EquipCursedItem(target)
		1:
			Add(SlowStatusEffect.new(), target, 2)
		#2:
			#Add(StopStatusEffect.new(), target, 15)
		3:
			Add(HasteStatusEffect.new(), target, 3)
		#_:
			#UnEquipCursedItem(target);
	step += 1


func Add(status_effect: StatusEffect, target: Unit, duration: int):
	var status: Status = target.get_node("Status")
	var condition: DurationStatusCondition = status.add(status_effect, DurationStatusCondition.new())
	condition.duration = duration


func EquipCursedItem(target: Unit):
	cursedUnit = target;

	var obj: Node = Node.new()
	cursedItem = Equippable.new()
	obj.add_child(AddPoisonStatusFeature.new())
	obj.add_child(cursedItem)
	cursedItem.default_slots = EquipSlots.Slot.PRIMARY
#
	var equipment: Equipment = target.get_node("Equipment")
	equipment.equip(cursedItem, EquipSlots.Slot.PRIMARY)
	print("Equipped Curse Item::" + target.name)


func UnEquipCursedItem(target: Unit):
	if target != cursedUnit || step < 10:
		return

	var equipment: Equipment = target.get_node("Equipment")
	equipment.unequip_item(cursedItem)
	#Destroy(cursedItem.gameObject)
#
	#Destroy(this)
