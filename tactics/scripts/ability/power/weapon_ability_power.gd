class_name WeaponAbilityPower extends BaseAbilityPower

var level: int

func get_base_attack() -> int:
	var stats: Stats = get_parent().get_parent().get_parent().get_node("Stats")
	return stats.get_stat(StatTypes.Stat.ATK)


func get_base_defense(target: Unit) -> int:
	var stats: Stats = target.get_node("Stats")
	return stats.get_stat(StatTypes.Stat.DEF)


func get_power() -> int:
	var power: int = power_from_equipped_weapon()
	return power if power > 0 else unarmed_power()


func power_from_equipped_weapon() -> int:
	var power: int = 0
	var equipment: Equipment = get_parent().get_parent().get_parent().get_node("Equipment")
	var item: Equippable = equipment.get_item(EquipSlots.Slot.PRIMARY)
	var features: Array[StatModifierFeature] = item.get_children().filter(func(node): return node is StatModifierFeature)
	
	for feature in features:
		if feature.type == StatTypes.Stat.ATK:
			power += feature.amount
	
	return power


func unarmed_power() -> int:
	var job: Job = get_parent().get_parent().get_parent().get_node("Job")
	for i in Job.stat_order.size():
		if Job.stat_order[i] == StatTypes.Stat.ATK:
			return job.base_stats[i]
	return 0
