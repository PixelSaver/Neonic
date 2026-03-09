@tool
extends CenterContainer
class_name WeaponEntry

@export_group("Nodes")
@export var title_label : RichTextLabel
@export var description_label : RichTextLabel
@export_category("Details")
## The visual placed to show what it is
@export var entity_data : EntityData :
	set(val):
		entity_data = val
		if Engine.is_editor_hint():
			_update_details()
var _parent: RadialContainer

func _ready():
	_parent = get_parent() as RadialContainer
	_update_details()


func _update_details() -> void:
	title_label.text = entity_data.entity_name
	description_label.text = entity_data.entity_description

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		if _parent:
			_parent.scroll_to_child(self)
