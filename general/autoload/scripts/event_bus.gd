class_name EventBus extends Node

var events: Dictionary[FastKey, Signal]

func get_or_register_signal(key: FastKey) -> Signal:
	if events.has(key) == false:
		add_user_signal(key.key_name)
		events[key] = Signal(self, key.key_name)
	return events[key]
