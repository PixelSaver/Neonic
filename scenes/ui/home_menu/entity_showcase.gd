@tool
extends CenterContainer
class_name EntityShowcase

@export var line: Line2D
@export_tool_button("Update showcase") var action_update_showcase = _update_showcase
@export var entity_data : EntityData :
	set(val):
		entity_data = val
		_update_showcase()

func _ready():
	_update_showcase()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_update_showcase()

func _update_showcase() -> void:
	if not entity_data:
		self.hide()
		return
	self.show()
	if not line: return
	line.global_rotation = entity_data.editor_rotation
	line.position = entity_data.editor_offset
	line.clear_points()
	line.closed = entity_data.line_closed
	line.begin_cap_mode = entity_data.line_cap_front
	line.end_cap_mode = entity_data.line_cap_back
	line.joint_mode = entity_data.line_joint 
	line.width = entity_data.line_width
	
	for point in entity_data.points:
		line.add_point(point * entity_data.size)
	line.scale = Vector2.ONE * entity_data.editor_scale
	line.queue_redraw()
