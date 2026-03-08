@tool
extends CenterContainer
class_name GunShowcase

@export var line: Line2D
@export var weapon_data : WeaponData = WeaponData.new() :
	set(val):
		weapon_data = val
		_update_showcase()

func _ready():
	_update_showcase()

func _update_showcase() -> void:
	if not weapon_data:
		self.hide()
		return
	self.show()
	if not line: return
	line.global_rotation = -PI/4.
	line.position = Vector2(-50,50)
	line.clear_points()
	line.closed = weapon_data.line_closed
	line.begin_cap_mode = weapon_data.line_cap_front
	line.end_cap_mode = weapon_data.line_cap_back
	line.joint_mode = weapon_data.line_joint 
	line.width = weapon_data.line_width
	
	for point in weapon_data.points:
		line.add_point(point * weapon_data.gun_size)
	line.queue_redraw()
