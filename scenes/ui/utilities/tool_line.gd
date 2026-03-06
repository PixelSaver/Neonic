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

func _ready() -> void:
	_update_points()

func _update_points():
	var out : PackedVector2Array = []
	for point in _points:
		out.append(point * size)
	points = out
	self.queue_redraw()
