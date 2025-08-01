class_name Consumable extends Node

func consume(target_obj: Unit):
	var features: Array[Node] = []
	
	features = self.get_parent().get_children()
	
	var filtered_array = features.filter(func(node):return node is Feature)
	for node in filtered_array:
		node.apply(target_obj)
