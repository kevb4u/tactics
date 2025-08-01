class_name StatPanelController extends Node

const show_key: String = "Show"
const hide_key: String = "Hide"

@export var primary_panel: StatPanel
@export var secondary_panel: StatPanel

var primary_showing: bool
var secondary_showing: bool

func _ready() -> void:
	primary_panel.to_anchor_position(primary_panel.get_anchor(hide_key), false)
	primary_showing = false
	secondary_panel.to_anchor_position(secondary_panel.get_anchor(hide_key), false)
	secondary_showing = false


func show_primary(obj: Node) -> void:
	primary_panel.display(obj)
	if primary_showing == false:
		primary_showing = true
		await primary_panel.set_position(show_key, true)


func hide_primary() -> void:
	if primary_showing == true:
		primary_showing = false
		await primary_panel.set_position(hide_key, true)


func show_secondary(obj: Node) -> void:
	secondary_panel.display(obj)
	if secondary_showing == false:
		secondary_showing = true
		await secondary_panel.set_position(show_key, true)


func hide_secondary() -> void:
	if secondary_showing == true:
		secondary_showing = false
		await secondary_panel.set_position(hide_key, true)
