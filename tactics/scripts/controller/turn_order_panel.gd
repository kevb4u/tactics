class_name TurnOrderPanel extends LayoutAnchor

@export var anchor_list: Array[PanelAnchor] = []

var UNIT_PANEL: PackedScene = preload("uid://dxo4gpmrwmls3")
@onready var order_indicator: VBoxContainer = %OrderIndicator

func set_position(anchor_name: String, animated: bool) -> void:
	var anchor = get_anchor(anchor_name)
	await to_anchor_position(anchor, animated)


func get_anchor(anchor_name: String) -> PanelAnchor:
	for anchor in self.anchor_list:
		if anchor.anchor_name == anchor_name:
			return anchor
	return null


func update(units: Array[Unit]) -> void:
	while order_indicator.get_children().size() < units.size() * 3:
		var panel: UnitTurnPanel = UNIT_PANEL.instantiate()
		order_indicator.add_child(panel)
	
	var units_size: int = units.size()
	for i in units_size:
		order_indicator.get_child(i).unit = units[i]
		order_indicator.get_child(i).update()
	
	## Fake future turn order
	for i in units_size:
		order_indicator.get_child(i + units_size).unit = units[i]
		order_indicator.get_child(i + units_size).update(1)
	
	for i in units_size:
		order_indicator.get_child(i + (units_size * 2)).unit = units[i]
		order_indicator.get_child(i + (units_size * 2)).update(2)
