class_name SmartObject extends Node2D

var cached_interaction : Array[BaseInteraction]
var interaction : Array[BaseInteraction]:
	get():
		if cached_interaction.size() == 0:
			for c in get_parent().get_children():
				if c is BaseInteraction:
					cached_interaction.append(c)
		
		return cached_interaction

@export var display_name : String
@export var interaction_marker : Marker2D
var interaction_point : Vector2:
	get():
		if interaction_marker != null:
			return interaction_marker.global_position
		return global_position

func _ready() -> void:
	SmartObjectManager.register_smart_object(self)
	tree_exiting.connect(_on_destroy)
	pass

func _on_destroy() -> void:
	SmartObjectManager.deregister_smart_object(self)
	pass
