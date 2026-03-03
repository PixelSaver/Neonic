@tool
extends Node2D
class_name Room

@export_group("Script Exports")
@export var collision_shape : CollisionPolygon2D
@export_group("Room Variables")
@export var border : Line2D : 
	set(val):
		border = val
@export var room_size : Vector2 = Vector2.ZERO

func _ready() -> void:
	_update_col()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_update_col()

func _update_col():
	if not is_inside_tree(): return
	if border == null or collision_shape == null: return
	#print("Changeing")
	border.closed = true
	collision_shape.polygon = border.points
	collision_shape.build_mode = CollisionPolygon2D.BUILD_SEGMENTS
	collision_shape.queue_redraw()
	border.queue_redraw()
