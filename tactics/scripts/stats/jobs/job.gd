class_name Job extends Node

const stat_order: Array[StatTypes.Stat] = [
		StatTypes.Stat.MHP, 
		StatTypes.Stat.MMP, 
		StatTypes.Stat.ATK,
		StatTypes.Stat.DEF,
		StatTypes.Stat.MAT,
		StatTypes.Stat.MDF,
		StatTypes.Stat.SPD
	]

@export var base_stats: Array[int]
@export var grow_stats: Array[float]
var stats: Stats

func _init():
	base_stats.resize(stat_order.size())
	base_stats.fill(0)
	grow_stats.resize(stat_order.size())
	grow_stats.fill(0)


## Each Job will have its own move and jump modifier
func employ() -> void:
	for child in self.get_parent().get_children():
		if child is Stats:
			stats = child
	stats.did_change_notification(StatTypes.Stat.LVL).connect(on_lvl_change_notification)

	var features:Array[Node] = self.get_children()
	
	var filteredArray = features.filter(func(node):return node is Feature)
	for node in filteredArray:
		node.activate(self.get_parent())


func unemploy() -> void:
	var features:Array[Node] = self.get_parent().get_children()
	
	var filteredArray = features.filter(func(node):return node is Feature)
	for node in filteredArray:
		node.deactivate()

	stats.did_change_notification(StatTypes.Stat.LVL).disconnect(on_lvl_change_notification)
	stats = null


## Loops through the stat then set them
func load_default_stats() -> void:
	for i in stat_order.size():
		stats.set_stat(stat_order[i], base_stats[i], false)
		
	stats.set_stat(StatTypes.Stat.HP, stats.get_stat(StatTypes.Stat.MHP), false)
	stats.set_stat(StatTypes.Stat.MP, stats.get_stat(StatTypes.Stat.MMP), false)


func on_lvl_change_notification(_sender: Stats, old_value: int) -> void:
	var new_level = stats.get_stat(StatTypes.Stat.LVL)
	for i in range(old_value, new_level, 1):
		level_up()


func level_up() -> void:
	for i in stat_order.size():
		var type: StatTypes.Stat = stat_order[i]
		var whole: int = floori(grow_stats[i])
		var fraction: float = grow_stats[i] - whole
		var value: int = stats.get_stat(type)
		value += whole
		
		if randf() > (1.0 - fraction):
			value += 1
			
		stats.set_stat(type, value, false)
	
	stats.set_stat(StatTypes.Stat.HP, stats.get_stat(StatTypes.Stat.MHP), false)
	stats.set_stat(StatTypes.Stat.MP, stats.get_stat(StatTypes.Stat.MMP), false)
