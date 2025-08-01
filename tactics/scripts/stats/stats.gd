class_name Stats extends Node

var data: Array[int] = []
var will_change_notifications = {}
var did_change_notifications = {}

func _ready() -> void:
	data.resize(StatTypes.Stat.size())
	data.fill(0)


func get_stat(stat_type: StatTypes.Stat) -> int:
	return data[stat_type]


func set_stat(stat_type: StatTypes.Stat, value: int, allow_exceptions: bool = true):
	var old_value: int = data[stat_type]
	if old_value == value:
		return
	
	if allow_exceptions:
		# Allow exceptions to the rule here
		var exc: ValueChangeException = ValueChangeException.new(old_value, value)
		
		# The notification is unique per stat type
		will_change_notification(stat_type).emit(self, exc)

		# Did anything modify the value?
		value = floori(exc.get_modified_value())
		
		# Did something nullify the change?
		if exc.toggle == false || value == old_value:
			return
		
	data[stat_type] = value
	did_change_notification(stat_type).emit(self, old_value)


## When the setter calls the notification, 
## the corresponding dictionary is checked if it has the value and returns if it does, 
## otherwise it will create and add the notification to the dictionary.
func will_change_notification(stat_type: StatTypes.Stat):
	var stat_name = StatTypes.Stat.keys()[stat_type]
	
	if(!will_change_notifications.has(stat_name)):
		self.add_user_signal(stat_name + "_willChange")
		will_change_notifications[stat_name] = Signal(self, stat_name + "_willChange")
		
	return will_change_notifications[stat_name]


func did_change_notification(stat_type: StatTypes.Stat):
	var stat_name = StatTypes.Stat.keys()[stat_type]
	
	if(!did_change_notifications.has(stat_name)):
		self.add_user_signal(stat_name + "_didChange")
		did_change_notifications[stat_name] = Signal(self, stat_name + "_didChange")
		
	return did_change_notifications[stat_name]
