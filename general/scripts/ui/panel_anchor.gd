class_name PanelAnchor extends Resource


@export var anchor_name: String
@export var my_anchor: Control.LayoutPreset
@export var parent_anchor: Control.LayoutPreset
@export var offset: Vector2
@export var duration: float = 0.5
@export var trans: Tween.TransitionType = Tween.TRANS_LINEAR
@export var anchor_ease: Tween.EaseType = Tween.EASE_IN_OUT


func set_values(a_name, m_anchor, p_anchor, v2offset, dur = 0.5, tran = Tween.TRANS_LINEAR, a_ease = Tween.EASE_IN_OUT):
	anchor_name = a_name
	my_anchor = m_anchor
	parent_anchor = p_anchor
	offset = v2offset
	duration = dur
	trans = tran
	anchor_ease = a_ease
