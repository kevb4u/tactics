class_name AbilityMenuPanelController extends Node

signal selected(entry: int)

const show_key: String = "Show"
const hide_key: String = "Hide"
const entry_pool_key: String = "AbilityMenuPanel.Entry"
const menu_count: int = 4

@export var entry_prefab: PackedScene
@export var title_label:Label
@export var panel: AbilityMenuPanel
@export var entry_vbox:VBoxContainer

var _owner: BattleController
var menu_entries: Array[AbilityMenuEntry] = []
var selection:int
var add_pool: bool = false

func _ready() -> void:
	_owner = get_node("../")
	panel.set_position(hide_key, false)
	_disable_node(panel)


func init() -> void:
	if add_pool == false:
		add_pool = true
		_owner.pool_controller.add_entry(entry_pool_key, entry_prefab, menu_count, Global.max_signed_int_32)
		panel.set_position(hide_key, false)
		_disable_node(panel)


func show(title: String, options: Array[String]):
	_enable_node(panel)
	clear()
	title_label.text = tr(title)
	for option in options:
		var entry: AbilityMenuEntry = dequeue()
		entry.title = tr(option)
		menu_entries.append(entry)
	set_selection(0)
	await panel.set_position(show_key, true)


func hide():
	await panel.set_position(hide_key, true)
	clear()
	
	#force panel to shink before fitting to the correct size
	panel.size = Vector2(0,0)
	panel.set_position(hide_key, false)
	
	_disable_node(panel)


func set_locked(index: int, value: bool):
	if( index < 0 || index >= menu_entries.size()):
		return
	
	menu_entries[index].is_locked = value
	if (value && selection == index):
		next()


func next():
	if menu_entries.size() == 0:
		return
	for i in range(selection + 1, menu_entries.size() +2):
		var index:int = i % menu_entries.size()
		if set_selection(index):
			break


func previous():
	if menu_entries.size() == 0:
		return
	for i in range(selection - 1 + menu_entries.size(), selection, -1):
		var index:int = i % menu_entries.size()
		if set_selection(index):
			break


## Add entry to PoolData
func enqueue(entry: AbilityMenuEntry):
	var p: Poolable = entry.get_parent()
	_owner.pool_controller.enqueue(p)


## Remove entry from PoolData
func dequeue() -> AbilityMenuEntry:
	var p: Poolable = _owner.pool_controller.dequeue(entry_pool_key)
	var entry: AbilityMenuEntry = p.get_node("Entry")
	
	if(p.get_parent()):
		p.get_parent().remove_child(p)
	entry_vbox.add_child(p)
	_enable_node(p)
	entry.selected.connect(_on_select)
	entry.reset()
	return entry


## Returns objects to the pool and cleans up the array
func clear():
	for i in range(menu_entries.size()-1, -1, -1):
		menu_entries[i].selected.disconnect(_on_select)
		enqueue(menu_entries[i])
	menu_entries.clear()


## Has some checks if an option is locked or out of bounds and returns false, 
## otherwise it sets the selection index and returns true
func set_selection(value: int)->bool:
	if menu_entries[value].is_locked:
		return false
	
	#Deselect the previously selected entry
	if (selection >= 0 && selection < menu_entries.size()):
		menu_entries[selection].is_selected = false
	
	selection = value
	
	#Select the new entry
	if(selection >= 0 && selection < menu_entries.size()):
		menu_entries[selection].is_selected = true
	
	return true


func _on_select(entry: AbilityMenuEntry) -> void:
	selected.emit(menu_entries.find(entry))


func _enable_node(node: Node) -> void:
	if node.process_mode == Node.PROCESS_MODE_INHERIT and not node is Poolable:
		return
	node.process_mode = Node.PROCESS_MODE_INHERIT
	node.show()


func _disable_node(node: Node) -> void:
	if node.process_mode == Node.PROCESS_MODE_DISABLED and not node is Poolable:
		return
	node.process_mode = Node.PROCESS_MODE_DISABLED
	node.hide()
