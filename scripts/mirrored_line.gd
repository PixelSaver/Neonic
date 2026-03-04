@tool 
extends Line2D

@export_group("Nodes")
@export var collision_shape : CollisionPolygon2D
@export var mirrored_line : Line2D
@export_group("Tweakables")
#@export var player_size : float = 80 : 
	#set(val):
		#player_size = val
		#if Engine.is_editor_hint():
			#_update_col()

func _process(_delta: float) -> void:
	if not Engine.is_editor_hint(): return
	_update_col()

func _update_col():
	if not is_inside_tree(): return
	if !Engine.is_editor_hint(): return
	
	position = Vector2.ZERO
	mirrored_line.clear_points()
	for point in points:
		mirrored_line.add_point(point * Vector2(1, -1))
	mirrored_line.queue_redraw()
	var _points = points
	var _mirrored = mirrored_line.points
	_mirrored.reverse()
	_points.append_array(_mirrored)
	collision_shape.polygon = PackedVector2Array(_points)
