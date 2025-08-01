class_name ConversationController extends Node

signal complete_event
signal resume

@export var left_panel: ConversationPanel
@export var right_panel: ConversationPanel

var is_active: bool = false
var in_transition: bool

func _ready() -> void:
	left_panel.to_anchor_position(left_panel.get_my_anchor("Hide Bottom"), false)
	_disable_dode(left_panel)
	
	right_panel.to_anchor_position(right_panel.get_my_anchor("Hide Bottom"), false)
	_disable_dode(right_panel)


func show(data: ConversationData) -> void:
	is_active = true
	_enable_node(left_panel)
	_enable_node(right_panel)
	sequence(data)


func sequence(data: ConversationData) -> void:
	for sd in data.list:
		in_transition = true
		var current_panel: ConversationPanel
		if(sd.anchor == Control.PRESET_TOP_LEFT || sd.anchor == Control.PRESET_BOTTOM_LEFT || sd.anchor == Control.PRESET_CENTER_LEFT):
			current_panel = left_panel
		else:
			current_panel = right_panel
		
		var show_anchor: PanelAnchor
		var hide_anchor: PanelAnchor
		
		if(sd.anchor == Control.PRESET_TOP_LEFT || sd.anchor == Control.PRESET_TOP_RIGHT || sd.anchor == Control.PRESET_CENTER_TOP):
			show_anchor = current_panel.get_my_anchor("Show Top")
			hide_anchor = current_panel.get_my_anchor("Hide Top")
		else:
			show_anchor = current_panel.get_my_anchor("Show Bottom")
			hide_anchor = current_panel.get_my_anchor("Hide Bottom")
			
		#make sure panel is hidden to start and set text to initial dialog
		current_panel.to_anchor_position(hide_anchor, false)
		current_panel.display(sd)
		
		#move Panel and wait for it to finish moving
		await current_panel.to_anchor_position(show_anchor, true)
		
		#once panel is done moving we can start accepting clicks to advance dialog
		in_transition = false 
		await current_panel.finished
		if is_active == false: ## Breaks on stop
			break
		
		#Hide panel and wait for it to get off screen
		in_transition = true
		await current_panel.to_anchor_position(hide_anchor, true)
	
	end()


func next() -> void:
	if not in_transition:
		resume.emit()


func end() -> void:
	is_active = false
	in_transition = false
	resume.emit()
	left_panel.to_anchor_position(left_panel.get_my_anchor("Hide Bottom"), false)
	_disable_dode(left_panel)
	
	right_panel.to_anchor_position(right_panel.get_my_anchor("Hide Bottom"), false)
	_disable_dode(right_panel)
	complete_event.emit()


func _enable_node(node: Node) -> void:
	node.process_mode = Node.PROCESS_MODE_INHERIT
	node.show()


func _disable_dode(node: Node) -> void:
	node.process_mode = Node.PROCESS_MODE_DISABLED
	node.hide()
