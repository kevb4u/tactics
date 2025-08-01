class_name ConversationPanel extends LayoutAnchor

signal finished

@export var message: RichTextLabel
@export var speaker: TextureRect
@export var arrow: Node

@export var anchor_list: Array[PanelAnchor] = []

var _parent: ConversationController

func _ready():
	_parent = get_node("../")


func get_my_anchor(anchor_name: String):
	for anchor in self.anchor_list:
		if anchor.anchor_name == anchor_name:
			return anchor
	return null


func display(sd: SpeakerData):
	speaker.texture = sd.speaker
	speaker.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	speaker.size.x = 56
	speaker.size.y = 83
	#speaker.size = speaker.texture.get_size()
	
	#Resets the anchor point after resizing.
	speaker.anchors_preset = speaker.anchors_preset
	
	for i in sd.messages.size():
		message.text = tr(sd.messages[i])
		arrow.visible = i + 1 < sd.messages.size()
		await _parent.resume
		if _parent.is_active == false:
			break
	
	finished.emit()
