class_name DialogSceneComponent extends SceneComponent

@export var data: ConversationData

func start() -> void:
	get_tree().paused = true
	Global.game_controller.conversation_controller.complete_event.connect(finish)
	Global.game_controller.input_controller.mouse_event.connect(next)
	Global.start_conversation(data)


func next(_tile_pos: Tile, button: int) -> void:
	if button >= 0:
		Global.game_controller.conversation_controller.next()


func finish() -> void:
	get_tree().paused = false
	Global.game_controller.conversation_controller.complete_event.disconnect(finish)
	Global.game_controller.input_controller.mouse_event.disconnect(next)
	super()
