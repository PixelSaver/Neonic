@tool
extends CenterContainer
class_name EntityShowcase

@export var line: Line2D
@export var entity_data : EntityData :
	set(val):
		entity_data = val
		_update_showcase()

func _ready():
	_update_showcase()

func _update_showcase() -> void:
	if not entity_data:
		self.hide()
		return
	self.show()
	if not line: return
	line.global_rotation = -PI/4.
	line.position = Vector2(-50,50)
	line.clear_points()
	line.closed = entity_data.line_closed
	line.begin_cap_mode = entity_data.line_cap_front
	line.end_cap_mode = entity_data.line_cap_back
	line.joint_mode = entity_data.line_joint 
	line.width = entity_data.line_width
	
	for point in entity_data.points:
		line.add_point(point * entity_data.gun_size)
	line.queue_redraw()
