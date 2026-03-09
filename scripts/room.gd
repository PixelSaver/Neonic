@tool
extends Node2D
class_name Room

signal room_cleared

@export_group("Script Exports")
@export var enemy_container : Node2D
@export var collision_shape : CollisionPolygon2D
@export var border : Line2D : 
	set(val):
		border = val
@export_group("Room Variables")
@export_tool_button("Reload collision") var action_reload = _update_col
@export var points : PackedVector2Array :
	set(v):
		points = v
		_update_col()
@export var room_size : Vector2 = Vector2.ZERO :
	set(v):
		room_size = v
		_update_col()
@export var wall_thickness := 50.0
@export var wave_data : WaveData

func _ready() -> void:
	_update_col()

#func _process(_delta: float) -> void:
	#if Engine.is_editor_hint():
		#_update_col()

func _update_col():
	if not is_inside_tree(): return
	if border == null or collision_shape == null: return
	#print("Changeing")
	border.closed = true
	border.clear_points()
	var _border_points : PackedVector2Array = []
	for point in points:
		_border_points.append(point * room_size)
	border.points = _border_points
	var poly = border.points
	var offset = Geometry2D.offset_polygon(poly, wall_thickness)
	if offset.size() > 0:
		collision_shape.polygon = offset[0]
	if offset.size() > 1:
		collision_shape.polygon.append_array(offset[1])
	_border_points.reverse()
	_border_points.append(_border_points[0])
	_border_points.append(collision_shape.polygon[collision_shape.polygon.size()-1])
	#_border_points.append(_border_points[_border_points.size()-1])
	collision_shape.polygon = collision_shape.polygon + _border_points
	collision_shape.build_mode = CollisionPolygon2D.BUILD_SOLIDS
	collision_shape.queue_redraw()
	border.queue_redraw()

func clear_enemies():
	for child in enemy_container.get_children():
		child.queue_free()

func spawn_enemies():
	for spawn in wave_data.enemies:
		var inst = spawn.enemy_scene.instantiate()
		enemy_container.add_child(inst)
