@tool
extends Line2D
class_name ToolLine

@export var size : float = 1.0 :
	set(val):
		size = val
		_update_points()
@export var _points: PackedVector2Array = [
	Vector2(-0.5, -0.5),
	Vector2( 0.5, -0.5),
	Vector2( 0.5,  0.5),
	Vector2(-0.5,  0.5),
] :
	set(val):
		_points = val
		if Engine.is_editor_hint():
			_update_points()
@export_group("Polygon Tool")
@export var polygon_sides := 6
@export var polygon_radius := 0.5
@export var polygon_angle_offset := 0.0
@export_tool_button("Add Regular Polygon") var add_polygon_action = _add_regular_polygon

func _add_regular_polygon():
	if polygon_sides < 3:
		push_warning("Polygon must have at least 3 sides.")
		return
	
	var new_points := PackedVector2Array()
	var step := TAU / polygon_sides
	
	for i in range(polygon_sides):
		var angle = i * step + polygon_angle_offset
		var p = Vector2.RIGHT.rotated(angle) * polygon_radius
		new_points.append(p)
	
	_points.append_array(new_points)
	_update_points()

func _ready() -> void:
	_update_points()

func _update_points():
	var out : PackedVector2Array = []
	for point in _points:
		out.append(point * size)
	points = out
	self.queue_redraw()
