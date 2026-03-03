@tool
extends Node2D
class_name Gun


const POINTS = [
	Vector2(0,-1),
	Vector2(-.5,0),
	Vector2(.5,0),
]

@export_group("Exports")
@export var parent : RigidBody2D
@export var line : Line2D
@export var collision_shape : CollisionPolygon2D
@export_group("Customization")
@export var gun_size : Vector2 = Vector2(2, 2) :
	set(val):
		gun_size = val
		if Engine.is_editor_hint():
			_update_size()
var _parent : RigidBody2D

func _ready() -> void:
	if parent != null:
		_parent = parent
	elif get_parent() != null and get_parent() is RigidBody2D:
		_parent = get_parent()
	else:
		print_tree_pretty()
		push_error("Gun couldn't find parent.")
	
	_update_size()

func _update_size():
	if not is_inside_tree(): return
	if !Engine.is_editor_hint(): return
	
	# Line
	line.position = Vector2.ZERO
	line.closed = true
	line.clear_points()
	for point in POINTS:
		line.add_point(point * gun_size)
	line.queue_redraw()
	
	var points : PackedVector2Array = []
	for point in POINTS:
		points.append(point * gun_size)
	collision_shape.polygon = (points)
