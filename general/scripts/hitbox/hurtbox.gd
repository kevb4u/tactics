class_name Hurtbox extends Area2D

signal on_hurt(hitbox: Hitbox)

func _ready() -> void:
	area_entered.connect(on_area_enter)


func on_area_enter(a: Area2D) -> void:
	if a is Hitbox:
		on_hurt.emit(a)
