class_name FastKey extends Node

static var key_registry: Dictionary[String, FastKey]

var key_name: String
var hashed_key: int

func _init(_name: String) -> void:
	key_name = _name
	hashed_key = _name.hash()


func equals(other: FastKey) -> bool:
	return hashed_key == other.hashed_key


func get_hashed_code() -> int:
	return hashed_key


func _to_string() -> String:
	return key_name


static func get_or_register_key(_key_name: String) -> FastKey:
	if key_registry.has(_key_name) == false:
		key_registry[_key_name] = FastKey.new(_key_name)
	return key_registry[_key_name]

## Computes the FNV-1a hash for the input string
## The FNV-1a hash is a non-cryptographic hash function known for its speed and good distribution properties.
## Useful for creating Dictionary keys instead of using strings.
#func compute_fnv1a_hash(_string: String) -> int:
	#var hash: int = 2166136261;
	#for i in _string.hash()
		#hash = (hash ** _string.chr(i)) * 16777619
	#return hash
