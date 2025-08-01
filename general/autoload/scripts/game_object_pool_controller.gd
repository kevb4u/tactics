class_name PoolController extends Node

var pools: Dictionary = {}

func add_entry(key: String, prefab: PackedScene, prepopulate: int, max_count: int) -> bool:
	if pools.has(key):
		return false
	
	var data: PoolData = PoolData.new()
	data.prefab = prefab
	data.max_count = max_count
	pools[key] = data
	for i in prepopulate:
		enqueue(create_instance(key, prefab))
	
	return true


func enqueue(sender: Poolable) -> void:
	if (sender == null || sender.is_pooled || not pools.has(sender.key)):
		return
	
	var data: PoolData = pools[sender.key]
	if data.pool.size() >= data.max_count:
		sender.free()
		return
	
	data.pool.push_back(sender)
	if(sender.get_parent()):
		sender.get_parent().remove_child(sender)
	self.add_child(sender)
	sender.is_pooled = true
	sender.hide()


func dequeue(key: String) -> Poolable:
	if not pools.has(key):
		return null

	var data: PoolData = pools[key]
	if data.pool.size() == 0:
		return create_instance(key, data.prefab)
	
	var obj: Poolable = data.pool.pop_front()
	obj.is_pooled = false
	return obj


func create_instance(key: String, prefab: PackedScene) -> Poolable:
	var instance = prefab.instantiate()
	instance.set_script(Poolable)
	instance.key = key
	return instance


func clear_entry(key: String) -> void:
	if not pools.has(key):
		return
	
	var data: PoolData = pools[key]
	while data.pool.size() > 0:
		var obj: Poolable = data.pool.pop_front()
		obj.free()
	
	pools.erase(key)


func set_max_count(key: String, max_count: int) -> void:
	if not pools.has(key):
		return
	pools[key].max_count = max_count
