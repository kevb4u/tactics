class_name UnitTurnPanel extends Panel

var unit: Unit

@onready var label: Label = $VBoxContainer/Label
@onready var label_2: Label = $VBoxContainer/Label2

func update(turn: int = 0) -> void:
	label.text = unit.entity.name
	var stat: Stats = unit.get_node("Stats")
	
	var future_turn_offset: int = (TurnOrderController.turn_cost + TurnOrderController.action_cost + TurnOrderController.move_cost) * turn
	
	## Determine how many ticks it takes for next turn
	var current_ctr: int = stat.get_stat(StatTypes.Stat.CTR) + future_turn_offset
	var current_spd: int = stat.get_stat(StatTypes.Stat.SPD)
	var status: Status = unit.status
	## GET SPEED AFTER BUFFS / DEBUFFS
	## Buffs / Debuffs applied to CTR directly when changed
	## Loop through all status effects and combine change on CTR
	## Apply it to speed to calculate total change
	var modifier: float = -1
	## TODO: TURN off buffs / debuffs if removed in future
	
	for c in status.get_children():
		for cc in c.get_children():
			if cc is SlowStatusEffect:
				## TODO: GET DURATION STATUS CONDITION
				## then dont apply if the turn will disappear the status
				if modifier < 0:
					modifier = cc.modifier
				else:
					modifier *= cc.modifier
			elif cc is HasteStatusEffect:
				if modifier < 0:
					modifier = cc.modifier
				else:
					modifier *= cc.modifier
	if modifier > 0:
		current_spd *= modifier
	
	
	var ticks: int = 0
	if current_ctr > 0:
		ticks = ceili(current_ctr / current_spd)
	
	label_2.text = str(max(ticks, 0))
	
	#label_2.text = str(current_spd)
