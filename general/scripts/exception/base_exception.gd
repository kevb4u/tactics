class_name BaseException extends Node

var toggle: bool
var default_toggle: bool

func _init(default:bool) -> void:
	default_toggle = default
	toggle = default_toggle


func flip_toggle() -> void:
	toggle = !default_toggle
