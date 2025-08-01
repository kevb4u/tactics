class_name SmartObjectManager extends Node

static var registered_objects : Array[SmartObject]:
	set(value):
		pass

static func register_smart_object(_smart_object : SmartObject) -> void:
	registered_objects.append(_smart_object)


static func deregister_smart_object(_smart_object : SmartObject) -> void:
	registered_objects.erase(_smart_object)
