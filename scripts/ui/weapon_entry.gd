@tool
extends CenterContainer
class_name WeaponEntry

@export_group("Nodes")
@export var title_label : RichTextLabel
@export var description_label : RichTextLabel
@export_category("Details")
## The visual placed to show what it is
@export var scene : PackedScene
@export var title : String = "Weapon" :
	set(val):
		title = val
		if Engine.is_editor_hint():
			_update_details()
@export var description : String = "Lorem Ipsum Dolore" :
	set(val):
		description = val
		if Engine.is_editor_hint():
			_update_details()

func _ready():
	_update_details()

func _update_details() -> void:
	title_label.text = title
	description_label.text = description
