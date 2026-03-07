@tool
extends Line2D
class_name BoxLine

@export var target : Control:
	set(v):
		target = v
		_update_points()
@export var outline_proportion := Vector2(1.0, 1.0) :
	set(v):
		outline_proportion = v
		_update_points()
@export var flip_h := false:
	set(v):
		flip_h = v
		_update_points()

func _ready() -> void:
	_update_points()
	target.pivot_offset_ratio = Vector2.ONE * 0.5

func _update_points():
	if not target:
		return
	
	if !Engine.is_editor_hint(): 
		target.scale.y = outline_proportion.y
	
	var flip = -1 if flip_h else 1
	global_position = target.global_position + target.size * \
		Vector2(outline_proportion.x * 0.5 * flip, 0.5 * target.scale.y) + \
		target.size * Vector2(1,0) * (1 if flip_h else 0)
	self.closed = true
	var rect = target.size
	var w = rect.x
	var h = rect.y

	var sx = w * outline_proportion.x
	var sy = h * outline_proportion.y

	var out : PackedVector2Array = []
	out.append(Vector2( sx * 0.5, 0 ))
	out.append(Vector2( sx * 0.5,  sy * 0.5))
	out.append(Vector2(-sx * 0.5,  sy * 0.5))
	out.append(Vector2(-sx * 0.5, -sy * 0.5))
	out.append(Vector2( sx * 0.5, -sy * 0.5))
	out.append(Vector2( sx * 0.5, 0 ))

	points = out
