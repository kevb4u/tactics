class_name PauseMenu extends CanvasLayer

static var is_paused: bool = false

@onready var label: Label = $Control/Panel/Label
@onready var label_2: Label = $Control/Panel/Label2
@onready var tactics: Tactics = $Control/Tactics

func _ready() -> void:
	pause(false)


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("esc") and Global.game_controller.battle_controller.in_battle == false:
		pause(not is_paused)
		if is_paused:
			var inventory: Inventory = Global.game_controller.player_manager.player.unit.inventory
			label.text = ""
			label_2.text = ""
			if inventory.get_child(0):
				label.text = str(inventory.get_child(0).name)
			if inventory.get_child(1):
				label_2.text = str(inventory.get_child(1).name)
			tactics.start()


func pause(_pause: bool) -> void:
	is_paused = _pause
	visible = _pause
	get_tree().paused = _pause
