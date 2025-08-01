class_name AbilityMenuPanel extends LayoutAnchor

@export var anchor_list: Array[PanelAnchor] = []

func set_position(anchor_name: String, animated: bool) -> void:
	var anchor = get_anchor(anchor_name)
	await to_anchor_position(anchor, animated)


func get_anchor(anchor_name: String) -> PanelAnchor:
	for anchor in self.anchor_list:
		if anchor.anchor_name == anchor_name:
			return anchor
	return null
