class_name StatPanel extends LayoutAnchor

@export var ally_background: Texture2D
@export var enemy_background: Texture2D
@export var background: NinePatchRect
@export var avatar: TextureRect
@export var name_label: Label
@export var hp_label: Label
@export var mp_label: Label
@export var lvl_label: Label

@export var anchor_list: Array[PanelAnchor] = []

func display(obj: Node) -> void:
	var alliance: Alliance = obj.alliance
	background.texture = enemy_background if alliance.type == AllianceType.Alliances.Enemy else ally_background
	#avatar.texture = #Need a component which provides this data
	name_label.text = obj.name
	var stats:Stats = obj.get_node("Stats")
	if stats:
		hp_label.text = "HP {0} / {1}".format([stats.get_stat(StatTypes.Stat.HP), stats.get_stat(StatTypes.Stat.MHP)])
		mp_label.text = "MP {0} / {1}".format([stats.get_stat(StatTypes.Stat.MP), stats.get_stat(StatTypes.Stat.MMP)])
		lvl_label.text = "LV. {0}".format([stats.get_stat(StatTypes.Stat.LVL)])


func set_position(anchorName: String, animated: bool) -> void:
	var anchor = get_anchor(anchorName)
	await to_anchor_position(anchor, animated)


func get_anchor(anchor_name: String) -> PanelAnchor:
	for anchor in self.anchor_list:
		if anchor.anchor_name == anchor_name:
			return anchor
	return null
