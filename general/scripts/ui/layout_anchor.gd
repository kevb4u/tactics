class_name LayoutAnchor extends Node


func move_to_anchor_position(my_anchor: Control.LayoutPreset, parent_anchor: Control.LayoutPreset, 
		offset: Vector2, duration: float, trans: Tween.TransitionType = Tween.TRANS_LINEAR,
		anchor_ease: Tween.EaseType = Tween.EASE_IN_OUT):
	
	var parent_vector: Vector2 = get_parent_anchor(parent_anchor)
	var my_offsets: Rect2 = get_my_offsets(my_anchor, offset)
	
	var tween = create_tween()
	tween.set_trans(trans).set_ease(anchor_ease).set_parallel(true)
	
	if get("anchor_left"):
		tween.tween_property(self, "anchor_left", parent_vector.x, duration)
		tween.tween_property(self, "anchor_right", parent_vector.x, duration)
		tween.tween_property(self, "anchor_top", parent_vector.y, duration)
		tween.tween_property(self, "anchor_bottom", parent_vector.y, duration)
	
	tween.tween_property(self, "offset_left", my_offsets.position.x, duration)
	tween.tween_property(self, "offset_right", my_offsets.end.x, duration)
	tween.tween_property(self, "offset_top", my_offsets.position.y, duration)
	tween.tween_property(self, "offset_bottom", my_offsets.end.y, duration)
	
	await tween.finished


func snap_to_anchor_position(my_anchor: Control.LayoutPreset, parent_anchor:Control.LayoutPreset, offset:Vector2):
	var parent_vector: Vector2 = get_parent_anchor(parent_anchor)
	var my_offsets: Rect2 = get_my_offsets(my_anchor, offset)
	
	self.anchor_left = parent_vector.x
	self.anchor_right = parent_vector.x
	self.anchor_top = parent_vector.y
	self.anchor_bottom = parent_vector.y
	
	self.offset_left = my_offsets.position.x
	self.offset_right = my_offsets.end.x
	self.offset_top = my_offsets.position.y
	self.offset_bottom = my_offsets.end.y


func to_anchor_position(anchor: PanelAnchor,animated: bool):
	if animated:
		await move_to_anchor_position(anchor.my_anchor, anchor.parent_anchor, anchor.offset, anchor.duration, anchor.trans, anchor.anchor_ease)
	else:
		snap_to_anchor_position(anchor.my_anchor, anchor.parent_anchor, anchor.offset)


func get_parent_anchor(anchor: Control.LayoutPreset) -> Vector2:
	var ret_value: Vector2 = Vector2.ZERO
	#Set the x value of our return
	match anchor:
		Control.PRESET_TOP_RIGHT, Control.PRESET_BOTTOM_RIGHT, Control.PRESET_CENTER_RIGHT:
			ret_value.x = 1
		Control.PRESET_CENTER_TOP, Control.PRESET_CENTER_BOTTOM, Control.PRESET_CENTER:
			ret_value.x = .5
		_:
			ret_value.x = 0
	
	#Set the y value of our return
	match anchor:
		Control.PRESET_BOTTOM_LEFT, Control.PRESET_BOTTOM_RIGHT, Control.PRESET_CENTER_BOTTOM:
			ret_value.y = 1
		Control.PRESET_CENTER_LEFT, Control.PRESET_CENTER_RIGHT, Control.PRESET_CENTER:
			ret_value.y = .5
		_:
			ret_value.y = 0
			
	return ret_value


func get_my_offsets(anchor: Control.LayoutPreset, offset: Vector2) -> Rect2:
	var ret_value: Rect2 = Rect2()
	
	#Set the x value of our return
	match anchor:
		Control.PRESET_TOP_RIGHT, Control.PRESET_BOTTOM_RIGHT, Control.PRESET_CENTER_RIGHT:
			ret_value.position.x = -1 * self.size.x
		Control.PRESET_CENTER_TOP, Control.PRESET_CENTER_BOTTOM, Control.PRESET_CENTER:
			ret_value.position.x = -.5 * self.size.x
		_:
			ret_value.position.x = 0
	
	#Set the y value of our return
	match anchor:
		Control.PRESET_BOTTOM_LEFT, Control.PRESET_BOTTOM_RIGHT, Control.PRESET_CENTER_BOTTOM:
			ret_value.position.y = -1 * self.size.y
		Control.PRESET_CENTER_LEFT, Control.PRESET_CENTER_RIGHT, Control.PRESET_CENTER:
			ret_value.position.y = -.5 * self.size.y
		_:
			ret_value.position.y = 0
	
	ret_value.position += offset
	ret_value.end = ret_value.position + self.size
	return ret_value
