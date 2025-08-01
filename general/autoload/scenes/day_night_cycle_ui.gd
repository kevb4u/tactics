class_name DayNightCycleUI extends Control

@onready var time_label: Label = %TimeLabel

func init() -> void:
	Global.game_controller.day_night_cycle.time_tick.connect(set_daytime)


func set_daytime(day: int, hour: int, minute: int) -> void:
	var _hour: String = str(hour)
	if hour < 10:
		_hour = "0" + _hour
	var _min: String = str(minute)
	if minute < 10:
		_min = "0" + _min
	time_label.text = _hour + ":" + _min
