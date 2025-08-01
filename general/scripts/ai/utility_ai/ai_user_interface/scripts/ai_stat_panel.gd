class_name AIStatPanel extends ProgressBar

@export var link_stat : AIStat
@onready var label: Label = $Label

func bind(stat: AIStat, initial_value: float) -> void:
	link_stat = stat
	label.text = stat.display_name
	value = initial_value
	pass

func on_stat_changed(new_value: float) -> void:
	value = new_value
	pass
