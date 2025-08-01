class_name AIStat extends Resource

@export var display_name : String
## The higher the number the more likely it will pick this stat interaction
@export_range(0, Global.max_signed_int_32) var priority: int = 1
@export var is_visible : bool = true
@export_range(0.0, 1.0) var initial_value : float = 0.5
## 1.0 = 1 full in game day, 0.5 = 0.5 full in game day
@export_range(0.0, 1.0) var decay_rate : float = 1.0 
