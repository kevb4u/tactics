class_name AIStatConfiguration extends Resource

@export var linked_stat : AIStat
@export var override_defaults : bool = false
@export_range(0.0, 1.0) var override_initial_value : float = 0.5
@export_range(0.0, 1.0) var override_decay_rate : float = 0.005
