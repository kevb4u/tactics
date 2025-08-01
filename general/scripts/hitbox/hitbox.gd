class_name Hitbox extends Area2D

@export var parent: Node2D

func _ready() -> void:
	area_entered.connect(on_area_enter)


func on_area_enter(a: Area2D) -> void:
	if a is Hurtbox:
		print("Hit")
