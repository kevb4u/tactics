class_name SaveManager

signal on_save
signal on_load

const SAVE_PATH = "user://"

func save_game() -> void:
	on_save.emit()
	var file := FileAccess.open(SAVE_PATH + "save.sav", FileAccess.WRITE)
	var save_json := JSON.stringify(BlackboardManager.save_blackboard())
	file.store_line(save_json)


func get_save_file() -> FileAccess:
	return FileAccess.open(SAVE_PATH + "save.sav", FileAccess.READ)


func load_game() -> void:
	var file := get_save_file()
	var json := JSON.new()
	json.parse(file.get_line())
	var save_dict := json.get_data() as Dictionary
	BlackboardManager.load_blackboard(save_dict)
	on_load.emit()


func delete_save() -> void:
	DirAccess.remove_absolute(SAVE_PATH + "save.sav")
